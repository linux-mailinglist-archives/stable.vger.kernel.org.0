Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A27633506
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 18:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbfFCQeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 12:34:02 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:43046 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbfFCQeC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 12:34:02 -0400
Received: by mail-yw1-f65.google.com with SMTP id t5so7779555ywf.10;
        Mon, 03 Jun 2019 09:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NS9jbidsTjt8uIbLTVUhJinXzdbo3OkZBbHkpb2WV0A=;
        b=iX/ZKmV0z83R3UhFOkARskTLTPJIZOXfQUJAbRUJFdrMUnL/XlR8M5SsYDttKL5j1p
         HybqQq4bQxHv39uhOnXWvcw1M/dMmDE0idCPsfOa37keaAUa/Fbl2pb7Ar0+h3KAeaf7
         jlXJm6Y/BhyHlY99QuUu4vhioWImBsYQVyVhFDJr41e85NnrO4ps8xUzssMXUbnIQ76v
         fIAoPQczSMQstITZ3yNRjjJJ0BJjT6YQ0P7Ee2ubdCjxun884Hy8KVUEHWzuriJQAa/6
         z+nd9Umz3+ZqrVcSDNsqOLM9is8L+9xowStQg5pCFq7XJu2FXwqLZo9Zky4Qhw8zDPMz
         T4jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NS9jbidsTjt8uIbLTVUhJinXzdbo3OkZBbHkpb2WV0A=;
        b=ZV4eMQQTaDARnSM5DY6ppd6BAH9ynV5JouXxF2VrhaEiZemYmmdmN0HkE/WSq5HQgn
         I/GYDNymJoQDffB8MizmKDegsdvm/6/KmV0HhUfp7r8EZSni6msGR6kTlOsa/zAZAP+I
         jJrIcmIPm4kJK5ZCfEubXWhUA7Sc5zclOssqJ1Rz/zYu8wwwXZNfF6R1O7j2BsXLYAaB
         UU8u+XZkJi4X8FcrQwvR2N0glRo6eXJMkKrTEpF53tk5NE3tdjo7sd/ggbGxutwiqcsA
         CstH3Zbt+3MG+ZHPPpBWAEa6eUB8G9V3vjVryL45WOflU01xfbD+uVY/JrvLQcMqNFH+
         Yftw==
X-Gm-Message-State: APjAAAXBw/z1iNEI6w/B7IsLNC++z/XAT3sHQOCEx+qRI0RTSvZy7AHv
        RU5cZ9j8DZVT8Jq/a58urT3wJB2ry+R/wPCI1E0=
X-Google-Smtp-Source: APXvYqzEIndDah4HIBa5VMS14CjPN3RDSIYZXkRJOr5nlfrmuJIr8YVGC/nRNC/gLXBjX9LUe9kvNiOFWMnTZmDTNsg=
X-Received: by 2002:a81:7096:: with SMTP id l144mr15123361ywc.294.1559579641430;
 Mon, 03 Jun 2019 09:34:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190603132155.20600-1-jack@suse.cz> <20190603132155.20600-3-jack@suse.cz>
In-Reply-To: <20190603132155.20600-3-jack@suse.cz>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 3 Jun 2019 19:33:50 +0300
Message-ID: <CAOQ4uxgn7_tY35KVE6c-na2skXtxXhrM8-2wRNUe2CtmYACZrg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ext4: Fix stale data exposure when read races with
 hole punch
To:     Jan Kara <jack@suse.cz>
Cc:     Ext4 <linux-ext4@vger.kernel.org>, Ted Tso <tytso@mit.edu>,
        Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 3, 2019 at 4:22 PM Jan Kara <jack@suse.cz> wrote:
>
> Hole puching currently evicts pages from page cache and then goes on to
> remove blocks from the inode. This happens under both i_mmap_sem and
> i_rwsem held exclusively which provides appropriate serialization with
> racing page faults. However there is currently nothing that prevents
> ordinary read(2) from racing with the hole punch and instantiating page
> cache page after hole punching has evicted page cache but before it has
> removed blocks from the inode. This page cache page will be mapping soon
> to be freed block and that can lead to returning stale data to userspace
> or even filesystem corruption.
>
> Fix the problem by protecting reads as well as readahead requests with
> i_mmap_sem.
>

So ->write_iter() does not take  i_mmap_sem right?
and therefore mixed randrw workload is not expected to regress heavily
because of this change?

Did you test performance diff?
Here [1] I posted results of fio test that did x5 worse in xfs vs.
ext4, but I've
seen much worse cases.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-fsdevel/CAOQ4uxhu=Qtme9RJ7uZXYXt0UE+=xD+OC4gQ9EYkDC1ap8Hizg@mail.gmail.com/

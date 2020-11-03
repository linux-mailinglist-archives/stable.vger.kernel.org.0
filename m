Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07432A3A96
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 03:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgKCCus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 21:50:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38341 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726104AbgKCCus (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 21:50:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604371847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CW/ACUV2Mng49qFZGRiWeYHvjBj6rU/+vNlelQ6F/Jg=;
        b=gZt9yAkrMnyicYN6MaiNWr6LGRTtEIyIx6TEJvRBOrxHIqlR6aV3s/B5UCEv318wL8USIu
        jV92iNBCOJzNx0NHNoeKs3Yrel3kksQPHJpZ7oqa2PQB0vSVTgROpQNPkPFQIoX+29Dhl8
        bcNQVvRjZsL/Ua1eO7Zkh4O8gcAXhBk=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-SYXRrFzhPXGfYvmikgNDKQ-1; Mon, 02 Nov 2020 21:50:46 -0500
X-MC-Unique: SYXRrFzhPXGfYvmikgNDKQ-1
Received: by mail-pl1-f199.google.com with SMTP id z11so9809108pln.0
        for <stable@vger.kernel.org>; Mon, 02 Nov 2020 18:50:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CW/ACUV2Mng49qFZGRiWeYHvjBj6rU/+vNlelQ6F/Jg=;
        b=J/DvaktWfmjd22VH/lhVVJp23qR20xkT6GTAXxZ+ec1wewvqB2R6LYyYEk8Ho8M5yH
         4D+NJOHY1zo3Qz2oDHMN6g0WxL7yf5j/6zNee4YrDHFbX+jXzEaSsnNboiyyl47hnObO
         4+RGy0ewa/heIgRmqHw4vIV3k+UysZFyN4LNTic8O3euK0P1Z50FTsv09haeA0vebpGB
         Nw7myoQkE3XW74JFLGMX9QuNY4M6fRmwRyoWV5RamAJUzwWYQUTBuAI2HgouEQl0VXuk
         FHOeoQ4mktgMsSGnneL3mQblF2nleEq4lMsw+5xi1zTmnbuyLhCWmwKG8vhw4kiTGEbN
         rC7A==
X-Gm-Message-State: AOAM532DRt5RKSUQNM2c1QMqjXe9XLXLukLeubIBR500+QAFso6xn1Ed
        lHJ8Ta78T+LnYLST94KUK+WDKD/QA3I8E2txp3Pq6HS8Y2tijh/v/dB1wxC7WeanUd7pOyh6UJz
        qrUeLkpfr3CaBxSoX
X-Received: by 2002:a17:90b:684:: with SMTP id m4mr1300027pjz.133.1604371844613;
        Mon, 02 Nov 2020 18:50:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxgqZp4MURbMJ28PFb6nSGA5bU2+CHwFJgndLAIBQBWizeUfCGjfADDys+ArVZnBuIwNraXpw==
X-Received: by 2002:a17:90b:684:: with SMTP id m4mr1300005pjz.133.1604371844358;
        Mon, 02 Nov 2020 18:50:44 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v3sm830911pju.38.2020.11.02.18.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 18:50:43 -0800 (PST)
Date:   Tue, 3 Nov 2020 10:50:33 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Chao Yu <yuchao0@huawei.com>, Chao Yu <chao@kernel.org>
Cc:     linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        nl6720 <nl6720@gmail.com>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] erofs: derive atime instead of leaving it empty
Message-ID: <20201103025033.GA788000@xiangao.remote.csb>
References: <20201031195102.21221-1-hsiangkao.ref@aol.com>
 <20201031195102.21221-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201031195102.21221-1-hsiangkao@aol.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Chao,

On Sun, Nov 01, 2020 at 03:51:02AM +0800, Gao Xiang wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> EROFS has _only one_ ondisk timestamp (ctime is currently
> documented and recorded, we might also record mtime instead
> with a new compat feature if needed) for each extended inode
> since EROFS isn't mainly for archival purposes so no need to
> keep all timestamps on disk especially for Android scenarios
> due to security concerns. Also, romfs/cramfs don't have their
> own on-disk timestamp, and squashfs only records mtime instead.
> 
> Let's also derive access time from ondisk timestamp rather than
> leaving it empty, and if mtime/atime for each file are really
> needed for specific scenarios as well, we can also use xattrs
> to record them then.
> 
> Reported-by: nl6720 <nl6720@gmail.com>
> [ Gao Xiang: It'd be better to backport for user-friendly concern. ]
> Fixes: 431339ba9042 ("staging: erofs: add inode operations")
> Cc: stable <stable@vger.kernel.org> # 4.19+
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

May I ask for some extra free slots to review this patch plus 
[PATCH 1/4] of 
https://lore.kernel.org/r/20201022145724.27284-1-hsiangkao@aol.com

since it'd be also in linux-next for a while before sending out
to Linus. And the debugging messages may also be an annoying
thing for users.

Thanks a lot!

Thanks,
Gao Xiang


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4D03DAFAD
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 01:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhG2XBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 19:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234448AbhG2XBb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 19:01:31 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29409C061765
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 16:01:27 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id h9so9626970ljq.8
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 16:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pY7m/Y43lyncS7WapXCMkLBirYxokclAcy/UGj99rQA=;
        b=XQtQEX/BG2JXB6WBNf/JB98ExbQAGG37D1sqjMTQzcAlbBF3cE9jO6h35na96096Nt
         9bLwxHZ0OUkMyTGxEIoxMov84KKm2MpsHsc39n6CfhXg+fMQAWyIBI3nG4bncuHMl/08
         g6bfAX7f+TIZ2iNmLpTBNrEuEjPlYNygVzzo8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pY7m/Y43lyncS7WapXCMkLBirYxokclAcy/UGj99rQA=;
        b=coYRgQ1zGP3SqUCZvj502i7B0rWGip8cemiCK6RolfrSf6NSaA1dnVJORSkkTmU//C
         UA73eqI6lMiXhV6c6Jguwj1LpHqx4+aDABZaY5FScaBnQetaxYNnRd72Uc46uVjfpamt
         W/fuurL5jHV68thjE9yWQsmEvN2VJ71geeAvmtCbMPandWqrO/ZeYPOxpPC6EnvmhMYI
         6NagpIlpd6OzSKgr3ZvppWYPyD832TGq+dd2tCYaZ+EzlBoqvDNd/J18TTIs+SKhFQ5U
         a38Sm2AsnmYPH4GysOMp1ZwlKvAodneAloHO/iHhhEvsTQoXrd7vWE1LC2xqTOwg03hw
         PzPw==
X-Gm-Message-State: AOAM532Utc14CFsgcOOseqV0g3zKk95nwLS7yxa40SWogoqt77UwQixV
        GqaKhe8ZxyswazDrUmlzX1MKSW8dLwaRRRIS
X-Google-Smtp-Source: ABdhPJwaj7fRnhplEhTam5gvK9qKrH6eH1BzoOZPKCksIi/stQ/L56/vVk05PcR0gjWV14nq4BEfpg==
X-Received: by 2002:a05:651c:12c4:: with SMTP id 4mr4286269lje.320.1627599685307;
        Thu, 29 Jul 2021 16:01:25 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id r24sm251491ljn.87.2021.07.29.16.01.24
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 16:01:24 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id x8so590238lfe.3
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 16:01:24 -0700 (PDT)
X-Received: by 2002:a19:c3c1:: with SMTP id t184mr5315383lff.41.1627599683697;
 Thu, 29 Jul 2021 16:01:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210729222635.2937453-1-sspatil@android.com> <20210729222635.2937453-2-sspatil@android.com>
In-Reply-To: <20210729222635.2937453-2-sspatil@android.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 29 Jul 2021 16:01:07 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh-DWvsFykwAy6uwyv24nasJ39d7SHT+15x+xEXBtSm_Q@mail.gmail.com>
Message-ID: <CAHk-=wh-DWvsFykwAy6uwyv24nasJ39d7SHT+15x+xEXBtSm_Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] fs: pipe: wakeup readers everytime new data written
 is to pipe
To:     Sandeep Patil <sspatil@android.com>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 29, 2021 at 3:27 PM Sandeep Patil <sspatil@android.com> wrote:
>
> So restore the old behavior to wakeup all readers if any new data is
> written to the pipe.

Ah-hahh.

I've had this slightly smaller patch waiting for the better part of a year:

  https://lore.kernel.org/lkml/CAHk-=wgjR7Nd4CyDoi3SH9kPJp_Td9S-hhFJZMqvp6GS1Ww8eg@mail.gmail.com/

waiting to see if some broken program actually depends on the bogus
epollet semantics.

Can you verify that that patch fixes the realm-core brokenness too?

             Linus

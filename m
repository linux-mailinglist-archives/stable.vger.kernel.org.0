Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1222C4CEDAE
	for <lists+stable@lfdr.de>; Sun,  6 Mar 2022 21:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbiCFUcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 15:32:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiCFUcL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 15:32:11 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9DE857B1F
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 12:31:16 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id 25so4152900ljv.10
        for <stable@vger.kernel.org>; Sun, 06 Mar 2022 12:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o4x3LB+e0ici79Acsr0qTkXLlNi+AeRm0Pw056tojvw=;
        b=h0YGKLCxmfD+Tuht2lkOVwseUarTkmVqA6F1b6hNY12cXjmK+zrbrkXq4bDDJ6G/Ok
         sR4TbLfaQifk1zBlAaJkzinXjrhZNpQRsAKGSrPYqo3Tn/Z+PSqyRA7eekf0bPTcE8o7
         YN0tht/85YfO+73tf2QooGvk4g8RManlAoWBM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o4x3LB+e0ici79Acsr0qTkXLlNi+AeRm0Pw056tojvw=;
        b=hafCgDE1WPMx0aiaZelJ9Di0IiywI7JkrnsboO7asvqS6Jf1OFcZ+QaZiMESxX2BCl
         P5cJJaxVAki6QhYSa1SIJKtJEywqGN9bue0wIsf6vXmI5NUC3hJ4bmSW5idPMoyt19K1
         Lu0U2PXkUsF1d90IYV9tylqRDwoEh3c0W9OfQ02tSZH7znQP1YxkiRQ/4UQddO3lBh3p
         ZknZ+27zn4jvWINtntoAmdWvoaLqto3qqMg4UVwtDQYU1SPJ0gKbIAfk/KJ7wxUFPR/A
         I/oV4XB0wdft7jE/qJXXmo14GxSoUOt1dA5Ko5F0NKn05PxMBLscwXJ2ot5cy7MGpGa/
         Ib0A==
X-Gm-Message-State: AOAM531UhG+2vyGv44jcKSvosL0/U1XiBawBMsiEcHxko1mGfh4tIlSc
        9t38C1brjdMJxbu1MgvKA1D4G5Z7ZzTzkldENtE=
X-Google-Smtp-Source: ABdhPJzSN+lRd9Smuz3BYbDNbLu7ICkGMPjChDq3hbyehKEs22+AarlOk/7UAqJQYqAi8yU8rA756g==
X-Received: by 2002:a2e:9cd:0:b0:244:d41d:69ef with SMTP id 196-20020a2e09cd000000b00244d41d69efmr5415635ljj.386.1646598673765;
        Sun, 06 Mar 2022 12:31:13 -0800 (PST)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id a22-20020a194f56000000b0044830cf3965sm161286lfk.300.2022.03.06.12.31.11
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Mar 2022 12:31:12 -0800 (PST)
Received: by mail-lf1-f47.google.com with SMTP id 5so21036623lfz.9
        for <stable@vger.kernel.org>; Sun, 06 Mar 2022 12:31:11 -0800 (PST)
X-Received: by 2002:a05:6512:e8a:b0:443:7b8c:579a with SMTP id
 bi10-20020a0565120e8a00b004437b8c579amr5784609lfb.687.1646598671471; Sun, 06
 Mar 2022 12:31:11 -0800 (PST)
MIME-Version: 1.0
References: <20220305170714.2043896-1-pasic@linux.ibm.com> <CAHk-=wgZ6fNG03pd2pAVw9RtymwPDyHNvTLHr2Q3LX3S0Y1k5Q@mail.gmail.com>
 <YiRpuGbjyU2M47pQ@infradead.org>
In-Reply-To: <YiRpuGbjyU2M47pQ@infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 6 Mar 2022 12:30:55 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgQGLgqqgsKXUCykiK9B1UwdCj2-NvDkBAuYhSgdtAmkQ@mail.gmail.com>
Message-ID: <CAHk-=wgQGLgqqgsKXUCykiK9B1UwdCj2-NvDkBAuYhSgdtAmkQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] swiotlb: rework "fix info leak with DMA_FROM_DEVICE"
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        stable <stable@vger.kernel.org>,
        Doug Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        iommu <iommu@lists.linux-foundation.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 5, 2022 at 11:58 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> All of thee apply to all I/O.  SG_IO is just a vector here as a
> particularly badly designed userspace interface that happens to get a
> decent test coverage.

I phrased that badly. I didn't mean SG_IO in particular, I meant any
of the "generate special commands" interfaces.

In particular, I meant it as "not *regular* read/write commands".

It seems extremely wasteful to do a completely unnecessary bounce
buffer operation for READ/WRITE commands.

Because honestly, if *those* are broken on some DMA device and they
don't fill the buffer completely - despite claiming they do - then
that device is so terminally broken that it's not even worth worrying
about.

So I would expect that

 (a) READ/WRITE actually fills the whole buffer

 (b) READ/WRITE are the only ones where we care about performance at a
bounce-buffer level

so it boils down to "do we still do this horrible memcpy even for
regular IO commands"? Because that would, in my opinion, just be
stupid.

                 Linus

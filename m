Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01FB2518C70
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 20:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240605AbiECSfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 14:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241366AbiECSfv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 14:35:51 -0400
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D4C1D0C6
        for <stable@vger.kernel.org>; Tue,  3 May 2022 11:32:18 -0700 (PDT)
Received: by mail-qv1-f43.google.com with SMTP id jt15so3661401qvb.8
        for <stable@vger.kernel.org>; Tue, 03 May 2022 11:32:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+o3H2wSew0BRA4vqTAN2Yx+wDwTltnzrE6YOchX4Xao=;
        b=I6Xa5qIdpJlQ/tFyI9foJyBWyn2NPt3eeNGE/tQmeOF4TAlWtsaJyVavM3f6fTQ770
         KlG1JBiZnMIpK8nfCTKM1JraUnI1gfh28HKnTFRu2AA+p20/prD1y1UuRISM5zqSkfRf
         I2TFvtkRbrUy9m6hCT+YxLJ6kEol4MZYYdVtE5P43/td9w1VGiG8ocavMmAvgadDpAAS
         JQ/zjbOsLuiwZphQZeXIOxne4LBxfDhrNaXvvRvdZtU2s/DFh2YoQ+1Dg3LzODk8t061
         OKLl1uUcbcM8sGxb/XyLUyh8GgJ6q7UDXUpfp8PETCUbYfmdtqka7le0mQe/2xbuFqQI
         b/ZA==
X-Gm-Message-State: AOAM530U3G8+wJpwFnICrFvBFX4rN0CWL7M/0SlXK/sDl4Ol6NF6mDiR
        pxG/EpeqVW8V58sEjlsikzFgUUAwK78U
X-Google-Smtp-Source: ABdhPJwYXB+4mnODVKNOGfQ4/JnFfiz9n96ZB2gWIV2EhSPXMJ6znu5z3zyH2qA0O9C2o/JyHrUUvA==
X-Received: by 2002:a05:6214:f6f:b0:45a:8bcf:8274 with SMTP id iy15-20020a0562140f6f00b0045a8bcf8274mr9082718qvb.14.1651602737583;
        Tue, 03 May 2022 11:32:17 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id v185-20020a372fc2000000b0069fc13ce252sm6430137qkh.131.2022.05.03.11.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 11:32:17 -0700 (PDT)
Date:   Tue, 3 May 2022 14:32:15 -0400
From:   Mike Snitzer <snitzer@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v5.10] dm: fix mempool NULL pointer race when completing
 IO
Message-ID: <YnF1L4opPwLvBTLJ@redhat.com>
References: <alpine.LRH.2.02.2204211407220.761@file01.intranet.prod.int.rdu2.redhat.com>
 <YmeUXC3DZGLPJlWw@kroah.com>
 <alpine.LRH.2.02.2204281155460.5963@file01.intranet.prod.int.rdu2.redhat.com>
 <Ymuj0Y2A6WHOi05c@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ymuj0Y2A6WHOi05c@kroah.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 29 2022 at  4:37P -0400,
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Thu, Apr 28, 2022 at 12:22:26PM -0400, Mikulas Patocka wrote:
> > 
> > 
> > On Tue, 26 Apr 2022, Greg Kroah-Hartman wrote:
> > 
> > > On Thu, Apr 21, 2022 at 02:08:30PM -0400, Mikulas Patocka wrote:
> > > > Hi
> > > 
> > > Not really needed in a changelog text :)
> > > 
> > > > This is backport of patches d208b89401e0 ("dm: fix mempool NULL pointer
> > > > race when completing IO") and 9f6dc6337610 ("dm: interlock pending dm_io
> > > > and dm_wait_for_bios_completion") for the kernel 5.10.
> > > 
> > > Can you just make these 2 different patches?
> > > 
> > > > 
> > > > The bugs fixed by these patches can cause random crashing when reloading
> > > > dm table, so it is eligible for stable backport.
> > > > 
> > > > This patch is different from the upstream patches because the code
> > > > diverged significantly.
> > > > 
> > > 
> > > This change is _VERY_ different.  I would need acks from the maintainers
> > > of this code before I could accept this, along with a much more detailed
> > > description of why the original commits will not work here as well.
> > > 
> > > Same for the other backports.
> > 
> > Regarding backporting of 9f6dc633:
> > 
> > My reasoning was that introducing "md->pending_io" in the backported 
> > stable kernels is useless - it will just degrade performance by consuming 
> > one more cache line per I/O without providing any gain.
> > 
> > In the upstream kernels, Mike needs that "md->pending_io" variable for 
> > other reasons (the I/O accounting was reworked there in order to avoid 
> > some spikes with dm-crypt), but there is no need for it in the stable 
> > kernels.
> > 
> > In order to fix that race condition, all we need to do is to make sure 
> > that dm_stats_account_io is called before bio_end_io_acct - and the patch 
> > does that - it swaps them.
> > 
> > Do you still insist that this useless percpu variable must be added to the 
> > stable kernels? If you do, I can make it, but I think it's better to just 
> > swap those two functions.
> 
> I am no insisting on anything, I want the dm maintainers to agree that
> this change is acceptable to take as it is not what is in Linus's tree.
> Every time we take a "not upstream" commit, the odds are 90% that it
> ends up being wrong, so I need extra review and assurances that it is
> acceptable before I can apply it.

FYI, I've reviewed Mikulas's latest stable backport patches (not yet
posted) and provided by Reviewed-by.  So once you see them you can
trust I've looked at the changes and am fine with you picking them up.

Thanks,
Mike

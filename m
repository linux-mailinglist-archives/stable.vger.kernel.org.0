Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 758694C7DCE
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 23:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbiB1WyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 17:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbiB1WyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 17:54:06 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B823E1B6
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 14:53:26 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 139so12855939pge.1
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 14:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zibmIXYjhxaupOk9s0xWr7duCuTjugvyvgKLHyYpgFE=;
        b=iCpxXt6G0aThtvRUcLNU8SriL190rIC2M+2t85Gz/EPinufDECNpaCnslsRSQAk3ep
         MPSStIzbBpIxl3lRd+df6HbZ3lim+gftRnXLHB8sidpRHKV2QhZoSgXk99khZDcvuzcT
         Spee0qr8TUPt+3I4rqnlZ4mG/KhdXvQrBaZQM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zibmIXYjhxaupOk9s0xWr7duCuTjugvyvgKLHyYpgFE=;
        b=F6XBxGgxUcI0EyyDPg4l39YeeJDO0jK0HY2ndIog6OZ6Y5lUcImPvuUm/GyQmXqrq6
         HeS3zyGJFrrrgYpz5lmdaT1CVNwmHDfv5K/FlZ/b1T6Ah8yWze+7BalzgBczmcu67k3/
         e4jZ05Iy7rrP+9FGbhe9UBf1IS9eDxAjXyqTwiZtngG+Yczae5A74LczBCU6+aaKxweg
         4WZ2CM+I9pdh3hpiEH+KvOSRPoX079Pm9l2I1xv2NfutAuvlXjU3PLkinjj2rf6QZFK2
         KuVyldG+aiTgr5wRzVY40HNhR1PjqYqpUQScGq4WchiKa2cR6cbP8TOT8JTB68TOeyhu
         zhmQ==
X-Gm-Message-State: AOAM53287PRHycVuulN3lDrvW2zcHf59fc9eiAgwN1STaOOxZTf08PG+
        tbwPdYLlFve3SZ5/KyO2gDhXTA==
X-Google-Smtp-Source: ABdhPJzHZGv/HnLcdSxWcXgVP/q5WimYbT2Car4mVv68atOJnIPOjOQrAQTFGQxx45g0YLdkIV/MsA==
X-Received: by 2002:a65:6210:0:b0:374:ba5:aacc with SMTP id d16-20020a656210000000b003740ba5aaccmr18921903pgv.8.1646088806198;
        Mon, 28 Feb 2022 14:53:26 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id f9-20020a056a00228900b004f3ba7d177csm14943547pfe.54.2022.02.28.14.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 14:53:25 -0800 (PST)
Date:   Mon, 28 Feb 2022 14:53:25 -0800
From:   Kees Cook <keescook@chromium.org>
To:     matoro <matoro_mailinglist_kernel@matoro.tk>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Biederman <ebiederm@xmission.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        stable@vger.kernel.org,
        Magnus =?iso-8859-1?Q?Gro=DF?= <magnus.gross@rwth-aachen.de>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        regressions@lists.linux.dev, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH 5.16 v2] binfmt_elf: Avoid total_mapping_size for ET_EXEC
Message-ID: <202202281452.93E321A39@keescook>
References: <20220228205518.1265798-1-keescook@chromium.org>
 <ce8af9c13bcea9230c7689f3c1e0e2cd@matoro.tk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce8af9c13bcea9230c7689f3c1e0e2cd@matoro.tk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 28, 2022 at 05:14:26PM -0500, matoro wrote:
> On 2022-02-28 15:55, Kees Cook wrote:
> > Partially revert commit 5f501d555653 ("binfmt_elf: reintroduce using
> > MAP_FIXED_NOREPLACE").
> > 
> > At least ia64 has ET_EXEC PT_LOAD segments that are not virtual-address
> > contiguous (but _are_ file-offset contiguous). This would result in
> > giant mapping attempts to cover the entire span, including the virtual
> > address range hole. Disable total_mapping_size for ET_EXEC, which
> > reduces the MAP_FIXED_NOREPLACE coverage to only the first PT_LOAD:
> > 
> > $ readelf -lW /usr/bin/gcc
> > ...
> > Program Headers:
> >   Type Offset   VirtAddr           PhysAddr           FileSiz  MemSiz
> > ...
> > ...
> >   LOAD 0x000000 0x4000000000000000 0x4000000000000000 0x00b5a0 0x00b5a0
> > ...
> >   LOAD 0x00b5a0 0x600000000000b5a0 0x600000000000b5a0 0x0005ac 0x000710
> > ...
> > ...
> >        ^^^^^^^^ ^^^^^^^^^^^^^^^^^^                    ^^^^^^^^ ^^^^^^^^
> > 
> > File offset range     : 0x000000-0x00bb4c
> > 			0x00bb4c bytes
> > 
> > Virtual address range : 0x4000000000000000-0x600000000000bcb0
> > 			0x200000000000bcb0 bytes
> > 
> > Ironically, this is the reverse of the problem that originally caused
> > problems with ET_EXEC and MAP_FIXED_NOREPLACE: overlaps. This problem is
> > with holes. Future work could restore full coverage if load_elf_binary()
> > were to perform mappings in a separate phase from the loading (where
> > it could resolve both overlaps and holes).
> > 
> > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > Cc: Eric Biederman <ebiederm@xmission.com>
> > Cc: linux-fsdevel@vger.kernel.org
> > Cc: linux-mm@kvack.org
> > Reported-by: matoro <matoro_mailinglist_kernel@matoro.tk>
> > Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> > Fixes: 5f501d555653 ("binfmt_elf: reintroduce using
> > MAP_FIXED_NOREPLACE")
> > Link:
> > https://lore.kernel.org/r/a3edd529-c42d-3b09-135c-7e98a15b150f@leemhuis.info
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> > Here's the v5.16 backport.
> > ---
> >  fs/binfmt_elf.c | 25 ++++++++++++++++++-------
> >  1 file changed, 18 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> > index f8c7f26f1fbb..911a9e7044f4 100644
> > --- a/fs/binfmt_elf.c
> > +++ b/fs/binfmt_elf.c
> > @@ -1135,14 +1135,25 @@ static int load_elf_binary(struct linux_binprm
> > *bprm)
> >  			 * is then page aligned.
> >  			 */
> >  			load_bias = ELF_PAGESTART(load_bias - vaddr);
> > -		}
> > 
> > -		/*
> > -		 * Calculate the entire size of the ELF mapping (total_size).
> > -		 * (Note that load_addr_set is set to true later once the
> > -		 * initial mapping is performed.)
> > -		 */
> > -		if (!load_addr_set) {
> > +			/*
> > +			 * Calculate the entire size of the ELF mapping
> > +			 * (total_size), used for the initial mapping,
> > +			 * due to first_pt_load which is set to false later
> > +			 * once the initial mapping is performed.
> > +			 *
> > +			 * Note that this is only sensible when the LOAD
> > +			 * segments are contiguous (or overlapping). If
> > +			 * used for LOADs that are far apart, this would
> > +			 * cause the holes between LOADs to be mapped,
> > +			 * running the risk of having the mapping fail,
> > +			 * as it would be larger than the ELF file itself.
> > +			 *
> > +			 * As a result, only ET_DYN does this, since
> > +			 * some ET_EXEC (e.g. ia64) may have virtual
> > +			 * memory holes between LOADs.
> > +			 *
> > +			 */
> >  			total_size = total_mapping_size(elf_phdata,
> >  							elf_ex->e_phnum);
> >  			if (!total_size) {
> 
> This does the trick!  Thank you so much!!

Excellent; thank you for testing! I'll send this to Linus shortly.

-- 
Kees Cook

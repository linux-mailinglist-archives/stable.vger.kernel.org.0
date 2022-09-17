Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4AC45BB8DE
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 16:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiIQOyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Sep 2022 10:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiIQOyZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Sep 2022 10:54:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402E127176
        for <stable@vger.kernel.org>; Sat, 17 Sep 2022 07:54:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD28F6006F
        for <stable@vger.kernel.org>; Sat, 17 Sep 2022 14:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C35C433D6;
        Sat, 17 Sep 2022 14:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663426463;
        bh=W1KG87zu6uBdd7P3UWzyx5ROSiBb8aMsImd8mdNwoXY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OooGCbySgRDe6MkejeDiPkW5nR1eNotks/mfR904VkGZt59jnGjNFfsxiAYRBiQp7
         mFUyRLB0QP4rfq0yB5VL7MnAEX5w436xv/0kqxdo7tulUDAj3jEDJkAEWWLw7mD2/A
         5IlU/6f6qgGEaVIk6K+yOtbNykCaoyNINlv8kHjQ4pSbZaJQLpmOZzXY6dcR1KE6AD
         baopyJq66xuGmjwTrvWPD3/Q3xxCWxuPVk5lR3SQt6PeuV5JqDx1PbOm8OZ1JuGkl/
         nqSIn/bpRtkpdzvxD4vVnhsyFVfMx5ubyGSaTdwxBKbsHSTlEkCl3poZO6SSNAGlgs
         E6BLo7tSEgdaA==
Date:   Sat, 17 Sep 2022 15:54:19 +0100
From:   Conor Dooley <conor@kernel.org>
To:     Palmer Dabbelt <palmer@rivosinc.com>
Cc:     Conor.Dooley@microchip.com, linux-riscv@lists.infradead.org,
        stable@vger.kernel.org, lkp@intel.com
Subject: Re: [PATCH] RISC-V: Avoid coupling the T-Head CMOs and Zicbom
Message-ID: <YyXfm6V3DfzOqKvr@spud>
References: <4d7ab3d1-72cc-f1cf-15bf-50bbb64837da@microchip.com>
 <mhng-85fb2ed5-046c-4fd3-a703-b417bff95c57@palmer-ri-x1c9>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mhng-85fb2ed5-046c-4fd3-a703-b417bff95c57@palmer-ri-x1c9>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 17, 2022 at 07:41:34AM -0700, Palmer Dabbelt wrote:
> On Fri, 16 Sep 2022 05:22:59 PDT (-0700), Conor.Dooley@microchip.com wrote:
> > On 15/09/2022 18:13, Conor Dooley wrote:
> > > On 15/09/2022 18:09, Palmer Dabbelt wrote:
> > > > We could make the T-Head CMOs depend on a new-enough assembler to have
> > > > Zicbom, but it's not strictly necessary because the T-Head CMOs
> > > > circumvent the assembler.
> > > > 
> > > > Fixes: 8f7e001e0325 ("RISC-V: Clean up the Zicbom block size probing")
> > > > Cc: stable@vger.kernel.org
> > > > Reported-by: kernel test robot <lkp@intel.com>
> > > > Reported-by: Conor Dooley <conor.dooley@microchip.com>
> > > 
> > > I build-tested this last night when I accidentally found it so:
> > > Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> > 
> > This is the one you I noticed you missed, msg-id is:
> > 4d943291-f78f-31ed-0d67-7073e1f762e2@microchip.com
> 
> Sorry about that, the scripts to search for a Reviewed-by weren't handling
> the base64 encoding that Exchange was doing.  It should be fixed, at least
> it is for the test merge I just made.

I'm just going to bite the bullet & learn lei + mutt & use my korg
address for all mailing list things.* At least that'll help with my
mails getting through to rivos inboxes if they come via infread too.

> 
> > 
> > > 
> > > > Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
> > > > ---
> > > >   arch/riscv/include/asm/cacheflush.h | 6 +++++-
> > > >   1 file changed, 5 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/arch/riscv/include/asm/cacheflush.h b/arch/riscv/include/asm/cacheflush.h
> > > > index a89c005b4bbf..273ece6b622f 100644
> > > > --- a/arch/riscv/include/asm/cacheflush.h
> > > > +++ b/arch/riscv/include/asm/cacheflush.h
> > > > @@ -42,8 +42,12 @@ void flush_icache_mm(struct mm_struct *mm, bool local);
> > > >   #endif /* CONFIG_SMP */
> > > > -#ifdef CONFIG_RISCV_ISA_ZICBOM
> > > > +/*
> > > > + * The T-Head CMO errata internally probe the CBOM block size, but otherwise
> > > > + * don't depend on Zicbom.
> > > > + */
> > > >   extern unsigned int riscv_cbom_block_size;
> > > > +#ifdef CONFIG_RISCV_ISA_ZICBOM
> > > >   void riscv_init_cbom_blocksize(void);
> > > >   #else
> > > >   static inline void riscv_init_cbom_blocksize(void) { }
> > 
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

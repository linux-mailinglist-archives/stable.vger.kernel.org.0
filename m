Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72C5058D56F
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 10:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240593AbiHIIdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 04:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240542AbiHIIdo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 04:33:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7885920BE2;
        Tue,  9 Aug 2022 01:33:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1113160F80;
        Tue,  9 Aug 2022 08:33:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD04C433C1;
        Tue,  9 Aug 2022 08:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660034022;
        bh=8oLsa6JXahgVFpviTbXLMP2xROZxRe/dFE2nTOmoTp4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b3q966pjMDDXnBJEwIipYsrHFPefnVIDyfN7GuJO77cad+z+97UJLvZHi6TfqK3KN
         DWjZQjYljRx1JhZ1Mx7hdeadLMRFXmZ6p5l4nId5NZqiUkobF8bdLWEGPmy+uDhn0c
         Yv0Z44FO2g7TxetkB4RL5pJaZWDxo9h7ALxrdTtDN6MFvnIfgtlPqoaqWAHNOf5C6C
         MPmSdDwCQ4/VUVHazUh7otAzgFApPFs2bbxgt9vGs7x7/HLWemI/4ruWbug3vaiBKN
         gn/e79XiNTYJiO3YcRwQ9VjFomVGYxa23iu25frxu/u6MoudosoezMkAyMyHMeTDNO
         zwFSI+D4xeHYA==
Date:   Tue, 9 Aug 2022 09:33:37 +0100
From:   Will Deacon <will@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Collingbourne <pcc@google.com>, stable@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH][for-stable] arm64: set UXN on swapper page tables
Message-ID: <20220809083336.GA776@willie-the-truck>
References: <20220808125321.32598-1-will@kernel.org>
 <YvEOa/l7zcukaqle@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvEOa/l7zcukaqle@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 08, 2022 at 03:23:55PM +0200, Greg KH wrote:
> On Mon, Aug 08, 2022 at 01:53:21PM +0100, Will Deacon wrote:
> > From: Peter Collingbourne <pcc@google.com>
> > 
> > [ This issue was fixed upstream by accident in c3cee924bd85 ("arm64:
> >   head: cover entire kernel image in initial ID map") as part of a
> >   large refactoring of the arm64 boot flow. This simple fix is therefore
> >   preferred for -stable backporting ]
> > 
> > On a system that implements FEAT_EPAN, read/write access to the idmap
> > is denied because UXN is not set on the swapper PTEs. As a result,
> > idmap_kpti_install_ng_mappings panics the kernel when accessing
> > __idmap_kpti_flag. Fix it by setting UXN on these PTEs.
> > 
> > Fixes: 18107f8a2df6 ("arm64: Support execute-only permissions with Enhanced PAN")
> > Cc: <stable@vger.kernel.org> # 5.15
> > Link: https://linux-review.googlesource.com/id/Ic452fa4b4f74753e54f71e61027e7222a0fae1b1
> > Signed-off-by: Peter Collingbourne <pcc@google.com>
> > Acked-by: Will Deacon <will@kernel.org>
> > Cc: Ard Biesheuvel <ardb@kernel.org>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Link: https://lore.kernel.org/r/20220719234909.1398992-1-pcc@google.com
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/include/asm/kernel-pgtable.h | 4 ++--
> >  arch/arm64/kernel/head.S                | 2 +-
> >  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> So this should be added to 5.15.y, 5.18.y, and 5.19.y?  Or some subset?

Yes, all of them. Basically anything still being updated which is >= 5.15
and <= 5.19.

Thanks,

Will

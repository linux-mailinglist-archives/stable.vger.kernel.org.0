Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91BC753FA6F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 11:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237104AbiFGJz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 05:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239589AbiFGJwg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 05:52:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C4DE64F6
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 02:52:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 243C1612EC
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 09:52:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A019C34115;
        Tue,  7 Jun 2022 09:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654595520;
        bh=VdrKUXrOWPmXfCyWgiKHVZFJrnWCYskGde+okuzGPUU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l/0ovXVOZ1cR6ssTp48VCWloWkul1o6jNKYsM9g01STATWTNFKwvAgdaYbVkl2qu1
         KGX6Zy2mKVPCQTHKW/hxchSUFgF269aBl1yGsVEOz2unXXDoF3sNK/LvGxC2OMXvpS
         vdgByxKLqoOwHPEMuFMgMx42PdfAS/qkYOBs2V/A=
Date:   Tue, 7 Jun 2022 11:51:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.17] MIPS: IP27: Remove incorrect `cpu_has_fpu' override
Message-ID: <Yp8fuNYXxNshtidd@kroah.com>
References: <alpine.DEB.2.21.2206070231480.19680@angie.orcam.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2206070231480.19680@angie.orcam.me.uk>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 02:41:52AM +0100, Maciej W. Rozycki wrote:
> Remove unsupported forcing of `cpu_has_fpu' to 1, which makes the `nofpu' 
> kernel parameter non-functional, and also causes a link error:
> 
> ld: arch/mips/kernel/traps.o: in function `trap_init':
> ./arch/mips/include/asm/msa.h:(.init.text+0x348): undefined reference to `handle_fpe'
> ld: ./arch/mips/include/asm/msa.h:(.init.text+0x354): undefined reference to `handle_fpe'
> ld: ./arch/mips/include/asm/msa.h:(.init.text+0x360): undefined reference to `handle_fpe'
> 
> where the CONFIG_MIPS_FP_SUPPORT configuration option has been disabled.
> 
> Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
> Reported-by: Stephen Zhang <starzhangzsd@gmail.com>
> Fixes: 0ebb2f4159af ("MIPS: IP27: Update/restructure CPU overrides")
> Cc: stable@vger.kernel.org # v4.2+
> ---
> Hi,
> 
>  This is a version of commit 424c3781dd1c for 5.17-stable and before 
> (where the preceding `#define cpu_has_tx39_cache 0' line has not been 
> removed yet and hence the merge conflict).

Now queued up, thanks.

greg k-h

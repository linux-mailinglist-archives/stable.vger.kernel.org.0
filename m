Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B04561B28
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 15:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbiF3NUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbiF3NUj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:20:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCD92C65F;
        Thu, 30 Jun 2022 06:20:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6DE6B82A59;
        Thu, 30 Jun 2022 13:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A5BC34115;
        Thu, 30 Jun 2022 13:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656595235;
        bh=Gjs1D9vdtTbVIpCgMrFXplqipTLraLCHH4B9AHCpl/4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sPO7S7+b+VQXn8XPN0Aw/4Cm1s3T9irr43M+Rxhf7IsLt0Z7FH7ZkueR5Fs8fNffu
         5O1hEithJbc9BVXJ3XXFkLmP8iLjrMUzyFsVGbxhF+PkRy9C8fKnNqR0MAB8+fsaOH
         mBKZa/1WC/aN80kxm4eGk7DCzStxPLqGLvLerwlA=
Date:   Thu, 30 Jun 2022 15:20:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kexec@lists.infradead.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4.9] kexec_file: drop weak attribute from
 arch_kexec_apply_relocations[_add]
Message-ID: <Yr2jIISAEVwi+YYH@kroah.com>
References: <20220628154249.204911-3-naveen.n.rao@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628154249.204911-3-naveen.n.rao@linux.vnet.ibm.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 28, 2022 at 09:12:48PM +0530, Naveen N. Rao wrote:
> commit 3e35142ef99fe6b4fe5d834ad43ee13cca10a2dc upstream.
> 
> Since commit d1bcae833b32f1 ("ELF: Don't generate unused section
> symbols") [1], binutils (v2.36+) started dropping section symbols that
> it thought were unused.  This isn't an issue in general, but with
> kexec_file.c, gcc is placing kexec_arch_apply_relocations[_add] into a
> separate .text.unlikely section and the section symbol ".text.unlikely"
> is being dropped. Due to this, recordmcount is unable to find a non-weak
> symbol in .text.unlikely to generate a relocation record against.
> 
> Address this by dropping the weak attribute from these functions.
> Instead, follow the existing pattern of having architectures #define the
> name of the function they want to override in their headers.
> 
> [1] https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=d1bcae833b32f1
> 
> [akpm@linux-foundation.org: arch/s390/include/asm/kexec.h needs linux/module.h]
> Link: https://lkml.kernel.org/r/20220519091237.676736-1-naveen.n.rao@linux.vnet.ibm.com
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>  arch/x86/include/asm/kexec.h |  7 +++++++
>  include/linux/kexec.h        | 26 ++++++++++++++++++++++----
>  kernel/kexec_file.c          | 18 ------------------
>  3 files changed, 29 insertions(+), 22 deletions(-)
> 

All now queued up, thanks.

greg k-h

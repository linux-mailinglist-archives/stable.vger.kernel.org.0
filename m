Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5552E6DE0DF
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 18:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjDKQUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 12:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjDKQUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 12:20:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D854CA0
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 09:20:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 731A161EEF
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 16:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B1CC4339B;
        Tue, 11 Apr 2023 16:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681230003;
        bh=tm/CExntduMkXqg9KpbKqvQi+XGcy+XMMzAChtFb9MA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tP9w0wj8v1sRjE2sd77SuCu8how/IDWrGWzZiLVZkD/Wj549Sod9HEaI2z8kwM44a
         yTPULMDbCpjZmP9hRVtEqPIcnYFd4w1+kjbnXEJ/3zivumO27XuJ3DaIKEUHdeAY49
         OSuW0NtoUr0ilT3WnRFTm4DfEesP6yIhzJaWvP8g9mBtd0KpEY+d7Y/OkZZ8oeQXoQ
         CTazv+igxkDhsHxDVjjh7xyinSJjX/cHDeB7GCNZRIDich1uveVnFjwyGkSB6THQrS
         Xd1Q9zXBq5MlmQzo+05HkVv5K3Ov8nSXYsVCROf/CA/27ba3kEVBmAAE8hepuwNcLA
         tichtP/jMA9eg==
Date:   Tue, 11 Apr 2023 09:20:01 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     conor@kernel.org, stable@vger.kernel.org, llvm@lists.linux.dev,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: Re: [PATCH 5.10 0/4] Backport of e89c2e815e76 to linux-5.10.y
Message-ID: <20230411162001.GA3308382@dev-arch.thelio-3990X>
References: <20230328-riscv-zifencei-zicsr-5-10-v1-0-bccb3e16dc46@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328-riscv-zifencei-zicsr-5-10-v1-0-bccb3e16dc46@kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Gentle ping, did this get lost?

On Tue, Mar 28, 2023 at 05:08:28PM -0700, Nathan Chancellor wrote:
> Hi all,
> 
> This series is a backport of upstream commit e89c2e815e76 ("riscv:
> Handle zicsr/zifencei issues between clang and binutils") to
> linux-5.10.y, with the necessary machinery for CONFIG_AS_IS_GNU and
> CONFIG_AS_VERSION, which that commit requires.
> 
> While the middle two patches are not strictly necessary, they are good
> clean ups that ensure consistency with mainline. The first three changes
> are already present in 5.15, so there is no risk of a regression moving
> forward.
> 
> If there are any issues, please let me know.
> 
> NOTE: I am sending this series with 'b4 send', as that is what I am used
> to at this point. Please accept my apologies if this causes any issues.
> 
> ---
> Masahiro Yamada (2):
>       kbuild: check the minimum assembler version in Kconfig
>       kbuild: check CONFIG_AS_IS_LLVM instead of LLVM_IAS
> 
> Nathan Chancellor (2):
>       kbuild: Switch to 'f' variants of integrated assembler flag
>       riscv: Handle zicsr/zifencei issues between clang and binutils
> 
>  Makefile                |  8 +++---
>  arch/riscv/Kconfig      | 22 ++++++++++++++++
>  arch/riscv/Makefile     | 12 +++++----
>  init/Kconfig            | 12 +++++++++
>  scripts/Kconfig.include |  6 +++++
>  scripts/as-version.sh   | 69 +++++++++++++++++++++++++++++++++++++++++++++++++
>  scripts/dummy-tools/gcc |  6 +++++
>  7 files changed, 127 insertions(+), 8 deletions(-)
> ---
> base-commit: ca9787bdecfa2174b0a169a54916e22b89b0ef5b
> change-id: 20230328-riscv-zifencei-zicsr-5-10-65596f2cac9e
> 
> Best regards,
> -- 
> Nathan Chancellor <nathan@kernel.org>
> 
> 

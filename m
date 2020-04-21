Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4631B3070
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 21:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgDUTek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 15:34:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgDUTej (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 15:34:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17D60206D5;
        Tue, 21 Apr 2020 19:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587497679;
        bh=WgsfyAvDSXyVnPKQOCAvgAZ//ff4LfXWv1CZoa9sgcY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rUfLlBJlwkyzuJ4shduBguWGJEbmt48DGhao4S5uyb+txN7a9MBG+Jwr9lcs61Tko
         Zdf8dV5aCDPbuTV/14PqC2lgghIvOkqIeozYnqsVDBpf79afdCWlfn7cbf/yYHxoHE
         DaUq3Z4crex9ygd3ruuJtj9fM7nqvuu6ZpFYmQQ4=
Date:   Tue, 21 Apr 2020 21:34:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 4.9] arm64: cpu_errata: include required headers
Message-ID: <20200421193437.GA1420935@kroah.com>
References: <20200421192040.43080-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421192040.43080-1-natechancellor@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 21, 2020 at 12:20:41PM -0700, Nathan Chancellor wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> commit 94a5d8790e79ab78f499d2d9f1ff2cab63849d9f upstream.
> 
> Without including psci.h and arm-smccc.h, we now get a build failure in
> some configurations:
> 
> arch/arm64/kernel/cpu_errata.c: In function 'arm64_update_smccc_conduit':
> arch/arm64/kernel/cpu_errata.c:278:10: error: 'psci_ops' undeclared (first use in this function); did you mean 'sysfs_ops'?
> 
> arch/arm64/kernel/cpu_errata.c: In function 'arm64_set_ssbd_mitigation':
> arch/arm64/kernel/cpu_errata.c:311:3: error: implicit declaration of function 'arm_smccc_1_1_hvc' [-Werror=implicit-function-declaration]
>    arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_WORKAROUND_2, state, NULL);
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
> 
> Greg and Sasha,
> 
> Please apply this to 4.9. The error in the commit message can be
> reproduced on 4.9.219 when CONFIG_ARM64_SSBD is enabled and
> CONFIG_HARDEN_BRANCH_PREDICTOR is disabled. It was reported to me by a
> user of one of my Android stable trees, where one of the configs in
> Qualcomm's 4.9 tree reproduced this issue.
> 
> This commit is in 4.14 already so this should be the only tree where it
> is needed.

Now queued up, thanks.

greg k-h

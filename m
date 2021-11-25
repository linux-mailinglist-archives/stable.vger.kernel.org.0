Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D0F45DE1B
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 16:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350076AbhKYP6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 10:58:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:33502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356234AbhKYP4o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 10:56:44 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7011161059;
        Thu, 25 Nov 2021 15:53:33 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mqH3z-007qIg-DK; Thu, 25 Nov 2021 15:53:31 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org
Cc:     Will Deacon <will@kernel.org>, stable@vger.kernel.org,
        Chris January <Chris.January@arm.com>
Subject: Re: [PATCH] arm64: KVM: Avoid setting the upper 32 bits of TCR_EL2 and CPTR_EL2 to 1
Date:   Thu, 25 Nov 2021 15:53:27 +0000
Message-Id: <163785558760.643582.3194076886252038382.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211125152014.2806582-1-catalin.marinas@arm.com>
References: <20211125152014.2806582-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org, will@kernel.org, stable@vger.kernel.org, Chris.January@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Nov 2021 15:20:14 +0000, Catalin Marinas wrote:
> Having a signed (1 << 31) constant for TCR_EL2_RES1 and CPTR_EL2_TCPAC
> causes the upper 32-bit to be set to 1 when assigning them to a 64-bit
> variable. Bit 32 in TCR_EL2 is no longer RES0 in ARMv8.7: with FEAT_LPA2
> it changes the meaning of bits 49:48 and 9:8 in the stage 1 EL2 page
> table entries. As a result of the sign-extension, a non-VHE kernel can
> no longer boot on a model with ARMv8.7 enabled.
> 
> [...]

Applied to fixes, thanks!

[1/1] arm64: KVM: Avoid setting the upper 32 bits of TCR_EL2 and CPTR_EL2 to 1
      commit: 1f80d15020d7f130194821feb1432b67648c632d

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



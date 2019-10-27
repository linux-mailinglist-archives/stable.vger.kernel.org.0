Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38119E67D4
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732578AbfJ0VYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:24:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732573AbfJ0VYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:24:43 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC64D21726;
        Sun, 27 Oct 2019 21:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211482;
        bh=ZFe86N/EscxSwYeE7npBjjyYeCxyrwEyFWXFXK0cBM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fw1NjhcBIaVbLPn8GQkBMnH8PBAbdR/hQHw+kAgnYNXZNiuNPrbrtE5sTjz1UpLzl
         dTb0l6RLUbh1Duq6Z+ZcSRYRpesfWA39A1j1zsqMIIAPiJ7X6Xm/aQ+gTt/Tvw02L4
         blGiIxhp+Ln0RUmmSiUryQVRvcbNtfHtVDtgv+jU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.3 166/197] arm64: Allow CAVIUM_TX2_ERRATUM_219 to be selected
Date:   Sun, 27 Oct 2019 22:01:24 +0100
Message-Id: <20191027203403.257696914@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

commit 603afdc9438ac546181e843f807253d75d3dbc45 upstream.

Allow the user to select the workaround for TX2-219, and update
the silicon-errata.rst file to reflect this.

Cc: <stable@vger.kernel.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/arm64/silicon-errata.rst |    2 ++
 arch/arm64/Kconfig                     |   17 +++++++++++++++++
 2 files changed, 19 insertions(+)

--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -107,6 +107,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Cavium         | ThunderX2 SMMUv3| #126            | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
+| Cavium         | ThunderX2 Core  | #219            | CAVIUM_TX2_ERRATUM_219      |
++----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | Freescale/NXP  | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585         |
 +----------------+-----------------+-----------------+-----------------------------+
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -601,6 +601,23 @@ config CAVIUM_ERRATUM_30115
 
 	  If unsure, say Y.
 
+config CAVIUM_TX2_ERRATUM_219
+	bool "Cavium ThunderX2 erratum 219: PRFM between TTBR change and ISB fails"
+	default y
+	help
+	  On Cavium ThunderX2, a load, store or prefetch instruction between a
+	  TTBR update and the corresponding context synchronizing operation can
+	  cause a spurious Data Abort to be delivered to any hardware thread in
+	  the CPU core.
+
+	  Work around the issue by avoiding the problematic code sequence and
+	  trapping KVM guest TTBRx_EL1 writes to EL2 when SMT is enabled. The
+	  trap handler performs the corresponding register access, skips the
+	  instruction and ensures context synchronization by virtue of the
+	  exception return.
+
+	  If unsure, say Y.
+
 config QCOM_FALKOR_ERRATUM_1003
 	bool "Falkor E1003: Incorrect translation due to ASID change"
 	default y



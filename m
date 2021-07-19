Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436703CE402
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347612AbhGSPlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:41:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348737AbhGSPf3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2244F6188B;
        Mon, 19 Jul 2021 16:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711265;
        bh=FF6FdsUlmnuBBRRI2C3j3WieIA8w49IEE/YOHnTkSJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LKdkQ3icd+po/wztRQI3ndUFnWjLzcDeSIbsMLGi9A0yztgpLXhlJgvrUKane1HnP
         jTAtOVAlsYvRzNHokNwIrOAckQiWXFgsYMF7MDPZT6+Pjo2n81CNKt3hlJhLtVxuJp
         6r2WZNLPvyS0U3iHVJ/qVpX+BusJYY37bHqK36as=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Caleb Connolly <caleb@connolly.tech>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 290/351] arm64: dts: qcom: sdm845-oneplus-common: guard rmtfs-mem
Date:   Mon, 19 Jul 2021 16:53:56 +0200
Message-Id: <20210719144954.633987245@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Caleb Connolly <caleb@connolly.tech>

[ Upstream commit e60fd5ac1f6851be5b2c042b39584bfcf8a66f57 ]

The rmtfs_mem region is a weird one, downstream allocates it
dynamically, and supports a "qcom,guard-memory" property which when set
will reserve 4k above and below the rmtfs memory.

A common from qcom 4.9 kernel msm_sharedmem driver:

/*
 * If guard_memory is set, then the shared memory region
 * will be guarded by SZ_4K at the start and at the end.
 * This is needed to overcome the XPU limitation on few
 * MSM HW, so as to make this memory not contiguous with
 * other allocations that may possibly happen from other
 * clients in the system.
*/

When the kernel tries to touch memory that is too close the
rmtfs region it may cause an XPU violation. Such is the case on the
OnePlus 6 where random crashes would occur usually after boot.

Reserve 4k above and below the rmtfs_mem to avoid hitting these XPU
Violations.

This doesn't entirely solve the random crashes on the OnePlus 6/6T but
it does seem to prevent the ones which happen shortly after modem
bringup.

Fixes: 288ef8a42612 ("arm64: dts: sdm845: add oneplus6/6t devices")
Signed-off-by: Caleb Connolly <caleb@connolly.tech>
Link: https://lore.kernel.org/r/20210502014146.85642-4-caleb@connolly.tech
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
index 8f617f7b6d34..f712771df0c7 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -46,6 +46,14 @@
 	};
 
 	reserved-memory {
+		/* The rmtfs_mem needs to be guarded due to "XPU limitations"
+		 * it is otherwise possible for an allocation adjacent to the
+		 * rmtfs_mem region to trigger an XPU violation, causing a crash.
+		 */
+		rmtfs_lower_guard: memory@f5b00000 {
+			no-map;
+			reg = <0 0xf5b00000 0 0x1000>;
+		};
 		/*
 		 * The rmtfs memory region in downstream is 'dynamically allocated'
 		 * but given the same address every time. Hard code it as this address is
@@ -59,6 +67,10 @@
 			qcom,client-id = <1>;
 			qcom,vmid = <15>;
 		};
+		rmtfs_upper_guard: memory@f5d01000 {
+			no-map;
+			reg = <0 0xf5d01000 0 0x2000>;
+		};
 
 		/*
 		 * It seems like reserving the old rmtfs_mem region is also needed to prevent
-- 
2.30.2




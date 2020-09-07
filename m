Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710E5260026
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 18:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730883AbgIGQoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 12:44:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730839AbgIGQfi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 12:35:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60AF721D95;
        Mon,  7 Sep 2020 16:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496537;
        bh=8QfiQeHJEJz7b327EU8FvscAsj0hUZMuzLBtnfgA1oU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ueuy+ajqQNK2F+PSykvDkMVeSy7Qm0iYUeY5E1ASl0/MSTcaVTZVln5qYK1x7ZWY1
         PRy8VmVThpGRkb6bEd5J5eIoAnGFfAqfmnI0GTRPVTQG1JFANFLK+Kfz6e6cMLa+ds
         YUiGmhmcEB+Exm1lcxwoE6zjJKE9RlGEER9v3PDU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vineet Gupta <vgupta@synopsys.com>,
        kernel test robot <lkp@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 09/13] irqchip/eznps: Fix build error for !ARC700 builds
Date:   Mon,  7 Sep 2020 12:35:20 -0400
Message-Id: <20200907163524.1281734-9-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163524.1281734-1-sashal@kernel.org>
References: <20200907163524.1281734-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

[ Upstream commit 89d29997f103d08264b0685796b420d911658b96 ]

eznps driver is supposed to be platform independent however it ends up
including stuff from inside arch/arc headers leading to rand config
build errors.

The quick hack to fix this (proper fix is too much chrun for non active
user-base) is to add following to nps platform agnostic header.
 - copy AUX_IENABLE from arch/arc header
 - move CTOP_AUX_IACK from arch/arc/plat-eznps/*/**

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lkml.kernel.org/r/20200824095831.5lpkmkafelnvlpi2@linutronix.de
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/plat-eznps/include/plat/ctop.h | 1 -
 include/soc/nps/common.h                | 6 ++++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arc/plat-eznps/include/plat/ctop.h b/arch/arc/plat-eznps/include/plat/ctop.h
index 3c401ce0351ef..fb959828630ce 100644
--- a/arch/arc/plat-eznps/include/plat/ctop.h
+++ b/arch/arc/plat-eznps/include/plat/ctop.h
@@ -42,7 +42,6 @@
 #define CTOP_AUX_HW_COMPLY			(CTOP_AUX_BASE + 0x024)
 #define CTOP_AUX_LPC				(CTOP_AUX_BASE + 0x030)
 #define CTOP_AUX_EFLAGS				(CTOP_AUX_BASE + 0x080)
-#define CTOP_AUX_IACK				(CTOP_AUX_BASE + 0x088)
 #define CTOP_AUX_GPA1				(CTOP_AUX_BASE + 0x08C)
 #define CTOP_AUX_UDMC				(CTOP_AUX_BASE + 0x300)
 
diff --git a/include/soc/nps/common.h b/include/soc/nps/common.h
index 9b1d43d671a3f..8c18dc6d3fde5 100644
--- a/include/soc/nps/common.h
+++ b/include/soc/nps/common.h
@@ -45,6 +45,12 @@
 #define CTOP_INST_MOV2B_FLIP_R3_B1_B2_INST	0x5B60
 #define CTOP_INST_MOV2B_FLIP_R3_B1_B2_LIMM	0x00010422
 
+#ifndef AUX_IENABLE
+#define AUX_IENABLE				0x40c
+#endif
+
+#define CTOP_AUX_IACK				(0xFFFFF800 + 0x088)
+
 #ifndef __ASSEMBLY__
 
 /* In order to increase compilation test coverage */
-- 
2.25.1


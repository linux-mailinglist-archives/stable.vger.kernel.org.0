Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E52AEE5BD8
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 15:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729262AbfJZN0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 09:26:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729328AbfJZNWI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 09:22:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 778CB222BE;
        Sat, 26 Oct 2019 13:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096127;
        bh=U6HFSLK8B3LhppeobNpVbWvQmbuqRJyH+5DZKjc7zO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uE2ssZ7uMywAv3tiKOZwCSGAXIa4hP6Gcm8rGJNkDfylfoH+DL+sEjOosO/29usXq
         keFfCVVgZOC5jdtoRmteTF6Ax2ShsV/LGhAqBbMvOoJTUvwzyrC+1zDGbcDVRkk2f3
         yhwyVB0OBhmSqmA6pPYFIJ0uGIlfucUFSgqb42m0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrea Parri <parri.andrea@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wei Liu <wei.liu@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 29/33] x86/hyperv: Set pv_info.name to "Hyper-V"
Date:   Sat, 26 Oct 2019 09:21:06 -0400
Message-Id: <20191026132110.4026-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026132110.4026-1-sashal@kernel.org>
References: <20191026132110.4026-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit f7c0f50f1857c1cf013466fcea4dc98d116bf456 ]

Michael reported that the x86/hyperv initialization code prints the
following dmesg when running in a VM on Hyper-V:

  [    0.000738] Booting paravirtualized kernel on bare hardware

Let the x86/hyperv initialization code set pv_info.name to "Hyper-V" so
dmesg reports correctly:

  [    0.000172] Booting paravirtualized kernel on Hyper-V

[ tglx: Folded build fix provided by Yue ]

Reported-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Wei Liu <wei.liu@kernel.org>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Cc: YueHaibing <yuehaibing@huawei.com>
Link: https://lkml.kernel.org/r/20191015103502.13156-1-parri.andrea@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mshyperv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index c0201b11e9e2a..4e7adccf812d4 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -171,6 +171,10 @@ static void __init ms_hyperv_init_platform(void)
 	int hv_host_info_ecx;
 	int hv_host_info_edx;
 
+#ifdef CONFIG_PARAVIRT
+	pv_info.name = "Hyper-V";
+#endif
+
 	/*
 	 * Extract the features and hints
 	 */
-- 
2.20.1


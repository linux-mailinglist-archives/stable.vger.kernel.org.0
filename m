Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA321B74E2
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbgDXM3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:29:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728222AbgDXMX7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:23:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B845B21707;
        Fri, 24 Apr 2020 12:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587731038;
        bh=lX7GO5zZRgBAxgEabLCkym2MplVXRl3kwn5k981MtVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QChqZ+OroKrCBLGeumwXaCArE8Egs+a+VUymVnkFbMDaHidLHTAVdg/a38IfIKWrG
         P+xWsIYVkNtjgAbUgFEj4jeF5Vb3B6sjwadUr7yRw9jHCzqTlj9h2zMypU84CtWDsl
         eDvBGe7oANGNJavmGns/JvCswYxTnIYaeJjmKyVg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olaf Hering <olaf@aepfle.de>, Wei Liu <wei.liu@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/18] x86: hyperv: report value of misc_features
Date:   Fri, 24 Apr 2020 08:23:39 -0400
Message-Id: <20200424122355.10453-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122355.10453-1-sashal@kernel.org>
References: <20200424122355.10453-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olaf Hering <olaf@aepfle.de>

[ Upstream commit 97d9f1c43bedd400301d6f1eff54d46e8c636e47 ]

A few kernel features depend on ms_hyperv.misc_features, but unlike its
siblings ->features and ->hints, the value was never reported during boot.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Link: https://lore.kernel.org/r/20200407172739.31371-1-olaf@aepfle.de
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mshyperv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index fc93ae3255153..f8b0fa2dbe374 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -214,8 +214,8 @@ static void __init ms_hyperv_init_platform(void)
 	ms_hyperv.misc_features = cpuid_edx(HYPERV_CPUID_FEATURES);
 	ms_hyperv.hints    = cpuid_eax(HYPERV_CPUID_ENLIGHTMENT_INFO);
 
-	pr_info("Hyper-V: features 0x%x, hints 0x%x\n",
-		ms_hyperv.features, ms_hyperv.hints);
+	pr_info("Hyper-V: features 0x%x, hints 0x%x, misc 0x%x\n",
+		ms_hyperv.features, ms_hyperv.hints, ms_hyperv.misc_features);
 
 	ms_hyperv.max_vp_index = cpuid_eax(HYPERV_CPUID_IMPLEMENT_LIMITS);
 	ms_hyperv.max_lp_index = cpuid_ebx(HYPERV_CPUID_IMPLEMENT_LIMITS);
-- 
2.20.1


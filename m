Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1021C143E
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730943AbgEANhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:37:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730933AbgEANhH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:37:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1980A24953;
        Fri,  1 May 2020 13:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340227;
        bh=lX7GO5zZRgBAxgEabLCkym2MplVXRl3kwn5k981MtVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pwLzLcXswMdeSyvK9rI7qw1A6SHhBOJBORsCWNXy9YpPsKIlQbupXum0Epz2tEVp+
         J+bbp1A+K39Mbj0SNcRmKD2EpHLRfaXe3Xk7NckXVz5mVyhFBcR8pMsaSS8wAHUoVS
         oGqtN+k48ngIwLL4EQnIGMqlNt+gayQ3wDRFQWaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olaf Hering <olaf@aepfle.de>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 29/46] x86: hyperv: report value of misc_features
Date:   Fri,  1 May 2020 15:22:54 +0200
Message-Id: <20200501131509.204198464@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131457.023036302@linuxfoundation.org>
References: <20200501131457.023036302@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




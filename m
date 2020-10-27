Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E059329B220
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761143AbgJ0OiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:38:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761132AbgJ0OiF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:38:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63EFA207BB;
        Tue, 27 Oct 2020 14:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809485;
        bh=LiIrEiwETVTgXBLW+un4dFfNAJQ7Zyu4Z/UTAqyR7kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mowyrWOTBvbq8Y+sfa7yV/vkBUrN3xMnQlUAUsgnfFMD+9F4BN0v+nqDbWixNhFdg
         C6yrJRV1JgqSWoiUqHJk1JZRoscPTRK0WtF086acf34qg7p8LUTfiMP9tkpH34zncm
         FnAUR4v4tzXV7VXnylbvZEj+HKREp0aPFuQrDE/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 211/408] arc: plat-hsdk: fix kconfig dependency warning when !RESET_CONTROLLER
Date:   Tue, 27 Oct 2020 14:52:29 +0100
Message-Id: <20201027135504.885391340@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Necip Fazil Yildiran <fazilyildiran@gmail.com>

[ Upstream commit 63bcf87cb1c57956e1179f1a78dde625c7e3cba7 ]

When ARC_SOC_HSDK is enabled and RESET_CONTROLLER is disabled, it results
in the following Kbuild warning:

WARNING: unmet direct dependencies detected for RESET_HSDK
  Depends on [n]: RESET_CONTROLLER [=n] && HAS_IOMEM [=y] && (ARC_SOC_HSDK [=y] || COMPILE_TEST [=n])
  Selected by [y]:
  - ARC_SOC_HSDK [=y] && ISA_ARCV2 [=y]

The reason is that ARC_SOC_HSDK selects RESET_HSDK without depending on or
selecting RESET_CONTROLLER while RESET_HSDK is subordinate to
RESET_CONTROLLER.

Honor the kconfig menu hierarchy to remove kconfig dependency warnings.

Fixes: a528629dfd3b ("ARC: [plat-hsdk] select CONFIG_RESET_HSDK from Kconfig")
Signed-off-by: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/plat-hsdk/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arc/plat-hsdk/Kconfig b/arch/arc/plat-hsdk/Kconfig
index ce81018345184..6b5c54576f54d 100644
--- a/arch/arc/plat-hsdk/Kconfig
+++ b/arch/arc/plat-hsdk/Kconfig
@@ -8,5 +8,6 @@ menuconfig ARC_SOC_HSDK
 	select ARC_HAS_ACCL_REGS
 	select ARC_IRQ_NO_AUTOSAVE
 	select CLK_HSDK
+	select RESET_CONTROLLER
 	select RESET_HSDK
 	select HAVE_PCI
-- 
2.25.1




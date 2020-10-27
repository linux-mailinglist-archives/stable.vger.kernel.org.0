Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5613F29B8BF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1801851AbgJ0Pob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:44:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801043AbgJ0Pha (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:37:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12846204EF;
        Tue, 27 Oct 2020 15:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813049;
        bh=LiIrEiwETVTgXBLW+un4dFfNAJQ7Zyu4Z/UTAqyR7kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQzDH80C6Qt/3ZcJ38oRDL5FPMCvtrqxXbOsmckRXufIJHV4iYzpxIZwznJqBSOwe
         LyM/Ol5fBhVbAvJ9hVbHAIYOMzRcy0FfGdPcRc+NqkwpI64ycTlWxq1mffCwtE9ibr
         o5YJLIR9X3zFJ4eqMAsV7E0M2tLWwQtU4EI7LeqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 421/757] arc: plat-hsdk: fix kconfig dependency warning when !RESET_CONTROLLER
Date:   Tue, 27 Oct 2020 14:51:11 +0100
Message-Id: <20201027135510.319508000@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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




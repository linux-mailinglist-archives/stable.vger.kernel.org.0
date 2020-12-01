Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB4D82C9BDA
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390009AbgLAJMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:12:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:51024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389988AbgLAJMt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:12:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C96222247;
        Tue,  1 Dec 2020 09:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813928;
        bh=byTBPk8ZVz+XUki0AtiSUdLe6PhVwayiWW/WjRv0Cq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZni2jxu5YNMs1JUhFHZ+eKIHZlp9ZcNSkfIZgjjVvBeEq2gifBrmqD0cYAgmn9dJ
         nwRRYVDpu+EBBT8cLaD0OUgLn5HZ4Bco8wBOMvmzvoijUqDJ5m8tVUkzdh6Wn5XvQj
         nv7wMc6WyP0YlJaoIX8YvMY3alsfh7lDnWC+MU6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Narani <manish.narani@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 106/152] firmware: xilinx: Fix SD DLL node reset issue
Date:   Tue,  1 Dec 2020 09:53:41 +0100
Message-Id: <20201201084725.723191562@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manish Narani <manish.narani@xilinx.com>

[ Upstream commit f4426311f927b01776edf8a45f6fad90feae4e72 ]

Fix the SD DLL node reset issue where incorrect node is being referenced
instead of SD DLL node.

Fixes: 426c8d85df7a ("firmware: xilinx: Use APIs instead of IOCTLs")

Signed-off-by: Manish Narani <manish.narani@xilinx.com>
Link: https://lore.kernel.org/r/1605534744-15649-1-git-send-email-manish.narani@xilinx.com
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/xilinx/zynqmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/xilinx/zynqmp.c b/drivers/firmware/xilinx/zynqmp.c
index 349ab39480068..d08ac824c993c 100644
--- a/drivers/firmware/xilinx/zynqmp.c
+++ b/drivers/firmware/xilinx/zynqmp.c
@@ -642,7 +642,7 @@ EXPORT_SYMBOL_GPL(zynqmp_pm_set_sd_tapdelay);
  */
 int zynqmp_pm_sd_dll_reset(u32 node_id, u32 type)
 {
-	return zynqmp_pm_invoke_fn(PM_IOCTL, node_id, IOCTL_SET_SD_TAPDELAY,
+	return zynqmp_pm_invoke_fn(PM_IOCTL, node_id, IOCTL_SD_DLL_RESET,
 				   type, 0, NULL);
 }
 EXPORT_SYMBOL_GPL(zynqmp_pm_sd_dll_reset);
-- 
2.27.0




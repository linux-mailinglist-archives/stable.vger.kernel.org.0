Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B82CB13E1DD
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbgAPQvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:51:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:34808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727015AbgAPQvy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:51:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22E7F205F4;
        Thu, 16 Jan 2020 16:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193514;
        bh=uHDst8UX4z8oIJF3ujRDjA/O0+RqS6TJFAo6QrE7GAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6fvMwRvX+C2hszQCJF2JCJqvjYldymZm4lmGTD9R0pHBl4zryLG2CufFcQmEC0gO
         uyKIOTflAsffdMfaFOxFEnRFrVesdOC8OHKgpi4nVlxjb1xYuz3h/3Er67co044ett
         RvyxGkVoooNEdSTRu19SarepFw+GYNm+hC/WM14M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 094/205] soc: renesas: Add missing check for non-zero product register address
Date:   Thu, 16 Jan 2020 11:41:09 -0500
Message-Id: <20200116164300.6705-94-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 4194b583c104922c6141d6610bfbce26847959df ]

If the DTB for a device with an RZ/A2 SoC lacks a device node for the
BSID register, the ID validation code falls back to using a register at
address 0x0, which leads to undefined behavior (e.g. reading back a
random value).

This could be fixed by letting fam_rza2.reg point to the actual BSID
register.  However, the hardcoded fallbacks were meant for backwards
compatibility with old DTBs only, not for new SoCs.  Hence fix this by
validating renesas_family.reg before using it.

Fixes: 175f435f44b724e3 ("soc: renesas: identify RZ/A2")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20191016143306.28995-1-geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/renesas/renesas-soc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/renesas/renesas-soc.c b/drivers/soc/renesas/renesas-soc.c
index 3299cf5365f3..6651755e9f20 100644
--- a/drivers/soc/renesas/renesas-soc.c
+++ b/drivers/soc/renesas/renesas-soc.c
@@ -326,7 +326,7 @@ static int __init renesas_soc_init(void)
 	if (np) {
 		chipid = of_iomap(np, 0);
 		of_node_put(np);
-	} else if (soc->id) {
+	} else if (soc->id && family->reg) {
 		chipid = ioremap(family->reg, 4);
 	}
 	if (chipid) {
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76A6A11B087
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732755AbfLKPXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:23:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:54824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732749AbfLKPXn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:23:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB2862077B;
        Wed, 11 Dec 2019 15:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077823;
        bh=397+llq5b8ShLmAi4cOwDwNlPSEvwZuhmZI3njME1mE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rT0ISnsA83GDqkAbVEa/316zdxxAx8FORpYs2EppsNCrVcrFO+Aeu/xrf2z+IiUzF
         e2Xryjnn4wuk1oRiGAzWfZYWkgj4W2EWoRiMhMWpxSvGvTP2+WG0vthe+l47ErHvyZ
         8TupCzo0e7uqHm+cAJ36QdGxYKVUrbsq5o4qxn0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 183/243] soc: renesas: r8a77990-sysc: Fix initialization order of 3DG-{A,B}
Date:   Wed, 11 Dec 2019 16:05:45 +0100
Message-Id: <20191211150351.521599663@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit b0d7fbf8b174168c580bb310964c3c809e5569a9 ]

The workaround for the wrong hierarchy of the 3DG-{A,B} power
domains on R-Car E3 ES1.0 corrected the parent domains.
However, the 3DG-{A,B} power domains were still initialized and powered
in the wrong order, causing 3DG operation to fail.

Fix this by changing the order in the table at runtime, when running on
an affected SoC.

Fixes: 086b399965a7ee7e ("soc: renesas: r8a77990-sysc: Add workaround for 3DG-{A,B}")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/renesas/r8a77990-sysc.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/soc/renesas/r8a77990-sysc.c b/drivers/soc/renesas/r8a77990-sysc.c
index 15579ebc5ed20..664b244eb1dd9 100644
--- a/drivers/soc/renesas/r8a77990-sysc.c
+++ b/drivers/soc/renesas/r8a77990-sysc.c
@@ -28,19 +28,6 @@ static struct rcar_sysc_area r8a77990_areas[] __initdata = {
 	{ "3dg-b",	0x100, 1, R8A77990_PD_3DG_B,	R8A77990_PD_3DG_A },
 };
 
-static void __init rcar_sysc_fix_parent(struct rcar_sysc_area *areas,
-					unsigned int num_areas, u8 id,
-					int new_parent)
-{
-	unsigned int i;
-
-	for (i = 0; i < num_areas; i++)
-		if (areas[i].isr_bit == id) {
-			areas[i].parent = new_parent;
-			return;
-		}
-}
-
 /* Fixups for R-Car E3 ES1.0 revision */
 static const struct soc_device_attribute r8a77990[] __initconst = {
 	{ .soc_id = "r8a77990", .revision = "ES1.0" },
@@ -50,12 +37,10 @@ static const struct soc_device_attribute r8a77990[] __initconst = {
 static int __init r8a77990_sysc_init(void)
 {
 	if (soc_device_match(r8a77990)) {
-		rcar_sysc_fix_parent(r8a77990_areas,
-				     ARRAY_SIZE(r8a77990_areas),
-				     R8A77990_PD_3DG_A, R8A77990_PD_3DG_B);
-		rcar_sysc_fix_parent(r8a77990_areas,
-				     ARRAY_SIZE(r8a77990_areas),
-				     R8A77990_PD_3DG_B, R8A77990_PD_ALWAYS_ON);
+		/* Fix incorrect 3DG hierarchy */
+		swap(r8a77990_areas[7], r8a77990_areas[8]);
+		r8a77990_areas[7].parent = R8A77990_PD_ALWAYS_ON;
+		r8a77990_areas[8].parent = R8A77990_PD_3DG_B;
 	}
 
 	return 0;
-- 
2.20.1




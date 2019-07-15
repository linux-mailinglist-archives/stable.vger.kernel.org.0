Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E12D69486
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391181AbfGOObO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:31:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731947AbfGOObL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:31:11 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B89220896;
        Mon, 15 Jul 2019 14:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563201070;
        bh=Ikp9Z7o6849kEBCtpfBb3J6wCZpMPCOBu9zCpU4cQ2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLpiG4TWu3f77BmZDuFR29XrtrLhgvYCh17o08xtW7tNqUExifXo8/pzqHnUTeeWs
         rQ0SRLh2C/HoD8/P69CuAWDuSJc4pRcL5N3W9TWwtp+GcQ/XIdeFt2IxjOuOOMv/eX
         9B1AXE4w05dxWiVXjax3JxELAb+SfmgFKfd7VmKE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 042/105] media: fdp1: Support M3N and E3 platforms
Date:   Mon, 15 Jul 2019 10:27:36 -0400
Message-Id: <20190715142839.9896-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715142839.9896-1-sashal@kernel.org>
References: <20190715142839.9896-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

[ Upstream commit 4e8c120de9268fc26f583268b9d22e7d37c4595f ]

New Gen3 R-Car platforms incorporate the FDP1 with an updated version
register. No code change is required to support these targets, but they
will currently report an error stating that the device can not be
identified.

Update the driver to match against the new device types.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rcar_fdp1.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
index 3245bc45f4a0..a889332d5d30 100644
--- a/drivers/media/platform/rcar_fdp1.c
+++ b/drivers/media/platform/rcar_fdp1.c
@@ -261,6 +261,8 @@ MODULE_PARM_DESC(debug, "activate debug info");
 #define FD1_IP_H3_ES1			0x02010101
 #define FD1_IP_M3W			0x02010202
 #define FD1_IP_H3			0x02010203
+#define FD1_IP_M3N			0x02010204
+#define FD1_IP_E3			0x02010205
 
 /* LUTs */
 #define FD1_LUT_DIF_ADJ			0x1000
@@ -2369,6 +2371,12 @@ static int fdp1_probe(struct platform_device *pdev)
 	case FD1_IP_H3:
 		dprintk(fdp1, "FDP1 Version R-Car H3\n");
 		break;
+	case FD1_IP_M3N:
+		dprintk(fdp1, "FDP1 Version R-Car M3N\n");
+		break;
+	case FD1_IP_E3:
+		dprintk(fdp1, "FDP1 Version R-Car E3\n");
+		break;
 	default:
 		dev_err(fdp1->dev, "FDP1 Unidentifiable (0x%08x)\n",
 				hw_version);
-- 
2.20.1


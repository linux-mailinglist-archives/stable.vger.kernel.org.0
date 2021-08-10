Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122BD3E8134
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234477AbhHJR4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:56:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237378AbhHJRyd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:54:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46EEA60EFF;
        Tue, 10 Aug 2021 17:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617455;
        bh=aC+Hxy9Qty4662lS3IL6kgFcrw0zACzDGOsjZ3zvdBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QT808uUjkrVYjcJI32GCeeAHq3yCkWtjQ11naXdtsBLVyPj39soWmga5hM3F+aED8
         i1TjmkWWBCtVDbWXA9iCg6WY/Pz/DQPRq0Fk2yKplDAmuVLsDL/QETL+GV82j5e1ED
         FX5vevL5V+Mig+UV/snBBbvgFKxNIX3KlUj6SOfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edmund Dea <edmund.j.dea@intel.com>,
        Anitha Chrisanthus <anitha.chrisanthus@intel.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 033/175] drm/kmb: Enable LCD DMA for low TVDDCV
Date:   Tue, 10 Aug 2021 19:29:01 +0200
Message-Id: <20210810173002.052339003@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edmund Dea <edmund.j.dea@intel.com>

[ Upstream commit 0aab5dce395636eddf4e5f33eba88390328a95b4 ]

There's an undocumented dependency between LCD layer enable bits [2-5]
and the AXI pipelined read enable bit [28] in the LCD_CONTROL register.
The proper order of operation is:

1) Clear AXI pipelined read enable bit
2) Set LCD layers
3) Set AXI pipelined read enable bit

With this update, LCD can start DMA when TVDDCV is reduced down to 700mV.

Fixes: 7f7b96a8a0a1 ("drm/kmb: Add support for KeemBay Display")
Signed-off-by: Edmund Dea <edmund.j.dea@intel.com>
Signed-off-by: Anitha Chrisanthus <anitha.chrisanthus@intel.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210728003126.1425028-1-anitha.chrisanthus@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/kmb/kmb_drv.c   | 14 ++++++++++++++
 drivers/gpu/drm/kmb/kmb_plane.c | 15 +++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/kmb/kmb_drv.c b/drivers/gpu/drm/kmb/kmb_drv.c
index 96ea1a2c11dd..c0b1c6f99249 100644
--- a/drivers/gpu/drm/kmb/kmb_drv.c
+++ b/drivers/gpu/drm/kmb/kmb_drv.c
@@ -203,6 +203,7 @@ static irqreturn_t handle_lcd_irq(struct drm_device *dev)
 	unsigned long status, val, val1;
 	int plane_id, dma0_state, dma1_state;
 	struct kmb_drm_private *kmb = to_kmb(dev);
+	u32 ctrl = 0;
 
 	status = kmb_read_lcd(kmb, LCD_INT_STATUS);
 
@@ -227,6 +228,19 @@ static irqreturn_t handle_lcd_irq(struct drm_device *dev)
 				kmb_clr_bitmask_lcd(kmb, LCD_CONTROL,
 						    kmb->plane_status[plane_id].ctrl);
 
+				ctrl = kmb_read_lcd(kmb, LCD_CONTROL);
+				if (!(ctrl & (LCD_CTRL_VL1_ENABLE |
+				    LCD_CTRL_VL2_ENABLE |
+				    LCD_CTRL_GL1_ENABLE |
+				    LCD_CTRL_GL2_ENABLE))) {
+					/* If no LCD layers are using DMA,
+					 * then disable DMA pipelined AXI read
+					 * transactions.
+					 */
+					kmb_clr_bitmask_lcd(kmb, LCD_CONTROL,
+							    LCD_CTRL_PIPELINE_DMA);
+				}
+
 				kmb->plane_status[plane_id].disable = false;
 			}
 		}
diff --git a/drivers/gpu/drm/kmb/kmb_plane.c b/drivers/gpu/drm/kmb/kmb_plane.c
index d5b6195856d1..ecee6782612d 100644
--- a/drivers/gpu/drm/kmb/kmb_plane.c
+++ b/drivers/gpu/drm/kmb/kmb_plane.c
@@ -427,8 +427,14 @@ static void kmb_plane_atomic_update(struct drm_plane *plane,
 
 	kmb_set_bitmask_lcd(kmb, LCD_CONTROL, ctrl);
 
-	/* FIXME no doc on how to set output format,these values are
-	 * taken from the Myriadx tests
+	/* Enable pipeline AXI read transactions for the DMA
+	 * after setting graphics layers. This must be done
+	 * in a separate write cycle.
+	 */
+	kmb_set_bitmask_lcd(kmb, LCD_CONTROL, LCD_CTRL_PIPELINE_DMA);
+
+	/* FIXME no doc on how to set output format, these values are taken
+	 * from the Myriadx tests
 	 */
 	out_format |= LCD_OUTF_FORMAT_RGB888;
 
@@ -526,6 +532,11 @@ struct kmb_plane *kmb_plane_init(struct drm_device *drm)
 		plane->id = i;
 	}
 
+	/* Disable pipeline AXI read transactions for the DMA
+	 * prior to setting graphics layers
+	 */
+	kmb_clr_bitmask_lcd(kmb, LCD_CONTROL, LCD_CTRL_PIPELINE_DMA);
+
 	return primary;
 cleanup:
 	drmm_kfree(drm, plane);
-- 
2.30.2




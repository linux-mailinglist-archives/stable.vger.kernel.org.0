Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C7F50566F
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241266AbiDRNe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244898AbiDRNbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:31:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD898E6A;
        Mon, 18 Apr 2022 05:57:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97832B80E4B;
        Mon, 18 Apr 2022 12:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E332FC385A1;
        Mon, 18 Apr 2022 12:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286639;
        bh=d1WhqMnR0SZYGD78p5l5bAJASVYV7v2GXdl4z6axBfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nkiLQDX2i33nj7//4xxaUKFSzGSEumti3sBiNq5A/npzLnkVLOenKDDXMJfrbD+SG
         wkB3aKD/vManvGNnYu/O89OEpTekfsVel5hntJ+dr3ckkcCgn7/KKviXYtnrTtrOlC
         Et85hv2tVs11drIZX0eCAwYBKckUkytEaJCpHdU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Jing Yao <yao.jing2@zte.com.cn>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 171/284] video: fbdev: omapfb: panel-dsi-cm: Use sysfs_emit() instead of snprintf()
Date:   Mon, 18 Apr 2022 14:12:32 +0200
Message-Id: <20220418121216.606058063@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Yao <yao.jing2@zte.com.cn>

[ Upstream commit f63658a59c3d439c8ad7b290f8ec270980e0f384 ]

Use sysfs_emit instead of scnprintf, snprintf or sprintf.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jing Yao <yao.jing2@zte.com.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c b/drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c
index bef431530090..25cc0bcdfe19 100644
--- a/drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c
+++ b/drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c
@@ -413,7 +413,7 @@ static ssize_t dsicm_num_errors_show(struct device *dev,
 	if (r)
 		return r;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", errors);
+	return sysfs_emit(buf, "%d\n", errors);
 }
 
 static ssize_t dsicm_hw_revision_show(struct device *dev,
@@ -444,7 +444,7 @@ static ssize_t dsicm_hw_revision_show(struct device *dev,
 	if (r)
 		return r;
 
-	return snprintf(buf, PAGE_SIZE, "%02x.%02x.%02x\n", id1, id2, id3);
+	return sysfs_emit(buf, "%02x.%02x.%02x\n", id1, id2, id3);
 }
 
 static ssize_t dsicm_store_ulps(struct device *dev,
@@ -494,7 +494,7 @@ static ssize_t dsicm_show_ulps(struct device *dev,
 	t = ddata->ulps_enabled;
 	mutex_unlock(&ddata->lock);
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", t);
+	return sysfs_emit(buf, "%u\n", t);
 }
 
 static ssize_t dsicm_store_ulps_timeout(struct device *dev,
@@ -541,7 +541,7 @@ static ssize_t dsicm_show_ulps_timeout(struct device *dev,
 	t = ddata->ulps_timeout;
 	mutex_unlock(&ddata->lock);
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", t);
+	return sysfs_emit(buf, "%u\n", t);
 }
 
 static DEVICE_ATTR(num_dsi_errors, S_IRUGO, dsicm_num_errors_show, NULL);
-- 
2.34.1




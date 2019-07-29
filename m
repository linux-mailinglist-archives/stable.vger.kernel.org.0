Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7426E79878
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388548AbfG2Th6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:37:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388795AbfG2Th6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:37:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51E082171F;
        Mon, 29 Jul 2019 19:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429077;
        bh=6gK9q/3ixP2ypfFCq5avtOjd/FjOrw4fbcEoMIVTtc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zg+Zl8L+d/s9H7zBh7/cTQb2c+ITgHkwI3zdvvy22qDbZBP5T4iswy3NOe3x9BNCu
         wGOaOC//3fcFTK4rAV8Rg6jE13JgSTJeGASaEG5V/fgILOsPMnC2rX9MeOqtQWzMzl
         QmC/ol0xJLMCPaCGwgpNHKYYm9LnZGjRiu82D3Kc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 278/293] drm/crc: Only report a single overflow when a CRC fd is opened
Date:   Mon, 29 Jul 2019 21:22:49 +0200
Message-Id: <20190729190845.576584535@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a012024571d98e2e4bf29a9168fb7ddc44b7ab86 ]

This reduces the amount of spam when you debug a CRC reading
program.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
[mlankhorst: Change bool overflow to was_overflow (Ville)]
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20180418125121.72081-1-maarten.lankhorst@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_debugfs_crc.c | 9 ++++++++-
 include/drm/drm_debugfs_crc.h     | 3 ++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_debugfs_crc.c b/drivers/gpu/drm/drm_debugfs_crc.c
index 021813b20e97..f689c75474e5 100644
--- a/drivers/gpu/drm/drm_debugfs_crc.c
+++ b/drivers/gpu/drm/drm_debugfs_crc.c
@@ -139,6 +139,7 @@ static int crtc_crc_data_count(struct drm_crtc_crc *crc)
 static void crtc_crc_cleanup(struct drm_crtc_crc *crc)
 {
 	kfree(crc->entries);
+	crc->overflow = false;
 	crc->entries = NULL;
 	crc->head = 0;
 	crc->tail = 0;
@@ -373,8 +374,14 @@ int drm_crtc_add_crc_entry(struct drm_crtc *crtc, bool has_frame,
 	tail = crc->tail;
 
 	if (CIRC_SPACE(head, tail, DRM_CRC_ENTRIES_NR) < 1) {
+		bool was_overflow = crc->overflow;
+
+		crc->overflow = true;
 		spin_unlock(&crc->lock);
-		DRM_ERROR("Overflow of CRC buffer, userspace reads too slow.\n");
+
+		if (!was_overflow)
+			DRM_ERROR("Overflow of CRC buffer, userspace reads too slow.\n");
+
 		return -ENOBUFS;
 	}
 
diff --git a/include/drm/drm_debugfs_crc.h b/include/drm/drm_debugfs_crc.h
index 7d63b1d4adb9..b225eeb30d05 100644
--- a/include/drm/drm_debugfs_crc.h
+++ b/include/drm/drm_debugfs_crc.h
@@ -43,6 +43,7 @@ struct drm_crtc_crc_entry {
  * @lock: protects the fields in this struct
  * @source: name of the currently configured source of CRCs
  * @opened: whether userspace has opened the data file for reading
+ * @overflow: whether an overflow occured.
  * @entries: array of entries, with size of %DRM_CRC_ENTRIES_NR
  * @head: head of circular queue
  * @tail: tail of circular queue
@@ -52,7 +53,7 @@ struct drm_crtc_crc_entry {
 struct drm_crtc_crc {
 	spinlock_t lock;
 	const char *source;
-	bool opened;
+	bool opened, overflow;
 	struct drm_crtc_crc_entry *entries;
 	int head, tail;
 	size_t values_cnt;
-- 
2.20.1




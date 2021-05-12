Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A547337CE70
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245070AbhELRFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:05:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238133AbhELQoh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:44:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BBDE61C78;
        Wed, 12 May 2021 16:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836059;
        bh=SHgL87Fqqus74sID+k6cGRA9Yz8SA8JOMh1QVIuAZc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MaYhImPvIWFQrvY8ut8Y+Tjz9p8cfM1Iu52E8xDEiQrgksh0K+ujTEmfU/GJa+Asa
         yRpx3nHM+OYtx2k2upcLA5TbCRb7HxXBEJ6KMNEg4pyIfBTyUuhL2upg5dWWP4N1nf
         ZosaNUeZZ59Mp9hNlqPyUs/KIJS4bYRrRD8tNLoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 592/677] wlcore: fix overlapping snprintf arguments in debugfs
Date:   Wed, 12 May 2021 16:50:38 +0200
Message-Id: <20210512144857.050492225@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 7b0e2c4f6be3ec68bf807c84e985e81c21404cd1 ]

gcc complains about undefined behavior in calling snprintf()
with the same buffer as input and output:

drivers/net/wireless/ti/wl18xx/debugfs.c: In function 'diversity_num_of_packets_per_ant_read':
drivers/net/wireless/ti/wl18xx/../wlcore/debugfs.h:86:3: error: 'snprintf' argument 4 overlaps destination object 'buf' [-Werror=restrict]
   86 |   snprintf(buf, sizeof(buf), "%s[%d] = %d\n",  \
      |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   87 |     buf, i, stats->sub.name[i]);   \
      |     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/ti/wl18xx/debugfs.c:24:2: note: in expansion of macro 'DEBUGFS_FWSTATS_FILE_ARRAY'
   24 |  DEBUGFS_FWSTATS_FILE_ARRAY(a, b, c, wl18xx_acx_statistics)
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/ti/wl18xx/debugfs.c:159:1: note: in expansion of macro 'WL18XX_DEBUGFS_FWSTATS_FILE_ARRAY'
  159 | WL18XX_DEBUGFS_FWSTATS_FILE_ARRAY(diversity, num_of_packets_per_ant,

There are probably other ways of handling the debugfs file, without
using on-stack buffers, but a simple workaround here is to remember the
current position in the buffer and just keep printing in there.

Fixes: bcca1bbdd412 ("wlcore: add debugfs macro to help print fw statistics arrays")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210323125723.1961432-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wlcore/boot.c    | 13 ++++++++-----
 drivers/net/wireless/ti/wlcore/debugfs.h |  7 ++++---
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index e14d88e558f0..85abd0a2d1c9 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -72,6 +72,7 @@ static int wlcore_validate_fw_ver(struct wl1271 *wl)
 	unsigned int *min_ver = (wl->fw_type == WL12XX_FW_TYPE_MULTI) ?
 		wl->min_mr_fw_ver : wl->min_sr_fw_ver;
 	char min_fw_str[32] = "";
+	int off = 0;
 	int i;
 
 	/* the chip must be exactly equal */
@@ -105,13 +106,15 @@ static int wlcore_validate_fw_ver(struct wl1271 *wl)
 	return 0;
 
 fail:
-	for (i = 0; i < NUM_FW_VER; i++)
+	for (i = 0; i < NUM_FW_VER && off < sizeof(min_fw_str); i++)
 		if (min_ver[i] == WLCORE_FW_VER_IGNORE)
-			snprintf(min_fw_str, sizeof(min_fw_str),
-				  "%s*.", min_fw_str);
+			off += snprintf(min_fw_str + off,
+					sizeof(min_fw_str) - off,
+					"*.");
 		else
-			snprintf(min_fw_str, sizeof(min_fw_str),
-				  "%s%u.", min_fw_str, min_ver[i]);
+			off += snprintf(min_fw_str + off,
+					sizeof(min_fw_str) - off,
+					"%u.", min_ver[i]);
 
 	wl1271_error("Your WiFi FW version (%u.%u.%u.%u.%u) is invalid.\n"
 		     "Please use at least FW %s\n"
diff --git a/drivers/net/wireless/ti/wlcore/debugfs.h b/drivers/net/wireless/ti/wlcore/debugfs.h
index b143293e694f..715edfa5f89f 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.h
+++ b/drivers/net/wireless/ti/wlcore/debugfs.h
@@ -78,13 +78,14 @@ static ssize_t sub## _ ##name## _read(struct file *file,		\
 	struct wl1271 *wl = file->private_data;				\
 	struct struct_type *stats = wl->stats.fw_stats;			\
 	char buf[DEBUGFS_FORMAT_BUFFER_SIZE] = "";			\
+	int pos = 0;							\
 	int i;								\
 									\
 	wl1271_debugfs_update_stats(wl);				\
 									\
-	for (i = 0; i < len; i++)					\
-		snprintf(buf, sizeof(buf), "%s[%d] = %d\n",		\
-			 buf, i, stats->sub.name[i]);			\
+	for (i = 0; i < len && pos < sizeof(buf); i++)			\
+		pos += snprintf(buf + pos, sizeof(buf),			\
+			 "[%d] = %d\n", i, stats->sub.name[i]);		\
 									\
 	return wl1271_format_buffer(userbuf, count, ppos, "%s", buf);	\
 }									\
-- 
2.30.2




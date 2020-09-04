Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D048925D9AB
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 15:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730212AbgIDNda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 09:33:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730451AbgIDNaV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 09:30:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFFA82074D;
        Fri,  4 Sep 2020 13:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599226203;
        bh=XcG9GkBVTmVMCdpNi2uhzvlMRINLawkgoypdeuFEcGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HJS5/+DkTEuGjXdPxRCLAjwmen9Yu+KDfORuIDwYGC5gL4Ar0VfVp0hTA756huU0E
         FZ/orR6NA0cGsiR43YifLTed0xH+auFlj7axGtch1zgrj0FNDw/WkMW8dGyz+PNd8Z
         VpcgQ23vUSH5QlQJiRNXuPO1t7/RtoPwPNv4vIU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Walter Lozano <walter.lozano@collabora.com>,
        Jonathan Marek <jonathan@marek.ca>
Subject: [PATCH 5.4 05/16] drm/etnaviv: fix TS cache flushing on GPUs with BLT engine
Date:   Fri,  4 Sep 2020 15:29:58 +0200
Message-Id: <20200904120257.464056467@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904120257.203708503@linuxfoundation.org>
References: <20200904120257.203708503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

commit f232d9ec029ce3e2543b05213e2979e01e503408 upstream.

As seen in the Vivante kernel driver, most GPUs with the BLT engine have
a broken TS cache flush. The workaround is to temporarily set the BLT
command to CLEAR_IMAGE, without actually executing the clear. Apparently
this state change is enough to trigger the required TS cache flush. As
the BLT engine is completely asychronous, we also need a few more stall
states to synchronize the flush with the frontend.

Root-caused-by: Jonathan Marek <jonathan@marek.ca>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Cc: Walter Lozano <walter.lozano@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c |   60 ++++++++++++++++++++++++++++---
 drivers/gpu/drm/etnaviv/state_blt.xml.h  |    2 +
 2 files changed, 57 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
@@ -12,6 +12,7 @@
 
 #include "common.xml.h"
 #include "state.xml.h"
+#include "state_blt.xml.h"
 #include "state_hi.xml.h"
 #include "state_3d.xml.h"
 #include "cmdstream.xml.h"
@@ -233,6 +234,8 @@ void etnaviv_buffer_end(struct etnaviv_g
 	struct etnaviv_cmdbuf *buffer = &gpu->buffer;
 	unsigned int waitlink_offset = buffer->user_size - 16;
 	u32 link_target, flush = 0;
+	bool has_blt = !!(gpu->identity.minor_features5 &
+			  chipMinorFeatures5_BLT_ENGINE);
 
 	lockdep_assert_held(&gpu->lock);
 
@@ -248,16 +251,38 @@ void etnaviv_buffer_end(struct etnaviv_g
 	if (flush) {
 		unsigned int dwords = 7;
 
+		if (has_blt)
+			dwords += 10;
+
 		link_target = etnaviv_buffer_reserve(gpu, buffer, dwords);
 
 		CMD_SEM(buffer, SYNC_RECIPIENT_FE, SYNC_RECIPIENT_PE);
 		CMD_STALL(buffer, SYNC_RECIPIENT_FE, SYNC_RECIPIENT_PE);
+		if (has_blt) {
+			CMD_LOAD_STATE(buffer, VIVS_BLT_ENABLE, 0x1);
+			CMD_SEM(buffer, SYNC_RECIPIENT_FE, SYNC_RECIPIENT_BLT);
+			CMD_STALL(buffer, SYNC_RECIPIENT_FE, SYNC_RECIPIENT_BLT);
+			CMD_LOAD_STATE(buffer, VIVS_BLT_ENABLE, 0x0);
+		}
 		CMD_LOAD_STATE(buffer, VIVS_GL_FLUSH_CACHE, flush);
-		if (gpu->exec_state == ETNA_PIPE_3D)
-			CMD_LOAD_STATE(buffer, VIVS_TS_FLUSH_CACHE,
-				       VIVS_TS_FLUSH_CACHE_FLUSH);
+		if (gpu->exec_state == ETNA_PIPE_3D) {
+			if (has_blt) {
+				CMD_LOAD_STATE(buffer, VIVS_BLT_ENABLE, 0x1);
+				CMD_LOAD_STATE(buffer, VIVS_BLT_SET_COMMAND, 0x1);
+				CMD_LOAD_STATE(buffer, VIVS_BLT_ENABLE, 0x0);
+			} else {
+				CMD_LOAD_STATE(buffer, VIVS_TS_FLUSH_CACHE,
+					       VIVS_TS_FLUSH_CACHE_FLUSH);
+			}
+		}
 		CMD_SEM(buffer, SYNC_RECIPIENT_FE, SYNC_RECIPIENT_PE);
 		CMD_STALL(buffer, SYNC_RECIPIENT_FE, SYNC_RECIPIENT_PE);
+		if (has_blt) {
+			CMD_LOAD_STATE(buffer, VIVS_BLT_ENABLE, 0x1);
+			CMD_SEM(buffer, SYNC_RECIPIENT_FE, SYNC_RECIPIENT_BLT);
+			CMD_STALL(buffer, SYNC_RECIPIENT_FE, SYNC_RECIPIENT_BLT);
+			CMD_LOAD_STATE(buffer, VIVS_BLT_ENABLE, 0x0);
+		}
 		CMD_END(buffer);
 
 		etnaviv_buffer_replace_wait(buffer, waitlink_offset,
@@ -323,6 +348,8 @@ void etnaviv_buffer_queue(struct etnaviv
 	bool switch_mmu_context = gpu->mmu_context != mmu_context;
 	unsigned int new_flush_seq = READ_ONCE(gpu->mmu_context->flush_seq);
 	bool need_flush = switch_mmu_context || gpu->flush_seq != new_flush_seq;
+	bool has_blt = !!(gpu->identity.minor_features5 &
+			  chipMinorFeatures5_BLT_ENGINE);
 
 	lockdep_assert_held(&gpu->lock);
 
@@ -433,6 +460,15 @@ void etnaviv_buffer_queue(struct etnaviv
 	 * 2 semaphore stall + 1 event + 1 wait + 1 link.
 	 */
 	return_dwords = 7;
+
+	/*
+	 * When the BLT engine is present we need 6 more dwords in the return
+	 * target: 3 enable/flush/disable + 4 enable/semaphore stall/disable,
+	 * but we don't need the normal TS flush state.
+	 */
+	if (has_blt)
+		return_dwords += 6;
+
 	return_target = etnaviv_buffer_reserve(gpu, buffer, return_dwords);
 	CMD_LINK(cmdbuf, return_dwords, return_target);
 
@@ -447,11 +483,25 @@ void etnaviv_buffer_queue(struct etnaviv
 		CMD_LOAD_STATE(buffer, VIVS_GL_FLUSH_CACHE,
 				       VIVS_GL_FLUSH_CACHE_DEPTH |
 				       VIVS_GL_FLUSH_CACHE_COLOR);
-		CMD_LOAD_STATE(buffer, VIVS_TS_FLUSH_CACHE,
-				       VIVS_TS_FLUSH_CACHE_FLUSH);
+		if (has_blt) {
+			CMD_LOAD_STATE(buffer, VIVS_BLT_ENABLE, 0x1);
+			CMD_LOAD_STATE(buffer, VIVS_BLT_SET_COMMAND, 0x1);
+			CMD_LOAD_STATE(buffer, VIVS_BLT_ENABLE, 0x0);
+		} else {
+			CMD_LOAD_STATE(buffer, VIVS_TS_FLUSH_CACHE,
+					       VIVS_TS_FLUSH_CACHE_FLUSH);
+		}
 	}
 	CMD_SEM(buffer, SYNC_RECIPIENT_FE, SYNC_RECIPIENT_PE);
 	CMD_STALL(buffer, SYNC_RECIPIENT_FE, SYNC_RECIPIENT_PE);
+
+	if (has_blt) {
+		CMD_LOAD_STATE(buffer, VIVS_BLT_ENABLE, 0x1);
+		CMD_SEM(buffer, SYNC_RECIPIENT_FE, SYNC_RECIPIENT_BLT);
+		CMD_STALL(buffer, SYNC_RECIPIENT_FE, SYNC_RECIPIENT_BLT);
+		CMD_LOAD_STATE(buffer, VIVS_BLT_ENABLE, 0x0);
+	}
+
 	CMD_LOAD_STATE(buffer, VIVS_GL_EVENT, VIVS_GL_EVENT_EVENT_ID(event) |
 		       VIVS_GL_EVENT_FROM_PE);
 	CMD_WAIT(buffer);
--- a/drivers/gpu/drm/etnaviv/state_blt.xml.h
+++ b/drivers/gpu/drm/etnaviv/state_blt.xml.h
@@ -46,6 +46,8 @@ DEALINGS IN THE SOFTWARE.
 
 /* This is a cut-down version of the state_blt.xml.h file */
 
+#define VIVS_BLT_SET_COMMAND					0x000140ac
+
 #define VIVS_BLT_ENABLE						0x000140b8
 #define VIVS_BLT_ENABLE_ENABLE					0x00000001
 



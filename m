Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C37E69CE85
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbjBTN7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbjBTN7n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:59:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0451F1E9E0
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:59:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8681460EA5
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1D4C433D2;
        Mon, 20 Feb 2023 13:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901561;
        bh=YNLyIVRVxLzZjl2teEsz55uXci79wNQmkekQSx3mLAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ru0plJTaNAf0UeJ3oeUVEsLYVfri1V3kmhCZu84Z5nj8wDmXg719Io6nl9cmyKi9c
         LjuK6A6NdwAgYD6/u4VzcRlSNSBP9Kl7R2OpaNThFPmzIMuvE/VJ8BDMZgm1Y2/CiT
         SGGylJKoSe5d8ZmVuvrZaEZZNO0hl9dth7FnTHIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hansen Dsouza <hansen.dsouza@amd.com>,
        Alex Hung <alex.hung@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/118] drm/amd/display: Reset DMUB mailbox SW state after HW reset
Date:   Mon, 20 Feb 2023 14:35:52 +0100
Message-Id: <20230220133601.877530362@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_PDS_OTHER_BAD_TLD autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 154711aa5759ef9b45903124fa813c4c29ee681c ]

[Why]
Otherwise we can be out of sync with what's in the hardware, leading
to us rerunning every command that's presently in the ringbuffer.

[How]
Reset software state for the mailboxes in hw_reset callback.
This is already done as part of the mailbox init in hw_init, but we
do need to remember to reset the last cached wptr value as well here.

Reviewed-by: Hansen Dsouza <hansen.dsouza@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c b/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
index 4a122925c3ae9..92c18bfb98b3b 100644
--- a/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
@@ -532,6 +532,9 @@ enum dmub_status dmub_srv_hw_init(struct dmub_srv *dmub,
 	if (dmub->hw_funcs.reset)
 		dmub->hw_funcs.reset(dmub);
 
+	/* reset the cache of the last wptr as well now that hw is reset */
+	dmub->inbox1_last_wptr = 0;
+
 	cw0.offset.quad_part = inst_fb->gpu_addr;
 	cw0.region.base = DMUB_CW0_BASE;
 	cw0.region.top = cw0.region.base + inst_fb->size - 1;
@@ -649,6 +652,15 @@ enum dmub_status dmub_srv_hw_reset(struct dmub_srv *dmub)
 	if (dmub->hw_funcs.reset)
 		dmub->hw_funcs.reset(dmub);
 
+	/* mailboxes have been reset in hw, so reset the sw state as well */
+	dmub->inbox1_last_wptr = 0;
+	dmub->inbox1_rb.wrpt = 0;
+	dmub->inbox1_rb.rptr = 0;
+	dmub->outbox0_rb.wrpt = 0;
+	dmub->outbox0_rb.rptr = 0;
+	dmub->outbox1_rb.wrpt = 0;
+	dmub->outbox1_rb.rptr = 0;
+
 	dmub->hw_init = false;
 
 	return DMUB_STATUS_OK;
-- 
2.39.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEE54F34C2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242423AbiDEJhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235558AbiDEJCP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:02:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0482610D2;
        Tue,  5 Apr 2022 01:53:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8ED26614E4;
        Tue,  5 Apr 2022 08:53:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D04EC385A0;
        Tue,  5 Apr 2022 08:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148838;
        bh=sEUchKfDYORn7K/j5O1EnCAJAMVtyD6pYVimoakaOrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1wTQm8S0KVJmMPCmQCABANqH6yDSZClFMgmWS4GD6QBWKqmfyuuZhWyUdUryS5jDX
         ZueUu9IUgD6y6e38q9hMG7k8ddp8oUY5HYvZ/oDV5HmkUfifOs++Wm4tab8gVCgyYZ
         dfsCajpdEgRrNe89aYhB8mmCkrk9+koPERxWA6hI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pin-Yen Lin <treapking@chromium.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0498/1017] drm/bridge: anx7625: Fix overflow issue on reading EDID
Date:   Tue,  5 Apr 2022 09:23:31 +0200
Message-Id: <20220405070409.081464001@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pin-Yen Lin <treapking@chromium.org>

[ Upstream commit d5c6f647aec9ed524aedd04a3aec5ebc21d39007 ]

The length of EDID block can be longer than 256 bytes, so we should use
`int` instead of `u8` for the `edid_pos` variable.

Fixes: 8bdfc5dae4e3 ("drm/bridge: anx7625: Add anx7625 MIPI DSI/DPI to DP")
Signed-off-by: Pin-Yen Lin <treapking@chromium.org>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220210103827.402436-1-treapking@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 1a871f6b6822..9b2421040926 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -791,7 +791,8 @@ static int segments_edid_read(struct anx7625_data *ctx,
 static int sp_tx_edid_read(struct anx7625_data *ctx,
 			   u8 *pedid_blocks_buf)
 {
-	u8 offset, edid_pos;
+	u8 offset;
+	int edid_pos;
 	int count, blocks_num;
 	u8 pblock_buf[MAX_DPCD_BUFFER_SIZE];
 	u8 i, j;
-- 
2.34.1




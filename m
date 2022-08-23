Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E89959D458
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242353AbiHWIWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243662AbiHWIVb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:21:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA576FA2D;
        Tue, 23 Aug 2022 01:12:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F2EFB81C34;
        Tue, 23 Aug 2022 08:12:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF4EC433D6;
        Tue, 23 Aug 2022 08:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242363;
        bh=5fGGGCUByUMANmzZki7jrEJzyO17MPcManh7jS7dckI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y85rH6ZO8L+5joR9nx/768CUzr2NvQ74D2UFmYGy/3K/Nc+ZCEkLWNwRMVGq5g8IA
         Qgy5v+mwvFEL+qgUSDVDUtPBz3yNdCJ23OeqQ8NZMAAa4OyyPmXYtN2k+cnGYB2IJU
         IyavSKdFUqCh2LO0UTIPpBZV3IUhkNCVqm/pIJVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff LaBundy <jeff@labundy.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.19 104/365] Input: iqs7222 - correct slider event disable logic
Date:   Tue, 23 Aug 2022 10:00:05 +0200
Message-Id: <20220823080122.546894052@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jeff LaBundy <jeff@labundy.com>

commit 56a0c54c4c2bdb6c0952de90dd690020a703b50e upstream.

If a positive swipe/flick gesture is defined but the corresponding
negative gesture is not, the former is inadvertently disabled. Fix
this by gently refactoring the logic responsible for disabling all
gestures by default.

As part of this change, make the code a bit simpler by eliminating
a superfluous conditional check. If a slider event does not define
an enable control, the second term of the bitwise AND operation is
simply 0xFFFF.

Fixes: e505edaedcb9 ("Input: add support for Azoteq IQS7222A/B/C")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Link: https://lore.kernel.org/r/20220626072412.475211-2-jeff@labundy.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/iqs7222.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/input/misc/iqs7222.c b/drivers/input/misc/iqs7222.c
index 6b4138771a3f..53df74f3a982 100644
--- a/drivers/input/misc/iqs7222.c
+++ b/drivers/input/misc/iqs7222.c
@@ -2081,17 +2081,19 @@ static int iqs7222_parse_sldr(struct iqs7222_private *iqs7222, int sldr_index)
 			sldr_setup[0] |= dev_desc->wheel_enable;
 	}
 
+	/*
+	 * The absence of a register offset makes it safe to assume the device
+	 * supports gestures, each of which is first disabled until explicitly
+	 * enabled.
+	 */
+	if (!reg_offset)
+		for (i = 0; i < ARRAY_SIZE(iqs7222_sl_events); i++)
+			sldr_setup[9] &= ~iqs7222_sl_events[i].enable;
+
 	for (i = 0; i < ARRAY_SIZE(iqs7222_sl_events); i++) {
 		const char *event_name = iqs7222_sl_events[i].name;
 		struct fwnode_handle *event_node;
 
-		/*
-		 * The absence of a register offset means the remaining fields
-		 * in the group represent gesture settings.
-		 */
-		if (iqs7222_sl_events[i].enable && !reg_offset)
-			sldr_setup[9] &= ~iqs7222_sl_events[i].enable;
-
 		event_node = fwnode_get_named_child_node(sldr_node, event_name);
 		if (!event_node)
 			continue;
-- 
2.37.2




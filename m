Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6146DEF82
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbjDLIvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjDLIvX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:51:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B619ED5
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:51:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F3E56315F
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80072C4339B;
        Wed, 12 Apr 2023 08:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289459;
        bh=YQnNQt7CxdHc4JbsKj8GZDSEirSM6ocPn87ivi1fzSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ct3RL0DJshTof4jsI67ps7TiuD6mWBiOdbNfrsnFeuKyixowxy24Xa6Urgyll3EYD
         U4F3/99+PKmUCeZyo7tn8dcvFzntIQSOs47v8eUtyhGprqsgMj3XmQZN/1RMPvg2iJ
         oqG0Us41Zc2DTwLIWtyU4P7xRii4BWh+KI6OaXfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        William Breathitt Gray <william.gray@linaro.org>
Subject: [PATCH 6.2 107/173] counter: 104-quad-8: Fix Synapse action reported for Index signals
Date:   Wed, 12 Apr 2023 10:33:53 +0200
Message-Id: <20230412082842.390602253@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Breathitt Gray <william.gray@linaro.org>

commit 00f4bc5184c19cb33f468f1ea409d70d19f8f502 upstream.

Signal 16 and higher represent the device's Index lines. The
priv->preset_enable array holds the device configuration for these Index
lines. The preset_enable configuration is active low on the device, so
invert the conditional check in quad8_action_read() to properly handle
the logical state of preset_enable.

Fixes: f1d8a071d45b ("counter: 104-quad-8: Add Generic Counter interface support")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230316203426.224745-1-william.gray@linaro.org/
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/counter/104-quad-8.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -368,7 +368,7 @@ static int quad8_action_read(struct coun
 
 	/* Handle Index signals */
 	if (synapse->signal->id >= 16) {
-		if (priv->preset_enable[count->id])
+		if (!priv->preset_enable[count->id])
 			*action = COUNTER_SYNAPSE_ACTION_RISING_EDGE;
 		else
 			*action = COUNTER_SYNAPSE_ACTION_NONE;



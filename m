Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611976B4877
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbjCJPCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:02:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233691AbjCJPCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:02:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCFF12699B
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:55:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F7D9B822C4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E86C433EF;
        Fri, 10 Mar 2023 14:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460138;
        bh=BpaCvjHstwohFKvmfRFHzfT7utRHAdkEdknYrjOxetE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wK2N4SLdscI6mqesPIa05r0mwemsFeKSMBnmA4aH2QKR73sQa0f72rvZoFnlzMpn8
         SFEu2u59Movz82aIcRGOtv1nv3TLn8x+2VA8WpYre/de4E2qFaWf9DtsIqfP85grEe
         M/bTq0OG9Swg0lPa4Iqq4JrThOOk1b5ILNJznbxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff LaBundy <jeff@labundy.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 235/529] Input: iqs269a - drop unused device node references
Date:   Fri, 10 Mar 2023 14:36:18 +0100
Message-Id: <20230310133815.877991153@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

From: Jeff LaBundy <jeff@labundy.com>

[ Upstream commit 59bc9cb3b80abaa42643abede0d5db8477901d9c ]

Each call to device/fwnode_get_named_child_node() must be matched
with a call to fwnode_handle_put() once the corresponding node is
no longer in use. This ensures a reference count remains balanced
in the case of dynamic device tree support.

Currently, the driver does not call fwnode_handle_put() on nested
event nodes. This patch solves this problem by adding the missing
instances of fwnode_handle_put().

As part of this change, the logic which parses each channel's key
code is gently refactored in order to reduce the number of places
from which fwnode_handle_put() is called.

Fixes: 04e49867fad1 ("Input: add support for Azoteq IQS269A")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Link: https://lore.kernel.org/r/Y7Rsx68k/gvDVXAt@nixie71
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/iqs269a.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/input/misc/iqs269a.c b/drivers/input/misc/iqs269a.c
index a348247d3d38f..ea3c97c5f764f 100644
--- a/drivers/input/misc/iqs269a.c
+++ b/drivers/input/misc/iqs269a.c
@@ -694,6 +694,7 @@ static int iqs269_parse_chan(struct iqs269_private *iqs269,
 				dev_err(&client->dev,
 					"Invalid channel %u threshold: %u\n",
 					reg, val);
+				fwnode_handle_put(ev_node);
 				return -EINVAL;
 			}
 
@@ -707,6 +708,7 @@ static int iqs269_parse_chan(struct iqs269_private *iqs269,
 				dev_err(&client->dev,
 					"Invalid channel %u hysteresis: %u\n",
 					reg, val);
+				fwnode_handle_put(ev_node);
 				return -EINVAL;
 			}
 
@@ -721,8 +723,16 @@ static int iqs269_parse_chan(struct iqs269_private *iqs269,
 			}
 		}
 
-		if (fwnode_property_read_u32(ev_node, "linux,code", &val))
+		error = fwnode_property_read_u32(ev_node, "linux,code", &val);
+		fwnode_handle_put(ev_node);
+		if (error == -EINVAL) {
 			continue;
+		} else if (error) {
+			dev_err(&client->dev,
+				"Failed to read channel %u code: %d\n", reg,
+				error);
+			return error;
+		}
 
 		switch (reg) {
 		case IQS269_CHx_HALL_ACTIVE:
-- 
2.39.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21E5053830D
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240121AbiE3O3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241595AbiE3O0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:26:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECDFAEE2F;
        Mon, 30 May 2022 06:51:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21DE1B80DEA;
        Mon, 30 May 2022 13:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F7FDC385B8;
        Mon, 30 May 2022 13:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918629;
        bh=CmzaiCE6+SXzp7lDT1daqpaJ9oOcu7NO70qIm9BZRvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XoCVqZHO9guCLth4+cPqLQhxZiX1ZgzYYwZ0d+pfMectbqDAmRvRo0/IPo01LETuN
         6NVw3L0Xa3xOPI27+zAIlg81cksKPV2/z3bPothfsyadNPQ2EWJY7oubBkZeyjfn98
         w4liuBwBsZEBbWzDcc6UujZwD26wc5mgY0SNpaZMV20jW1wmcUz9paFhIHzus/4TJf
         yQpc3bjgbaZVEujBnnPyNgIDlqxjnWTOLaBrzIshjbCgETFnkDIxp43geHSxDebZlS
         9G7h/6j+csVCdtnAMzS0eiqjTbSRz73KaaykNBW1Jaa/PZxuiSnE+uANMIfwFOQs0a
         LWKgFKn7env+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Corey Minyard <cminyard@mvista.com>,
        Haowen Bai <baihaowen@meizu.com>,
        Sasha Levin <sashal@kernel.org>,
        openipmi-developer@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 27/38] ipmi:ssif: Check for NULL msg when handling events and messages
Date:   Mon, 30 May 2022 09:49:13 -0400
Message-Id: <20220530134924.1936816-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134924.1936816-1-sashal@kernel.org>
References: <20220530134924.1936816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Corey Minyard <cminyard@mvista.com>

[ Upstream commit 7602b957e2404e5f98d9a40b68f1fd27f0028712 ]

Even though it's not possible to get into the SSIF_GETTING_MESSAGES and
SSIF_GETTING_EVENTS states without a valid message in the msg field,
it's probably best to be defensive here and check and print a log, since
that means something else went wrong.

Also add a default clause to that switch statement to release the lock
and print a log, in case the state variable gets messed up somehow.

Reported-by: Haowen Bai <baihaowen@meizu.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_ssif.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index fec679433f72..fd1a487443f0 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -801,6 +801,14 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 		break;
 
 	case SSIF_GETTING_EVENTS:
+		if (!msg) {
+			/* Should never happen, but just in case. */
+			dev_warn(&ssif_info->client->dev,
+				 "No message set while getting events\n");
+			ipmi_ssif_unlock_cond(ssif_info, flags);
+			break;
+		}
+
 		if ((result < 0) || (len < 3) || (msg->rsp[2] != 0)) {
 			/* Error getting event, probably done. */
 			msg->done(msg);
@@ -824,6 +832,14 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 		break;
 
 	case SSIF_GETTING_MESSAGES:
+		if (!msg) {
+			/* Should never happen, but just in case. */
+			dev_warn(&ssif_info->client->dev,
+				 "No message set while getting messages\n");
+			ipmi_ssif_unlock_cond(ssif_info, flags);
+			break;
+		}
+
 		if ((result < 0) || (len < 3) || (msg->rsp[2] != 0)) {
 			/* Error getting event, probably done. */
 			msg->done(msg);
@@ -846,6 +862,13 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 			deliver_recv_msg(ssif_info, msg);
 		}
 		break;
+
+	default:
+		/* Should never happen, but just in case. */
+		dev_warn(&ssif_info->client->dev,
+			 "Invalid state in message done handling: %d\n",
+			 ssif_info->ssif_state);
+		ipmi_ssif_unlock_cond(ssif_info, flags);
 	}
 
 	flags = ipmi_ssif_lock_cond(ssif_info, &oflags);
-- 
2.35.1


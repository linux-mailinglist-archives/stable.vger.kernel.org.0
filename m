Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F0B50503A
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238381AbiDRMXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238616AbiDRMWk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:22:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B301EAC5;
        Mon, 18 Apr 2022 05:17:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4D2C60F0A;
        Mon, 18 Apr 2022 12:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4BFC385A7;
        Mon, 18 Apr 2022 12:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284275;
        bh=u2vTfM59zCoYXkVZjjnb6Jnt62iRrSVgGWuK04ScvMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G7UY44JKz8bHwLstUtUOTLTDgdWjkhXwqm7ui2hG48lXURI3lTeFO9EXTocbWIQPc
         e4cXlR+02r1+VxjDZM5tkbPsA841mBuAUb3ODATJKxBqN3V+gXclrwYG+f0guf5eOX
         hGKbihUBjMhds/MUgc7sG8mfD/Oqq7qVT6sG9BQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 060/219] firmware: arm_scmi: Remove clear channel call on the TX channel
Date:   Mon, 18 Apr 2022 14:10:29 +0200
Message-Id: <20220418121207.111634909@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
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

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 98f0d68f94ea21541e0050cc64fa108ade779839 ]

On SCMI transports whose channels are based on a shared resource the TX
channel area has to be acquired by the agent before placing the desired
command into the channel and it will be then relinquished by the platform
once the related reply has been made available into the channel.
On an RX channel the logic is reversed with the platform acquiring the
channel area and the agent reliquishing it once done by calling the
scmi_clear_channel() helper.

As a consequence, even in case of error, the agent must never try to clear
a TX channel from its side: restrict the existing clear channel call on the
the reply path only to delayed responses since they are indeed coming from
the RX channel.

Link: https://lore.kernel.org/r/20220224152404.12877-1-cristian.marussi@arm.com
Fixes: e9b21c96181c ("firmware: arm_scmi: Make .clear_channel optional")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index d76bab3aaac4..e815b8f98739 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -652,7 +652,8 @@ static void scmi_handle_response(struct scmi_chan_info *cinfo,
 
 	xfer = scmi_xfer_command_acquire(cinfo, msg_hdr);
 	if (IS_ERR(xfer)) {
-		scmi_clear_channel(info, cinfo);
+		if (MSG_XTRACT_TYPE(msg_hdr) == MSG_TYPE_DELAYED_RESP)
+			scmi_clear_channel(info, cinfo);
 		return;
 	}
 
-- 
2.35.1




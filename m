Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4DC6AF0FE
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbjCGShT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233382AbjCGSgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:36:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B09F9E052
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:28:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38BFC61540
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FE1C433A1;
        Tue,  7 Mar 2023 18:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213692;
        bh=0UrN5Ya4jNeVaBqvPSKD6LjakYrw8VQiuRe0x97UxME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X9R+7CNj5sn5T21//MwJ8funO3DXaWTJ2RTEbtTMRmQQcoaWJeKqkBZLWtgKBe3uo
         IrdR9p+T3aUXu962g321x36xI9Xt4qeIurbUz10fMaVr3yZIw0B1GkPNbGxhpmUOkk
         LkHU1gP4iSta1TxhMbsjLFk2Dm/Y/4u3aU5deWCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Kelley <mikelley@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 588/885] hv_netvsc: Check status in SEND_RNDIS_PKT completion message
Date:   Tue,  7 Mar 2023 17:58:42 +0100
Message-Id: <20230307170027.933276710@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Kelley <mikelley@microsoft.com>

[ Upstream commit dca5161f9bd052e9e73be90716ffd57e8762c697 ]

Completion responses to SEND_RNDIS_PKT messages are currently processed
regardless of the status in the response, so that resources associated
with the request are freed.  While this is appropriate, code bugs that
cause sending a malformed message, or errors on the Hyper-V host, go
undetected. Fix this by checking the status and outputting a rate-limited
message if there is an error.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Link: https://lore.kernel.org/r/1676264881-48928-1-git-send-email-mikelley@microsoft.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/netvsc.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 79f4e13620a46..da737d959e81c 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -851,6 +851,7 @@ static void netvsc_send_completion(struct net_device *ndev,
 	u32 msglen = hv_pkt_datalen(desc);
 	struct nvsp_message *pkt_rqst;
 	u64 cmd_rqst;
+	u32 status;
 
 	/* First check if this is a VMBUS completion without data payload */
 	if (!msglen) {
@@ -922,6 +923,23 @@ static void netvsc_send_completion(struct net_device *ndev,
 		break;
 
 	case NVSP_MSG1_TYPE_SEND_RNDIS_PKT_COMPLETE:
+		if (msglen < sizeof(struct nvsp_message_header) +
+		    sizeof(struct nvsp_1_message_send_rndis_packet_complete)) {
+			if (net_ratelimit())
+				netdev_err(ndev, "nvsp_rndis_pkt_complete length too small: %u\n",
+					   msglen);
+			return;
+		}
+
+		/* If status indicates an error, output a message so we know
+		 * there's a problem. But process the completion anyway so the
+		 * resources are released.
+		 */
+		status = nvsp_packet->msg.v1_msg.send_rndis_pkt_complete.status;
+		if (status != NVSP_STAT_SUCCESS && net_ratelimit())
+			netdev_err(ndev, "nvsp_rndis_pkt_complete error status: %x\n",
+				   status);
+
 		netvsc_send_tx_complete(ndev, net_device, incoming_channel,
 					desc, budget);
 		break;
-- 
2.39.2




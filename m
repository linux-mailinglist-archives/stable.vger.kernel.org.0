Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8A7541BE1
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378683AbiFGVzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384080AbiFGVyH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:54:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D76FF07;
        Tue,  7 Jun 2022 12:12:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AAFBB823B1;
        Tue,  7 Jun 2022 19:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B625C385A2;
        Tue,  7 Jun 2022 19:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629139;
        bh=eQUZ+ey7/BLiW6pckJTv8Wved40zL6Bggxfybl1hKZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DP0Z5hoI8B6wdyUW6aI5qK6okKE8K8kBG14vnL8R/fT5aiXu6ISTUYlqfrTQjXa16
         CKk5hAAXzYRWaHO0Ga2n3JXNW28vdyjz0dcI4Ey3zG1LVR4GoklVIgpc2EkZH7cWzB
         CXM+xuB6YzZFDHR2XRGT71MU3YjT26jK9kHt+qoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 582/879] Drivers: hv: vmbus: Fix handling of messages with transaction ID of zero
Date:   Tue,  7 Jun 2022 19:01:40 +0200
Message-Id: <20220607165019.746812158@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Parri (Microsoft) <parri.andrea@gmail.com>

[ Upstream commit 82cd4bacff88a11e36f143e2cb950174b09c86c3 ]

vmbus_request_addr() returns 0 (zero) if the transaction ID passed
to as argument is 0.  This is unfortunate for two reasons: first,
netvsc_send_completion() does not check for a NULL cmd_rqst (before
dereferencing the corresponding NVSP message); second, 0 is a *valid*
value of cmd_rqst in netvsc_send_tx_complete(), cf. the call of
vmbus_sendpacket() in netvsc_send_pkt().

vmbus_request_addr() has included the code in question since its
introduction with commit e8b7db38449ac ("Drivers: hv: vmbus: Add
vmbus_requestor data structure for VMBus hardening"); such code was
motivated by the early use of vmbus_requestor by hv_storvsc.  Since
hv_storvsc moved to a tag-based mechanism to generate and retrieve
transaction IDs with commit bf5fd8cae3c8f ("scsi: storvsc: Use
blk_mq_unique_tag() to generate requestIDs"), vmbus_request_addr()
can be modified to return VMBUS_RQST_ERROR if the ID is 0.  This
change solves the issues in hv_netvsc (and makes the handling of
messages with transaction ID of 0 consistent with the semantics
"the ID is not contained in the requestor/invalid ID").

vmbus_next_request_id(), vmbus_request_addr() should still reserve
the ID of 0 for Hyper-V, because Hyper-V will "ignore" (not respond
to) VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED packets/requests with
transaction ID of 0 from the guest.

Fixes: bf5fd8cae3c8f ("scsi: storvsc: Use blk_mq_unique_tag() to generate requestIDs")
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20220419122325.10078-2-parri.andrea@gmail.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/channel.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index dc5c35210c16..20fc8d50a039 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -1245,7 +1245,9 @@ u64 vmbus_next_request_id(struct vmbus_channel *channel, u64 rqst_addr)
 
 	/*
 	 * Cannot return an ID of 0, which is reserved for an unsolicited
-	 * message from Hyper-V.
+	 * message from Hyper-V; Hyper-V does not acknowledge (respond to)
+	 * VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED requests with ID of
+	 * 0 sent by the guest.
 	 */
 	return current_id + 1;
 }
@@ -1270,7 +1272,7 @@ u64 vmbus_request_addr(struct vmbus_channel *channel, u64 trans_id)
 
 	/* Hyper-V can send an unsolicited message with ID of 0 */
 	if (!trans_id)
-		return trans_id;
+		return VMBUS_RQST_ERROR;
 
 	spin_lock_irqsave(&rqstor->req_lock, flags);
 
-- 
2.35.1




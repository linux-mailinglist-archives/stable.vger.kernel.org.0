Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 484A25419A9
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353531AbiFGVXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377404AbiFGVWc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:22:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB82F224D1C;
        Tue,  7 Jun 2022 12:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36A97612F2;
        Tue,  7 Jun 2022 19:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D10DC385A2;
        Tue,  7 Jun 2022 19:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628415;
        bh=BHm42J4EtXHmLewcSfTYir17/pQm9FwwdRgBDhV7gME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zc3xGvfaNp138jS0Nm5yEWfNbHATesp8u1f6LzpPaPcdEiUQY4w9cBUuZWDlRqpkT
         N9K+mAiGDEUsDECAGD2pHf7lI5ljgtLBzsAV6OELvxdmYSy4OwypsT33abHfjYLlN0
         TdEctNqTyP8A5BkWD8E3A300C/NwlOYQEAUXFnho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 320/879] drbd: fix duplicate array initializer
Date:   Tue,  7 Jun 2022 18:57:18 +0200
Message-Id: <20220607165012.141756926@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 33cb0917bbe241dd17a2b87ead63514c1b7e5615 ]

There are two initializers for P_RETRY_WRITE:

drivers/block/drbd/drbd_main.c:3676:22: warning: initialized field overwritten [-Woverride-init]

Remove the first one since it was already ignored by the compiler
and reorder the list to match the enum definition. As P_ZEROES had
no entry, add that one instead.

Fixes: 036b17eaab93 ("drbd: Receiving part for the PROTOCOL_UPDATE packet")
Fixes: f31e583aa2c2 ("drbd: introduce P_ZEROES (REQ_OP_WRITE_ZEROES on the "wire")")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Link: https://lore.kernel.org/r/20220406190715.1938174-2-christoph.boehmwalder@linbit.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 7b501c8d5992..57b23e49ee91 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -3581,9 +3581,8 @@ const char *cmdname(enum drbd_packet cmd)
 	 * when we want to support more than
 	 * one PRO_VERSION */
 	static const char *cmdnames[] = {
+
 		[P_DATA]	        = "Data",
-		[P_WSAME]	        = "WriteSame",
-		[P_TRIM]	        = "Trim",
 		[P_DATA_REPLY]	        = "DataReply",
 		[P_RS_DATA_REPLY]	= "RSDataReply",
 		[P_BARRIER]	        = "Barrier",
@@ -3594,7 +3593,6 @@ const char *cmdname(enum drbd_packet cmd)
 		[P_DATA_REQUEST]	= "DataRequest",
 		[P_RS_DATA_REQUEST]     = "RSDataRequest",
 		[P_SYNC_PARAM]	        = "SyncParam",
-		[P_SYNC_PARAM89]	= "SyncParam89",
 		[P_PROTOCOL]            = "ReportProtocol",
 		[P_UUIDS]	        = "ReportUUIDs",
 		[P_SIZES]	        = "ReportSizes",
@@ -3602,6 +3600,7 @@ const char *cmdname(enum drbd_packet cmd)
 		[P_SYNC_UUID]           = "ReportSyncUUID",
 		[P_AUTH_CHALLENGE]      = "AuthChallenge",
 		[P_AUTH_RESPONSE]	= "AuthResponse",
+		[P_STATE_CHG_REQ]       = "StateChgRequest",
 		[P_PING]		= "Ping",
 		[P_PING_ACK]	        = "PingAck",
 		[P_RECV_ACK]	        = "RecvAck",
@@ -3612,23 +3611,25 @@ const char *cmdname(enum drbd_packet cmd)
 		[P_NEG_DREPLY]	        = "NegDReply",
 		[P_NEG_RS_DREPLY]	= "NegRSDReply",
 		[P_BARRIER_ACK]	        = "BarrierAck",
-		[P_STATE_CHG_REQ]       = "StateChgRequest",
 		[P_STATE_CHG_REPLY]     = "StateChgReply",
 		[P_OV_REQUEST]          = "OVRequest",
 		[P_OV_REPLY]            = "OVReply",
 		[P_OV_RESULT]           = "OVResult",
 		[P_CSUM_RS_REQUEST]     = "CsumRSRequest",
 		[P_RS_IS_IN_SYNC]	= "CsumRSIsInSync",
+		[P_SYNC_PARAM89]	= "SyncParam89",
 		[P_COMPRESSED_BITMAP]   = "CBitmap",
 		[P_DELAY_PROBE]         = "DelayProbe",
 		[P_OUT_OF_SYNC]		= "OutOfSync",
-		[P_RETRY_WRITE]		= "RetryWrite",
 		[P_RS_CANCEL]		= "RSCancel",
 		[P_CONN_ST_CHG_REQ]	= "conn_st_chg_req",
 		[P_CONN_ST_CHG_REPLY]	= "conn_st_chg_reply",
 		[P_PROTOCOL_UPDATE]	= "protocol_update",
+		[P_TRIM]	        = "Trim",
 		[P_RS_THIN_REQ]         = "rs_thin_req",
 		[P_RS_DEALLOCATED]      = "rs_deallocated",
+		[P_WSAME]	        = "WriteSame",
+		[P_ZEROES]		= "Zeroes",
 
 		/* enum drbd_packet, but not commands - obsoleted flags:
 		 *	P_MAY_IGNORE
-- 
2.35.1




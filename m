Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859B443A375
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237441AbhJYT7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:59:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235534AbhJYT43 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:56:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9FF761166;
        Mon, 25 Oct 2021 19:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191199;
        bh=PIGsyyUj0X0Ys2iVMV+q+1ixTRzBlSVMdvmBndpyHZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QvAvcyY6ghu/cttZS964Rd2ySmJAVMH5dxuQtpPwZS77ZDcp+EASdfkrVO6MYBeUs
         lT5+aTwml5tgC0QQlICyj7fdApB/2QtmH2raleBl/O1WweBOnLOnyff8AuAMXF2TKP
         Horin48N5cbVgTZzIufjDxn04vlAkTNH9+IPy5YY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 150/169] scsi: storvsc: Fix validation for unsolicited incoming packets
Date:   Mon, 25 Oct 2021 21:15:31 +0200
Message-Id: <20211025191036.554792295@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Parri (Microsoft) <parri.andrea@gmail.com>

[ Upstream commit 6fd13d699d24beaa28310848fe65fd898fbb9043 ]

The validation on the length of incoming packets performed in
storvsc_on_channel_callback() does not apply to unsolicited packets with ID
of 0 sent by Hyper-V.  Adjust the validation for such unsolicited packets.

Link: https://lore.kernel.org/r/20211007122828.469289-1-parri.andrea@gmail.com
Fixes: 91b1b640b834b2 ("scsi: storvsc: Validate length of incoming packet in storvsc_on_channel_callback()")
Reported-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/storvsc_drv.c | 32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 37506b3fe5a9..5fa1120a87f7 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1285,11 +1285,15 @@ static void storvsc_on_channel_callback(void *context)
 	foreach_vmbus_pkt(desc, channel) {
 		struct vstor_packet *packet = hv_pkt_data(desc);
 		struct storvsc_cmd_request *request = NULL;
+		u32 pktlen = hv_pkt_datalen(desc);
 		u64 rqst_id = desc->trans_id;
+		u32 minlen = rqst_id ? sizeof(struct vstor_packet) -
+			stor_device->vmscsi_size_delta : sizeof(enum vstor_packet_operation);
 
-		if (hv_pkt_datalen(desc) < sizeof(struct vstor_packet) -
-				stor_device->vmscsi_size_delta) {
-			dev_err(&device->device, "Invalid packet len\n");
+		if (pktlen < minlen) {
+			dev_err(&device->device,
+				"Invalid pkt: id=%llu, len=%u, minlen=%u\n",
+				rqst_id, pktlen, minlen);
 			continue;
 		}
 
@@ -1302,13 +1306,23 @@ static void storvsc_on_channel_callback(void *context)
 			if (rqst_id == 0) {
 				/*
 				 * storvsc_on_receive() looks at the vstor_packet in the message
-				 * from the ring buffer.  If the operation in the vstor_packet is
-				 * COMPLETE_IO, then we call storvsc_on_io_completion(), and
-				 * dereference the guest memory address.  Make sure we don't call
-				 * storvsc_on_io_completion() with a guest memory address that is
-				 * zero if Hyper-V were to construct and send such a bogus packet.
+				 * from the ring buffer.
+				 *
+				 * - If the operation in the vstor_packet is COMPLETE_IO, then
+				 *   we call storvsc_on_io_completion(), and dereference the
+				 *   guest memory address.  Make sure we don't call
+				 *   storvsc_on_io_completion() with a guest memory address
+				 *   that is zero if Hyper-V were to construct and send such
+				 *   a bogus packet.
+				 *
+				 * - If the operation in the vstor_packet is FCHBA_DATA, then
+				 *   we call cache_wwn(), and access the data payload area of
+				 *   the packet (wwn_packet); however, there is no guarantee
+				 *   that the packet is big enough to contain such area.
+				 *   Future-proof the code by rejecting such a bogus packet.
 				 */
-				if (packet->operation == VSTOR_OPERATION_COMPLETE_IO) {
+				if (packet->operation == VSTOR_OPERATION_COMPLETE_IO ||
+				    packet->operation == VSTOR_OPERATION_FCHBA_DATA) {
 					dev_err(&device->device, "Invalid packet with ID of 0\n");
 					continue;
 				}
-- 
2.33.0




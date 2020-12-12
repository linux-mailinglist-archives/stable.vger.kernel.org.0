Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEEAD2D87C2
	for <lists+stable@lfdr.de>; Sat, 12 Dec 2020 17:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439496AbgLLQLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Dec 2020 11:11:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:59616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405961AbgLLQK7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Dec 2020 11:10:59 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Saruhan Karademir <skarade@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, devel@linuxdriverproject.org
Subject: [PATCH AUTOSEL 4.14 6/8] scsi: storvsc: Validate length of incoming packet in storvsc_on_channel_callback()
Date:   Sat, 12 Dec 2020 11:08:57 -0500
Message-Id: <20201212160859.2335412-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201212160859.2335412-1-sashal@kernel.org>
References: <20201212160859.2335412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>

[ Upstream commit 3b8c72d076c42bf27284cda7b2b2b522810686f8 ]

Check that the packet is of the expected size at least, don't copy data
past the packet.

Link: https://lore.kernel.org/r/20201118145348.109879-1-parri.andrea@gmail.com
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Reported-by: Saruhan Karademir <skarade@microsoft.com>
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/storvsc_drv.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 5adeb1e4b1869..2e0d8566dedba 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1179,6 +1179,11 @@ static void storvsc_on_channel_callback(void *context)
 		request = (struct storvsc_cmd_request *)
 			((unsigned long)desc->trans_id);
 
+		if (hv_pkt_datalen(desc) < sizeof(struct vstor_packet) - vmscsi_size_delta) {
+			dev_err(&device->device, "Invalid packet len\n");
+			continue;
+		}
+
 		if (request == &stor_device->init_request ||
 		    request == &stor_device->reset_request) {
 			memcpy(&request->vstor_packet, packet,
-- 
2.27.0


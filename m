Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE11A4A9BAD
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 16:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343765AbiBDPLj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 4 Feb 2022 10:11:39 -0500
Received: from mail3.swissbit.com ([176.95.1.57]:58014 "EHLO
        mail3.swissbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241808AbiBDPLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 10:11:39 -0500
Received: from mail3.swissbit.com (localhost [127.0.0.1])
        by DDEI (Postfix) with ESMTP id D7736462F66;
        Fri,  4 Feb 2022 16:11:37 +0100 (CET)
Received: from mail3.swissbit.com (localhost [127.0.0.1])
        by DDEI (Postfix) with ESMTP id C579A4630E9;
        Fri,  4 Feb 2022 16:11:37 +0100 (CET)
X-TM-AS-ERS: 10.149.2.84-127.5.254.253
X-TM-AS-SMTP: 1.0 ZXguc3dpc3NiaXQuY29t Y2xvZWhsZUBoeXBlcnN0b25lLmNvbQ==
X-DDEI-TLS-USAGE: Used
Received: from ex.swissbit.com (SBDEEX02.sbitdom.lan [10.149.2.84])
        by mail3.swissbit.com (Postfix) with ESMTPS;
        Fri,  4 Feb 2022 16:11:37 +0100 (CET)
Received: from sbdeex02.sbitdom.lan (10.149.2.84) by sbdeex02.sbitdom.lan
 (10.149.2.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15; Fri, 4 Feb 2022
 16:11:37 +0100
Received: from sbdeex02.sbitdom.lan ([fe80::e0eb:ade8:2d90:1f74]) by
 sbdeex02.sbitdom.lan ([fe80::e0eb:ade8:2d90:1f74%8]) with mapi id
 15.02.0986.015; Fri, 4 Feb 2022 16:11:37 +0100
From:   =?iso-8859-1?Q?Christian_L=F6hle?= <CLoehle@hyperstone.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?iso-8859-1?Q?Christian_L=F6hle?= <CLoehle@hyperstone.com>
CC:     "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCHv2] mmc: block: fix read single on recovery logic
Thread-Topic: [PATCHv2] mmc: block: fix read single on recovery logic
Thread-Index: AQHYGdmBQ/DNxxUR20SkEIF4VXs96A==
Date:   Fri, 4 Feb 2022 15:11:37 +0000
Message-ID: <bc706a6ab08c4fe2834ba0c05a804672@hyperstone.com>
References: <5e5f2e45d0a14a55a8b7a9357846114b@hyperstone.com>
 <7c4757cc707740e580c61c39f963a04d@hyperstone.com>
 <CAPDyKFr0YXCwL-8F9M7mkpNzSQpzw6gNUq2zaiJEXj1jNxUbrg@mail.gmail.com>,<5c66833d-4b35-2c76-db54-0306e08843e5@intel.com>,<79d44b0c54e048b0a9cc86319a24cc19@hyperstone.com>
In-Reply-To: <79d44b0c54e048b0a9cc86319a24cc19@hyperstone.com>
Accept-Language: en-US, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.154.1.4]
Content-Type: text/plain;
        charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-TMASE-Version: DDEI-5.1-8.6.1018-26696.000
X-TMASE-Result: 10--2.390400-10.000000
X-TMASE-MatchedRID: dc8Jy61QoRp0/jNwxBmuZiyKzJY7d2nbunSyiaV8TbOUCwv1X+STMl2d
        sxCRbuoB8FHDcHdF1rYVKH14MhLRlzdhl84+mwvCqg0gbtLVIa9uchTq5J5u9LytS1u1Z7z6a3A
        6hcNu8nD0YXQzpNvE/P5nI8KIHQ65o1cymYpfRxUzL6MySEJ0VvmoZ6x4ZgCUoWOuhb6d7SFnby
        ATPFLi0gR6lC2CDNN4rbzO2egx+l0MJ0ZR1WrjDKiUivh0j2PvS1zwNuiBtITfUZT83lbkENP+k
        XNq5kuZmL9aborEAKJdllc1XXqB257OrwqWs6vOAZ0lncqeHqF9LQinZ4QefJxSu1RP8S9J+gtH
        j7OwNO35N/S1zEq4uk4IO6MzPeAE6ceTivttVg2RFE4mEW4/Q0mBbQ9Ebkn1
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0
X-TMASE-INERTIA: 0-0;;;;
X-TMASE-XGENCLOUD: 99fe5f0a-56ea-49b9-84f6-c550c9878366-0-0-200-0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On reads with MMC_READ_MULTIPLE_BLOCK that fail,
the recovery handler will use MMC_READ_SINGLE_BLOCK for
each of the blocks, up to MMC_READ_SINGLE_RETRIES times each.
The logic for this is fixed to never report unsuccessful reads
as success to the block layer.

On command error with retries remaining, blk_update_request was
called with whatever value error was set last to.
In case it was last set to BLK_STS_OK (default), the read will be
reported as success, even though there was no data read from the device.
This could happen on a CRC mismatch for the response,
a card rejecting the command (e.g. again due to a CRC mismatch).
In case it was last set to BLK_STS_IOERR, the error is reported correctly,
but no retries will be attempted.

Fixes: 81196976ed946c ("mmc: block: Add blk-mq support")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
---
v2:
  - Do not allow data error retries
  - Actually retry MMC_READ_SINGLE_RETRIES times instead of
  MMC_READ_SINGLE_RETRIES-1


 drivers/mmc/core/block.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 4e61b28a002f..8d718aa56d33 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1682,31 +1682,31 @@ static void mmc_blk_read_single(struct mmc_queue *mq, struct request *req)
 	struct mmc_card *card = mq->card;
 	struct mmc_host *host = card->host;
 	blk_status_t error = BLK_STS_OK;
-	int retries = 0;
 
 	do {
 		u32 status;
 		int err;
+		int retries = 0;
 
-		mmc_blk_rw_rq_prep(mqrq, card, 1, mq);
+		while (retries++ <= MMC_READ_SINGLE_RETRIES) {
+			mmc_blk_rw_rq_prep(mqrq, card, 1, mq);
 
-		mmc_wait_for_req(host, mrq);
+			mmc_wait_for_req(host, mrq);
 
-		err = mmc_send_status(card, &status);
-		if (err)
-			goto error_exit;
-
-		if (!mmc_host_is_spi(host) &&
-		    !mmc_ready_for_data(status)) {
-			err = mmc_blk_fix_state(card, req);
+			err = mmc_send_status(card, &status);
 			if (err)
 				goto error_exit;
-		}
 
-		if (mrq->cmd->error && retries++ < MMC_READ_SINGLE_RETRIES)
-			continue;
+			if (!mmc_host_is_spi(host) &&
+			    !mmc_ready_for_data(status)) {
+				err = mmc_blk_fix_state(card, req);
+				if (err)
+					goto error_exit;
+			}
 
-		retries = 0;
+			if (!mrq->cmd->error)
+				break;
+		}
 
 		if (mrq->cmd->error ||
 		    mrq->data->error ||
-- 
2.34.1
Hyperstone GmbH | Reichenaustr. 39a  | 78467 Konstanz
Managing Director: Dr. Jan Peter Berns.
Commercial register of local courts: Freiburg HRB381782


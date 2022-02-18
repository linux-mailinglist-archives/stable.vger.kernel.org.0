Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD674BB5F8
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 10:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbiBRJyZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 18 Feb 2022 04:54:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbiBRJyZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 04:54:25 -0500
X-Greylist: delayed 192 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 18 Feb 2022 01:54:08 PST
Received: from mail3.swissbit.com (mail3.swissbit.com [176.95.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480112944C1
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 01:54:08 -0800 (PST)
Received: from mail3.swissbit.com (localhost [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 0E0854630A4;
        Fri, 18 Feb 2022 10:50:55 +0100 (CET)
Received: from mail3.swissbit.com (localhost [127.0.0.1])
        by DDEI (Postfix) with ESMTP id F1F33463038;
        Fri, 18 Feb 2022 10:50:54 +0100 (CET)
X-TM-AS-ERS: 10.149.2.84-127.5.254.253
X-TM-AS-SMTP: 1.0 ZXguc3dpc3NiaXQuY29t Y2xvZWhsZUBoeXBlcnN0b25lLmNvbQ==
X-DDEI-TLS-USAGE: Used
Received: from ex.swissbit.com (SBDEEX02.sbitdom.lan [10.149.2.84])
        by mail3.swissbit.com (Postfix) with ESMTPS;
        Fri, 18 Feb 2022 10:50:54 +0100 (CET)
Received: from sbdeex02.sbitdom.lan (10.149.2.84) by sbdeex02.sbitdom.lan
 (10.149.2.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15; Fri, 18 Feb
 2022 10:50:54 +0100
Received: from sbdeex02.sbitdom.lan ([fe80::e0eb:ade8:2d90:1f74]) by
 sbdeex02.sbitdom.lan ([fe80::e0eb:ade8:2d90:1f74%8]) with mapi id
 15.02.0986.015; Fri, 18 Feb 2022 10:50:54 +0100
From:   =?iso-8859-1?Q?Christian_L=F6hle?= <CLoehle@hyperstone.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Ulf Hansson <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH] mmc: block: fix read single on recovery logic
Thread-Topic: [PATCH] mmc: block: fix read single on recovery logic
Thread-Index: AQHYJK0F7THTFUoG1UqyVjHZgEpMkA==
Date:   Fri, 18 Feb 2022 09:50:54 +0000
Message-ID: <abf69d264c7845bab8433ccae7ed0e0f@hyperstone.com>
References: <16451252511822@kroah.com>
In-Reply-To: <16451252511822@kroah.com>
Accept-Language: en-US, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.242.2.66]
Content-Type: text/plain;
        charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-TMASE-Version: DDEI-5.1-8.6.1018-26722.007
X-TMASE-Result: 10--3.985700-10.000000
X-TMASE-MatchedRID: F7tLedRt7idaLxCKnrw2Bw7LUBXy1QPwWQ3R4k5PTnD8gmFVD37LXS1+
        4nCRr2jQEFRfkXUcAJmEVqim8+5ZDWZ3IJrmJ3tquLt50vtxBA4YQYFQ2+HwYMOo7r/xHr1A5ax
        aw7fIL5H0xJ71CynX0ApG4pEjrtHg0ekSi+00U24ReM8i8p3vgEyQ5fRSh265MaLHVXr1Aoef6e
        u+NowNgWeTaX0eU+qSbNNGQAR79qhtncNI+1Yma54CIKY/Hg3AhGBk0/7pshLEQdG7H66TyH4gK
        q42LRYkvetcnSOp+4oAd6595ei/UqcMEtDnDK6Hh2WuVEOVQCV+3BndfXUhXQ==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0
X-TMASE-INERTIA: 0-0;;;;
X-TMASE-XGENCLOUD: 3f8d83a2-0409-461e-b53c-8cb6061dd7e8-0-0-200-0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 54309fde1a352ad2674ebba004a79f7d20b9f037 upstream.

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

Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
---
 drivers/mmc/core/block.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index d1cc0fdbc51c..630f3bcba56d 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1678,31 +1678,31 @@ static void mmc_blk_read_single(struct mmc_queue *mq, struct request *req)
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
-		    !mmc_blk_in_tran_state(status)) {
-			err = mmc_blk_fix_state(card, req);
+			err = mmc_send_status(card, &status);
 			if (err)
 				goto error_exit;
-		}
 
-		if (mrq->cmd->error && retries++ < MMC_READ_SINGLE_RETRIES)
-			continue;
+			if (!mmc_host_is_spi(host) &&
+			    !mmc_blk_in_tran_state(status)) {
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


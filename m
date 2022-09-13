Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E4D5B6F27
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbiIMOJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbiIMOIg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:08:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79EC95A819;
        Tue, 13 Sep 2022 07:08:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6A22B80EF7;
        Tue, 13 Sep 2022 14:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DEFC433C1;
        Tue, 13 Sep 2022 14:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078087;
        bh=wA3QKMVK2MMUXi/frUbvg9Tudgw6gRc8yx3rmO3BpeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ikllQDz7i6kh9SAbB9nr/Z/UW10zWm/9mBEHh+00Pr+jcX5zGSMLfzgHUNVK1ix5c
         es70qwYlhWsdpWYdODHrDXgJkaNrm0r9KtADKUEvF84QNTbzpMoA1wQe8omij3+lbP
         tWuNV80PTD/CxwsZueoORniExVSUF4cD6cEt5ojU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Wilck <mwilck@suse.com>,
        Krishna Kant <krishna.kant@purestorage.com>,
        Seamus Connor <sconnor@purestorage.com>,
        Brian Bunker <brian@purestorage.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 010/192] scsi: core: Allow the ALUA transitioning state enough time
Date:   Tue, 13 Sep 2022 16:01:56 +0200
Message-Id: <20220913140410.485565198@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Bunker <brian@purestorage.com>

[ Upstream commit 54249306e2776774ccb827969e62d34570f991db ]

The error path for the SCSI check condition of not ready, target in ALUA
state transition, will result in the failure of that path after the retries
are exhausted. In most cases that is well ahead of the transition timeout
established in the SCSI ALUA device handler.

Instead, reprep the command and re-add it to the queue after a 1 second
delay. This will allow the handler to take care of the timeout and only
fail the path if the target has exceeded the transition expiry timeout
(default 60 seconds). If the expiry timeout is exceeded, the handler will
change the path state from transitioning to standby leading to a path
failure eliminating the potential of this re-prep to continue endlessly. In
most cases the target will exit the transitioning state well before the
expiry timeout but after the retries are exhausted as mentioned.

Additionally remove the scsi_io_completion_reprep() function which provides
little value.

Link: https://lore.kernel.org/r/20220729214110.58576-1-brian@purestorage.com
Reviewed-by: Martin Wilck <mwilck@suse.com>
Acked-by: Krishna Kant <krishna.kant@purestorage.com>
Acked-by: Seamus Connor <sconnor@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_lib.c | 44 +++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 78edb1ea4748d..f5c876d03c1ad 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -118,7 +118,7 @@ scsi_set_blocked(struct scsi_cmnd *cmd, int reason)
 	}
 }
 
-static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd)
+static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd, unsigned long msecs)
 {
 	struct request *rq = scsi_cmd_to_rq(cmd);
 
@@ -128,7 +128,12 @@ static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd)
 	} else {
 		WARN_ON_ONCE(true);
 	}
-	blk_mq_requeue_request(rq, true);
+
+	if (msecs) {
+		blk_mq_requeue_request(rq, false);
+		blk_mq_delay_kick_requeue_list(rq->q, msecs);
+	} else
+		blk_mq_requeue_request(rq, true);
 }
 
 /**
@@ -658,14 +663,6 @@ static unsigned int scsi_rq_err_bytes(const struct request *rq)
 	return bytes;
 }
 
-/* Helper for scsi_io_completion() when "reprep" action required. */
-static void scsi_io_completion_reprep(struct scsi_cmnd *cmd,
-				      struct request_queue *q)
-{
-	/* A new command will be prepared and issued. */
-	scsi_mq_requeue_cmd(cmd);
-}
-
 static bool scsi_cmd_runtime_exceeced(struct scsi_cmnd *cmd)
 {
 	struct request *req = scsi_cmd_to_rq(cmd);
@@ -683,14 +680,21 @@ static bool scsi_cmd_runtime_exceeced(struct scsi_cmnd *cmd)
 	return false;
 }
 
+/*
+ * When ALUA transition state is returned, reprep the cmd to
+ * use the ALUA handler's transition timeout. Delay the reprep
+ * 1 sec to avoid aggressive retries of the target in that
+ * state.
+ */
+#define ALUA_TRANSITION_REPREP_DELAY	1000
+
 /* Helper for scsi_io_completion() when special action required. */
 static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 {
-	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = scsi_cmd_to_rq(cmd);
 	int level = 0;
-	enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
-	      ACTION_DELAYED_RETRY} action;
+	enum {ACTION_FAIL, ACTION_REPREP, ACTION_DELAYED_REPREP,
+	      ACTION_RETRY, ACTION_DELAYED_RETRY} action;
 	struct scsi_sense_hdr sshdr;
 	bool sense_valid;
 	bool sense_current = true;      /* false implies "deferred sense" */
@@ -779,8 +783,8 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 					action = ACTION_DELAYED_RETRY;
 					break;
 				case 0x0a: /* ALUA state transition */
-					blk_stat = BLK_STS_TRANSPORT;
-					fallthrough;
+					action = ACTION_DELAYED_REPREP;
+					break;
 				default:
 					action = ACTION_FAIL;
 					break;
@@ -839,7 +843,10 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 			return;
 		fallthrough;
 	case ACTION_REPREP:
-		scsi_io_completion_reprep(cmd, q);
+		scsi_mq_requeue_cmd(cmd, 0);
+		break;
+	case ACTION_DELAYED_REPREP:
+		scsi_mq_requeue_cmd(cmd, ALUA_TRANSITION_REPREP_DELAY);
 		break;
 	case ACTION_RETRY:
 		/* Retry the same command immediately */
@@ -933,7 +940,7 @@ static int scsi_io_completion_nz_result(struct scsi_cmnd *cmd, int result,
  * command block will be released and the queue function will be goosed. If we
  * are not done then we have to figure out what to do next:
  *
- *   a) We can call scsi_io_completion_reprep().  The request will be
+ *   a) We can call scsi_mq_requeue_cmd().  The request will be
  *	unprepared and put back on the queue.  Then a new command will
  *	be created for it.  This should be used if we made forward
  *	progress, or if we want to switch from READ(10) to READ(6) for
@@ -949,7 +956,6 @@ static int scsi_io_completion_nz_result(struct scsi_cmnd *cmd, int result,
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
-	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = scsi_cmd_to_rq(cmd);
 	blk_status_t blk_stat = BLK_STS_OK;
 
@@ -986,7 +992,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	 * request just queue the command up again.
 	 */
 	if (likely(result == 0))
-		scsi_io_completion_reprep(cmd, q);
+		scsi_mq_requeue_cmd(cmd, 0);
 	else
 		scsi_io_completion_action(cmd, result);
 }
-- 
2.35.1




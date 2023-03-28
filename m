Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4DA16CC2B0
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbjC1Orl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbjC1Ork (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:47:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F40DBF1
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:47:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC316B81D70
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC51C4339B;
        Tue, 28 Mar 2023 14:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014823;
        bh=ig+iACCvl6AVUvaSrovL2u2Qojn6fXNBaB+kjFB9A34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WtVUoDo52FO9lxc0qDmWXs+sVySREihT1oxpdfSOQhWhNkHhl5IfW4FIaHoR7Sifb
         Np6Vcj6/Py2qkyeoJV8Udue/aSmmmp6mzDLMukSo1ur8wnhCZDk7D4W+DpddcxHy9a
         8l4ieTxrKLDDsgDZM9HQQsiwa9qZgJjN8AycRydU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 035/240] igc: fix the validation logic for taprios gate list
Date:   Tue, 28 Mar 2023 16:39:58 +0200
Message-Id: <20230328142621.073359161@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AKASHI Takahiro <takahiro.akashi@linaro.org>

[ Upstream commit 2b4cc3d3f4d8ec42961e98568a0afeee96a943ab ]

The check introduced in the commit a5fd39464a40 ("igc: Lift TAPRIO schedule
restriction") can detect a false positive error in some corner case.
For instance,
    tc qdisc replace ... taprio num_tc 4
	...
	sched-entry S 0x01 100000	# slot#1
	sched-entry S 0x03 100000	# slot#2
	sched-entry S 0x04 100000	# slot#3
	sched-entry S 0x08 200000	# slot#4
	flags 0x02			# hardware offload

Here the queue#0 (the first queue) is on at the slot#1 and #2,
and off at the slot#3 and #4. Under the current logic, when the slot#4
is examined, validate_schedule() returns *false* since the enablement
count for the queue#0 is two and it is already off at the previous slot
(i.e. #3). But this definition is truely correct.

Let's fix the logic to enforce a strict validation for consecutively-opened
slots.

Fixes: a5fd39464a40 ("igc: Lift TAPRIO schedule restriction")
Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 1dd2a7fee8d46..bcd62b36fd7a7 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6007,18 +6007,18 @@ static bool validate_schedule(struct igc_adapter *adapter,
 		if (e->command != TC_TAPRIO_CMD_SET_GATES)
 			return false;
 
-		for (i = 0; i < adapter->num_tx_queues; i++) {
-			if (e->gate_mask & BIT(i))
+		for (i = 0; i < adapter->num_tx_queues; i++)
+			if (e->gate_mask & BIT(i)) {
 				queue_uses[i]++;
 
-			/* There are limitations: A single queue cannot be
-			 * opened and closed multiple times per cycle unless the
-			 * gate stays open. Check for it.
-			 */
-			if (queue_uses[i] > 1 &&
-			    !(prev->gate_mask & BIT(i)))
-				return false;
-		}
+				/* There are limitations: A single queue cannot
+				 * be opened and closed multiple times per cycle
+				 * unless the gate stays open. Check for it.
+				 */
+				if (queue_uses[i] > 1 &&
+				    !(prev->gate_mask & BIT(i)))
+					return false;
+			}
 	}
 
 	return true;
-- 
2.39.2




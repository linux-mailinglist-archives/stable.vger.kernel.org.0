Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1AF657967
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbiL1PBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:01:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233421AbiL1PAj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:00:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F87312612
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:00:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C081CB8171A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B46DC433F1;
        Wed, 28 Dec 2022 15:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239632;
        bh=SW1YK86OFjuZtv+mCVN6Br7+c68iJykY64MAzTM/VA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1LBV+Ps5t8zdsusvbFzjHOAPKaDiIahGg8bCxlClxz4ZtseeEdCVasCCmpaC7MDQL
         LQckLMUSkilYCD+E2ig3ko0sXPjI1Z1P31HM07/IcleMn5fWglx8EjYI1EE6gkm+uk
         vf+bo2t0OHDe5XRMqJf318v+swbTYdK8EXym+Lgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Georgi Vlaev <g-vlaev@ti.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0021/1146] firmware: ti_sci: Fix polled mode during system suspend
Date:   Wed, 28 Dec 2022 15:26:00 +0100
Message-Id: <20221228144330.746047830@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Georgi Vlaev <g-vlaev@ti.com>

[ Upstream commit b13b2c3e0e4d0854228b5217fa34e145f3ace8ac ]

Commit b9e8a7d950ff ("firmware: ti_sci: Switch transport to polled
mode during system suspend") uses read_poll_timeout_atomic() macro
in ti_sci_do_xfer() to wait for completion when the system is
suspending. The break condition of the macro is set to "true" which
will cause it break immediately when evaluated, likely before the
TISCI xfer is completed, and always return 0. We want to poll here
until "done_state == true".

1) Change the break condition of read_poll_timeout_atomic() to
the bool variable "done_state".

2) The read_poll_timeout_atomic() returns 0 if the break condition
is met or -ETIMEDOUT if not. Since our break condition has changed
to "done_state", we also don't have to check for "!done_state" when
evaluating the return value.

Fixes: b9e8a7d950ff ("firmware: ti_sci: Switch transport to polled mode during system suspend")

Signed-off-by: Georgi Vlaev <g-vlaev@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20221021185704.181316-1-g-vlaev@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/ti_sci.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/ti_sci.c b/drivers/firmware/ti_sci.c
index ebc32bbd9b83..6281e7153b47 100644
--- a/drivers/firmware/ti_sci.c
+++ b/drivers/firmware/ti_sci.c
@@ -429,15 +429,14 @@ static inline int ti_sci_do_xfer(struct ti_sci_info *info,
 		 * during noirq phase, so we must manually poll the completion.
 		 */
 		ret = read_poll_timeout_atomic(try_wait_for_completion, done_state,
-					       true, 1,
+					       done_state, 1,
 					       info->desc->max_rx_timeout_ms * 1000,
 					       false, &xfer->done);
 	}
 
-	if (ret == -ETIMEDOUT || !done_state) {
+	if (ret == -ETIMEDOUT)
 		dev_err(dev, "Mbox timedout in resp(caller: %pS)\n",
 			(void *)_RET_IP_);
-	}
 
 	/*
 	 * NOTE: we might prefer not to need the mailbox ticker to manage the
-- 
2.35.1




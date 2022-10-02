Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F41E5F2608
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 00:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiJBWt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 18:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiJBWt2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 18:49:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0048D22B02;
        Sun,  2 Oct 2022 15:49:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF929B8058E;
        Sun,  2 Oct 2022 22:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DB0C433C1;
        Sun,  2 Oct 2022 22:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664750965;
        bh=mf6CQxkQ4rgBoSgPh5/647RqhQi3+mUhudFOdshEm1g=;
        h=From:To:Cc:Subject:Date:From;
        b=kFeCWlZBS+HfRc/3KYY6Aj3Wchd1rq7d3BUbsn1btuuSP70bmlKqNIK64shwKEv1G
         TsJQAcBFbmS7OsPq5rF02SON/iNLyNrtTcwsytINOo3DqlfMUtMl6jwld9s7oR/AeH
         Oqs/3eIR2hdFzKDFUe/oe6lw5w3+AtmII6q6hlgJWCsQIkP04qIvEFokqdAVFOegEF
         //McgXgYY3FZJcd8zNtdVbcr9GtSigBocJbLJ85UAIXTwx3vJHg2k3JMCROWwl9PbK
         xki0SPoSVvaBqCVcpXpSFO517hWgOoypTw2UxqOnDn/vbXvKcrCu6PynXrAT7mz2uF
         g9mfFD/M7D+8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 01/29] firmware: arm_scmi: Improve checks in the info_get operations
Date:   Sun,  2 Oct 2022 18:48:54 -0400
Message-Id: <20221002224922.238837-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 1ecb7d27b1af6705e9a4e94415b4d8cc8cf2fbfb ]

SCMI protocols abstract and expose a number of protocol specific
resources like clocks, sensors and so on. Information about such
specific domain resources are generally exposed via an `info_get`
protocol operation.

Improve the sanity check on these operations where needed.

Link: https://lore.kernel.org/r/20220817172731.1185305-3-cristian.marussi@arm.com
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/clock.c   | 6 +++++-
 drivers/firmware/arm_scmi/sensors.c | 3 +++
 include/linux/scmi_protocol.h       | 4 ++--
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/arm_scmi/clock.c b/drivers/firmware/arm_scmi/clock.c
index 3ed7ae0d6781..96060bf90a24 100644
--- a/drivers/firmware/arm_scmi/clock.c
+++ b/drivers/firmware/arm_scmi/clock.c
@@ -450,9 +450,13 @@ static int scmi_clock_count_get(const struct scmi_protocol_handle *ph)
 static const struct scmi_clock_info *
 scmi_clock_info_get(const struct scmi_protocol_handle *ph, u32 clk_id)
 {
+	struct scmi_clock_info *clk;
 	struct clock_info *ci = ph->get_priv(ph);
-	struct scmi_clock_info *clk = ci->clk + clk_id;
 
+	if (clk_id >= ci->num_clocks)
+		return NULL;
+
+	clk = ci->clk + clk_id;
 	if (!clk->name[0])
 		return NULL;
 
diff --git a/drivers/firmware/arm_scmi/sensors.c b/drivers/firmware/arm_scmi/sensors.c
index 7288c6117838..7d0c7476d206 100644
--- a/drivers/firmware/arm_scmi/sensors.c
+++ b/drivers/firmware/arm_scmi/sensors.c
@@ -948,6 +948,9 @@ scmi_sensor_info_get(const struct scmi_protocol_handle *ph, u32 sensor_id)
 {
 	struct sensors_info *si = ph->get_priv(ph);
 
+	if (sensor_id >= si->num_sensors)
+		return NULL;
+
 	return si->sensors + sensor_id;
 }
 
diff --git a/include/linux/scmi_protocol.h b/include/linux/scmi_protocol.h
index 704111f63993..6dd50ac82d10 100644
--- a/include/linux/scmi_protocol.h
+++ b/include/linux/scmi_protocol.h
@@ -78,7 +78,7 @@ struct scmi_protocol_handle;
 struct scmi_clk_proto_ops {
 	int (*count_get)(const struct scmi_protocol_handle *ph);
 
-	const struct scmi_clock_info *(*info_get)
+	const struct scmi_clock_info __must_check *(*info_get)
 		(const struct scmi_protocol_handle *ph, u32 clk_id);
 	int (*rate_get)(const struct scmi_protocol_handle *ph, u32 clk_id,
 			u64 *rate);
@@ -460,7 +460,7 @@ enum scmi_sensor_class {
  */
 struct scmi_sensor_proto_ops {
 	int (*count_get)(const struct scmi_protocol_handle *ph);
-	const struct scmi_sensor_info *(*info_get)
+	const struct scmi_sensor_info __must_check *(*info_get)
 		(const struct scmi_protocol_handle *ph, u32 sensor_id);
 	int (*trip_point_config)(const struct scmi_protocol_handle *ph,
 				 u32 sensor_id, u8 trip_id, u64 trip_value);
-- 
2.35.1


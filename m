Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2515F2672
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 00:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiJBWxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 18:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiJBWxD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 18:53:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7B93CBDF;
        Sun,  2 Oct 2022 15:51:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 520DE60EDA;
        Sun,  2 Oct 2022 22:51:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B049C433D6;
        Sun,  2 Oct 2022 22:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751062;
        bh=0452Ih+dYMop1HKkBlAPiOxWLga9SLTq7ov9aO4GTnQ=;
        h=From:To:Cc:Subject:Date:From;
        b=jMfzcsd9e6/Hk7v6PGA+BIAhe48gSod6+x5l5oqJ6HbSKN1TYwfBfZvZ+EqZalBOu
         hfbSnlv17YL1vNYq1zxWnkQNoob7xkOFWM+u8ycN+iPU/FVVSTSfNGm8pHSe49OH/i
         rvaNweVC/TiAgzO7LIZgh4k1QIMoHly7aoZG6wddVTI/EoV6EFqB+6aYY54VlvhrxH
         NlWCK7NMApafDun0Fz33jGRjRT/SHBZtpbnr39mRBMPuzJwT4sUxOM5yQmQb2wdK6o
         HVEIS/AgAFZNyGeitpuPThDItsjKYU/GDlirEJFKj+FRAh3kzgk5k87vNTxJK84bmg
         YaR11GtL7dpNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 01/20] firmware: arm_scmi: Improve checks in the info_get operations
Date:   Sun,  2 Oct 2022 18:50:40 -0400
Message-Id: <20221002225100.239217-1-sashal@kernel.org>
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
index 492f3a9197ec..e76194a60edf 100644
--- a/drivers/firmware/arm_scmi/clock.c
+++ b/drivers/firmware/arm_scmi/clock.c
@@ -315,9 +315,13 @@ static int scmi_clock_count_get(const struct scmi_protocol_handle *ph)
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
index cdbb287bd8bc..b479a9e29c96 100644
--- a/drivers/firmware/arm_scmi/sensors.c
+++ b/drivers/firmware/arm_scmi/sensors.c
@@ -817,6 +817,9 @@ scmi_sensor_info_get(const struct scmi_protocol_handle *ph, u32 sensor_id)
 {
 	struct sensors_info *si = ph->get_priv(ph);
 
+	if (sensor_id >= si->num_sensors)
+		return NULL;
+
 	return si->sensors + sensor_id;
 }
 
diff --git a/include/linux/scmi_protocol.h b/include/linux/scmi_protocol.h
index 80e781c51ddc..d22f62203ee3 100644
--- a/include/linux/scmi_protocol.h
+++ b/include/linux/scmi_protocol.h
@@ -74,7 +74,7 @@ struct scmi_protocol_handle;
 struct scmi_clk_proto_ops {
 	int (*count_get)(const struct scmi_protocol_handle *ph);
 
-	const struct scmi_clock_info *(*info_get)
+	const struct scmi_clock_info __must_check *(*info_get)
 		(const struct scmi_protocol_handle *ph, u32 clk_id);
 	int (*rate_get)(const struct scmi_protocol_handle *ph, u32 clk_id,
 			u64 *rate);
@@ -452,7 +452,7 @@ enum scmi_sensor_class {
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


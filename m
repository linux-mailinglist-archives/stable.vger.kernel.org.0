Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2A65F9957
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbiJJHLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbiJJHKW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:10:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180A35C9DA;
        Mon, 10 Oct 2022 00:06:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FE6A60E84;
        Mon, 10 Oct 2022 07:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B68C433C1;
        Mon, 10 Oct 2022 07:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385589;
        bh=mf6CQxkQ4rgBoSgPh5/647RqhQi3+mUhudFOdshEm1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nfnpXiAyfkJueFuCkhBNBViv4bqEUa3t/2YaQXa/RiZBqRKk4GVvgAF8NwLAlcpHr
         mUfI4fQQ6TcoC56Bj1fKmKKLDkZ1ogq0QxoHT0lA6k3rJ/9dWYQLHVaaHX5+yWeWyd
         brZ7g58ASjsw8Spaz5SZtz5PEO3VesqgYYREJwag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 09/48] firmware: arm_scmi: Improve checks in the info_get operations
Date:   Mon, 10 Oct 2022 09:05:07 +0200
Message-Id: <20221010070333.947553398@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070333.676316214@linuxfoundation.org>
References: <20221010070333.676316214@linuxfoundation.org>
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




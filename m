Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D3B5F2607
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 00:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiJBWt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 18:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiJBWt2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 18:49:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9857512ABE;
        Sun,  2 Oct 2022 15:49:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 286F860EFE;
        Sun,  2 Oct 2022 22:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6425C433B5;
        Sun,  2 Oct 2022 22:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664750966;
        bh=Y2fNWVU4u1YcgAEFzh7WPVooORDKbcUr/iS2UcbjxWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BmVECohvnPKX1Mqene07XaHpqWwQiSbUOILoN2jXBVOwRti1rXTBlmon/WsJoluJU
         MGD9ryW62rlgOJtbTYHTMQD/0kAMyMh4aB/H7UNIFV7TvMQwHwnLYpTiBJPXgNgqRi
         lWnzuNOubUgGlWVTRx7WMitu/8JBVC+Mhgans6az9MhU32GIUbJn0yBs4lh94tnZu5
         7TxQGYo5CAqZHG9vbzFAB2DvXmKa0cF0aydAgkozDksRiIOWl83yUZr4CZb5//2VvT
         Sc1Df7jY3gi/I9m/UjSnuOlRH5PGHRy+iNi9wapXVVG9sa9Utkkk0MEdR8Mr2Y+pt3
         t3uHkKTyYvsIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 02/29] firmware: arm_scmi: Harden accesses to the sensor domains
Date:   Sun,  2 Oct 2022 18:48:55 -0400
Message-Id: <20221002224922.238837-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002224922.238837-1-sashal@kernel.org>
References: <20221002224922.238837-1-sashal@kernel.org>
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

[ Upstream commit 76f89c954788763db575fb512a40bd483864f1e9 ]

Accessing sensor domains descriptors by the index upon the SCMI drivers
requests through the SCMI sensor operations interface can potentially
lead to out-of-bound violations if the SCMI driver misbehave.

Add an internal consistency check before any such domains descriptors
accesses.

Link: https://lore.kernel.org/r/20220817172731.1185305-4-cristian.marussi@arm.com
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/sensors.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/arm_scmi/sensors.c b/drivers/firmware/arm_scmi/sensors.c
index 7d0c7476d206..0b5853fa9d87 100644
--- a/drivers/firmware/arm_scmi/sensors.c
+++ b/drivers/firmware/arm_scmi/sensors.c
@@ -762,6 +762,10 @@ static int scmi_sensor_config_get(const struct scmi_protocol_handle *ph,
 {
 	int ret;
 	struct scmi_xfer *t;
+	struct sensors_info *si = ph->get_priv(ph);
+
+	if (sensor_id >= si->num_sensors)
+		return -EINVAL;
 
 	ret = ph->xops->xfer_get_init(ph, SENSOR_CONFIG_GET,
 				      sizeof(__le32), sizeof(__le32), &t);
@@ -771,7 +775,6 @@ static int scmi_sensor_config_get(const struct scmi_protocol_handle *ph,
 	put_unaligned_le32(sensor_id, t->tx.buf);
 	ret = ph->xops->do_xfer(ph, t);
 	if (!ret) {
-		struct sensors_info *si = ph->get_priv(ph);
 		struct scmi_sensor_info *s = si->sensors + sensor_id;
 
 		*sensor_config = get_unaligned_le64(t->rx.buf);
@@ -788,6 +791,10 @@ static int scmi_sensor_config_set(const struct scmi_protocol_handle *ph,
 	int ret;
 	struct scmi_xfer *t;
 	struct scmi_msg_sensor_config_set *msg;
+	struct sensors_info *si = ph->get_priv(ph);
+
+	if (sensor_id >= si->num_sensors)
+		return -EINVAL;
 
 	ret = ph->xops->xfer_get_init(ph, SENSOR_CONFIG_SET,
 				      sizeof(*msg), 0, &t);
@@ -800,7 +807,6 @@ static int scmi_sensor_config_set(const struct scmi_protocol_handle *ph,
 
 	ret = ph->xops->do_xfer(ph, t);
 	if (!ret) {
-		struct sensors_info *si = ph->get_priv(ph);
 		struct scmi_sensor_info *s = si->sensors + sensor_id;
 
 		s->sensor_config = sensor_config;
@@ -831,8 +837,11 @@ static int scmi_sensor_reading_get(const struct scmi_protocol_handle *ph,
 	int ret;
 	struct scmi_xfer *t;
 	struct scmi_msg_sensor_reading_get *sensor;
+	struct scmi_sensor_info *s;
 	struct sensors_info *si = ph->get_priv(ph);
-	struct scmi_sensor_info *s = si->sensors + sensor_id;
+
+	if (sensor_id >= si->num_sensors)
+		return -EINVAL;
 
 	ret = ph->xops->xfer_get_init(ph, SENSOR_READING_GET,
 				      sizeof(*sensor), 0, &t);
@@ -841,6 +850,7 @@ static int scmi_sensor_reading_get(const struct scmi_protocol_handle *ph,
 
 	sensor = t->tx.buf;
 	sensor->id = cpu_to_le32(sensor_id);
+	s = si->sensors + sensor_id;
 	if (s->async) {
 		sensor->flags = cpu_to_le32(SENSOR_READ_ASYNC);
 		ret = ph->xops->do_xfer_with_response(ph, t);
@@ -895,9 +905,13 @@ scmi_sensor_reading_get_timestamped(const struct scmi_protocol_handle *ph,
 	int ret;
 	struct scmi_xfer *t;
 	struct scmi_msg_sensor_reading_get *sensor;
+	struct scmi_sensor_info *s;
 	struct sensors_info *si = ph->get_priv(ph);
-	struct scmi_sensor_info *s = si->sensors + sensor_id;
 
+	if (sensor_id >= si->num_sensors)
+		return -EINVAL;
+
+	s = si->sensors + sensor_id;
 	if (!count || !readings ||
 	    (!s->num_axis && count > 1) || (s->num_axis && count > s->num_axis))
 		return -EINVAL;
-- 
2.35.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905FF5F991A
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbiJJHHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbiJJHHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:07:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A76A58DF3;
        Mon, 10 Oct 2022 00:05:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A15E60E33;
        Mon, 10 Oct 2022 07:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6456EC433D6;
        Mon, 10 Oct 2022 07:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385524;
        bh=Y2fNWVU4u1YcgAEFzh7WPVooORDKbcUr/iS2UcbjxWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FYMw4IfU7zBBlQTN20PeqKYlWRnBGjGL+E2KxeduVinlEkX/+xqE0AlyJ+UChi16d
         363ZCNXIpL8iLpAOk+QKTiDx4wJhTWZU3+DlxDcmvHF46bSG9aiAhmg7eMVU7XzCwx
         Qd2cTtcO6cn7m4IbNcQDgjxFe7xsPFDjL/Ujk+s8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 10/48] firmware: arm_scmi: Harden accesses to the sensor domains
Date:   Mon, 10 Oct 2022 09:05:08 +0200
Message-Id: <20221010070333.973389550@linuxfoundation.org>
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




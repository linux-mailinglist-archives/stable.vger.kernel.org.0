Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4D75F996E
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbiJJHMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbiJJHLX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:11:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE95A5E65B;
        Mon, 10 Oct 2022 00:07:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 978A2B80E61;
        Mon, 10 Oct 2022 07:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00AAC433C1;
        Mon, 10 Oct 2022 07:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385652;
        bh=Rn3Y7qyfne6XgeYpbkCUNoInyYRAAlw9Fj2WspqhhaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NrhzXTEjInR9r07E351xn3bzi52/dleQaB50LcqKahzZ4oNQ11nxtS3kn9p7ltlk+
         oQSnEf1FUl6BrwYJRK7v3TsQOsmYwCs+bCeoXUhLKlS0f3ea+0YEY4Bc0JCbiPl7af
         dB6WHxJdDMyL/CezYBsYnWZlVIaV10fm4X+3pMHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 10/37] firmware: arm_scmi: Harden accesses to the sensor domains
Date:   Mon, 10 Oct 2022 09:05:29 +0200
Message-Id: <20221010070331.554869212@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070331.211113813@linuxfoundation.org>
References: <20221010070331.211113813@linuxfoundation.org>
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
index b479a9e29c96..1ed66d13c06c 100644
--- a/drivers/firmware/arm_scmi/sensors.c
+++ b/drivers/firmware/arm_scmi/sensors.c
@@ -631,6 +631,10 @@ static int scmi_sensor_config_get(const struct scmi_protocol_handle *ph,
 {
 	int ret;
 	struct scmi_xfer *t;
+	struct sensors_info *si = ph->get_priv(ph);
+
+	if (sensor_id >= si->num_sensors)
+		return -EINVAL;
 
 	ret = ph->xops->xfer_get_init(ph, SENSOR_CONFIG_GET,
 				      sizeof(__le32), sizeof(__le32), &t);
@@ -640,7 +644,6 @@ static int scmi_sensor_config_get(const struct scmi_protocol_handle *ph,
 	put_unaligned_le32(sensor_id, t->tx.buf);
 	ret = ph->xops->do_xfer(ph, t);
 	if (!ret) {
-		struct sensors_info *si = ph->get_priv(ph);
 		struct scmi_sensor_info *s = si->sensors + sensor_id;
 
 		*sensor_config = get_unaligned_le64(t->rx.buf);
@@ -657,6 +660,10 @@ static int scmi_sensor_config_set(const struct scmi_protocol_handle *ph,
 	int ret;
 	struct scmi_xfer *t;
 	struct scmi_msg_sensor_config_set *msg;
+	struct sensors_info *si = ph->get_priv(ph);
+
+	if (sensor_id >= si->num_sensors)
+		return -EINVAL;
 
 	ret = ph->xops->xfer_get_init(ph, SENSOR_CONFIG_SET,
 				      sizeof(*msg), 0, &t);
@@ -669,7 +676,6 @@ static int scmi_sensor_config_set(const struct scmi_protocol_handle *ph,
 
 	ret = ph->xops->do_xfer(ph, t);
 	if (!ret) {
-		struct sensors_info *si = ph->get_priv(ph);
 		struct scmi_sensor_info *s = si->sensors + sensor_id;
 
 		s->sensor_config = sensor_config;
@@ -700,8 +706,11 @@ static int scmi_sensor_reading_get(const struct scmi_protocol_handle *ph,
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
@@ -710,6 +719,7 @@ static int scmi_sensor_reading_get(const struct scmi_protocol_handle *ph,
 
 	sensor = t->tx.buf;
 	sensor->id = cpu_to_le32(sensor_id);
+	s = si->sensors + sensor_id;
 	if (s->async) {
 		sensor->flags = cpu_to_le32(SENSOR_READ_ASYNC);
 		ret = ph->xops->do_xfer_with_response(ph, t);
@@ -764,9 +774,13 @@ scmi_sensor_reading_get_timestamped(const struct scmi_protocol_handle *ph,
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




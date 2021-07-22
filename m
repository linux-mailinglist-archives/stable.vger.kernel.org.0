Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA31E3D2A47
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbhGVQKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:10:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235508AbhGVQJZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:09:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 979806052B;
        Thu, 22 Jul 2021 16:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972566;
        bh=e78d44QnUam4NLDY8FnNFh5NaRTvVLkssqfhpf8E44s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u0GNvn0kg07I4X/IFytuEQzEjyPR+981AXeiqfZ5eTq646Nvrf/8nkb/MTGia83rJ
         Ps9k46nODqhHpfH+3zmfw4An5DtcSay6C0ykh3BTFFdQ5vDsY5nj8CuOLrw3HHos4J
         docONCtW8X9TNuM/87fqClrcVNW/aLwU0mbI5FbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 5.13 153/156] firmware: arm_scmi: Avoid padding in sensor message structure
Date:   Thu, 22 Jul 2021 18:32:08 +0200
Message-Id: <20210722155633.303771342@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Marussi <cristian.marussi@arm.com>

commit 187a002b07e8089f0b5657eafec50b5d05625569 upstream.

scmi_resp_sensor_reading_complete structure is meant to represent an
SCMI asynchronous reading complete message. The readings field with
a 64bit type forces padding and breaks reads in scmi_sensor_reading_get.

Split it in two adjacent 32bit readings_low/high subfields to avoid the
padding within the structure. Alternatively we could to mark the structure
packed.

Link: https://lore.kernel.org/r/20210628170042.34105-1-cristian.marussi@arm.com
Fixes: e2083d3673916 ("firmware: arm_scmi: Add SCMI v3.0 sensors timestamped reads")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/arm_scmi/sensors.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/firmware/arm_scmi/sensors.c
+++ b/drivers/firmware/arm_scmi/sensors.c
@@ -166,7 +166,8 @@ struct scmi_msg_sensor_reading_get {
 
 struct scmi_resp_sensor_reading_complete {
 	__le32 id;
-	__le64 readings;
+	__le32 readings_low;
+	__le32 readings_high;
 };
 
 struct scmi_sensor_reading_resp {
@@ -717,7 +718,8 @@ static int scmi_sensor_reading_get(const
 
 			resp = t->rx.buf;
 			if (le32_to_cpu(resp->id) == sensor_id)
-				*value = get_unaligned_le64(&resp->readings);
+				*value =
+					get_unaligned_le64(&resp->readings_low);
 			else
 				ret = -EPROTO;
 		}



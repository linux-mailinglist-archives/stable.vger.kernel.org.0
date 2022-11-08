Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEC66215B9
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235192AbiKHOOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235324AbiKHOO1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:14:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0015F853
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:14:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CDA9B81B05
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6C4C433C1;
        Tue,  8 Nov 2022 14:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916863;
        bh=SlprzijVNl1h/pyB6kGxkRY3JwmR6bLZjbHl4XT14lQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZuSTGzgwlEHm0KRYvZNlSiAssXktMJoyOIwd5wkCOAIDx6gCV2PMHXa/6BEw6Wy2Q
         N4xv82L8AabY9x9i69/Sy3lsMlUj8VRQjutkEQ+H/UjRrHivWVv97b8wAg8gOHy5kL
         0KNJjzgHQuNTM7EwFrawuBLEhOp6pm3GgtM9YjTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Peter Hilber <peter.hilber@opensynergy.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 118/197] firmware: arm_scmi: Fix devres allocation device in virtio transport
Date:   Tue,  8 Nov 2022 14:39:16 +0100
Message-Id: <20221108133400.342771613@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

[ Upstream commit 5ffc1c4cb896f8d2cf10309422da3633a616d60f ]

SCMI virtio transport device managed allocations must use the main
platform device in devres operations instead of the channel devices.

Cc: Peter Hilber <peter.hilber@opensynergy.com>
Fixes: 46abe13b5e3d ("firmware: arm_scmi: Add virtio transport")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20221028140833.280091-5-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/virtio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/arm_scmi/virtio.c b/drivers/firmware/arm_scmi/virtio.c
index 14709dbc96a1..36b7686843a4 100644
--- a/drivers/firmware/arm_scmi/virtio.c
+++ b/drivers/firmware/arm_scmi/virtio.c
@@ -444,12 +444,12 @@ static int virtio_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
 	for (i = 0; i < vioch->max_msg; i++) {
 		struct scmi_vio_msg *msg;
 
-		msg = devm_kzalloc(cinfo->dev, sizeof(*msg), GFP_KERNEL);
+		msg = devm_kzalloc(dev, sizeof(*msg), GFP_KERNEL);
 		if (!msg)
 			return -ENOMEM;
 
 		if (tx) {
-			msg->request = devm_kzalloc(cinfo->dev,
+			msg->request = devm_kzalloc(dev,
 						    VIRTIO_SCMI_MAX_PDU_SIZE,
 						    GFP_KERNEL);
 			if (!msg->request)
@@ -458,7 +458,7 @@ static int virtio_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
 			refcount_set(&msg->users, 1);
 		}
 
-		msg->input = devm_kzalloc(cinfo->dev, VIRTIO_SCMI_MAX_PDU_SIZE,
+		msg->input = devm_kzalloc(dev, VIRTIO_SCMI_MAX_PDU_SIZE,
 					  GFP_KERNEL);
 		if (!msg->input)
 			return -ENOMEM;
-- 
2.35.1




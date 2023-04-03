Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580D96D47BF
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbjDCOXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbjDCOXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:23:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E9A2CAFF
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:22:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB89361705
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC142C433D2;
        Mon,  3 Apr 2023 14:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531764;
        bh=7MwOPIwCOWhEf739GR0HghGHVyH0l7FR0tvy9Yx/Bvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=osk/UUzvXNkddIKs8cK7hn5J9fA2fPtp25ubFY7UVARty/0j1gNOo9kDLGChrtuu1
         ODB9teyfLw7ufMupx4a5OyWuR3VFEP0HAXW0rB5V9cbH2eviw76t5C+XZ29623Uzeo
         gP+nHfJcsSvCXvQV9z12jTY5bMdu43Z2+WgEjYhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 5.4 103/104] firmware: arm_scmi: Fix device node validation for mailbox transport
Date:   Mon,  3 Apr 2023 16:09:35 +0200
Message-Id: <20230403140408.201075747@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
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

From: Cristian Marussi <cristian.marussi@arm.com>

commit 2ab4f4018cb6b8010ca5002c3bdc37783b5d28c2 upstream.

When mailboxes are used as a transport it is possible to setup the SCMI
transport layer, depending on the underlying channels configuration, to use
one or two mailboxes, associated, respectively, to one or two, distinct,
shared memory areas: any other combination should be treated as invalid.

Add more strict checking of SCMI mailbox transport device node descriptors.

Fixes: 5c8a47a5a91d ("firmware: arm_scmi: Make scmi core independent of the transport type")
Cc: <stable@vger.kernel.org> # 4.19
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20230307162324.891866-1-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
[Cristian: backported to v5.4]
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/arm_scmi/driver.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -737,6 +737,39 @@ static int scmi_mailbox_check(struct dev
 					  idx, NULL);
 }
 
+static int scmi_mailbox_chan_validate(struct device *cdev)
+{
+	int num_mb, num_sh, ret = 0;
+	struct device_node *np = cdev->of_node;
+
+	num_mb = of_count_phandle_with_args(np, "mboxes", "#mbox-cells");
+	num_sh = of_count_phandle_with_args(np, "shmem", NULL);
+	/* Bail out if mboxes and shmem descriptors are inconsistent */
+	if (num_mb <= 0 || num_sh > 2 || num_mb != num_sh) {
+		dev_warn(cdev, "Invalid channel descriptor for '%s'\n",
+			 of_node_full_name(np));
+		return -EINVAL;
+	}
+
+	if (num_sh > 1) {
+		struct device_node *np_tx, *np_rx;
+
+		np_tx = of_parse_phandle(np, "shmem", 0);
+		np_rx = of_parse_phandle(np, "shmem", 1);
+		/* SCMI Tx and Rx shared mem areas have to be distinct */
+		if (!np_tx || !np_rx || np_tx == np_rx) {
+			dev_warn(cdev, "Invalid shmem descriptor for '%s'\n",
+				 of_node_full_name(np));
+			ret = -EINVAL;
+		}
+
+		of_node_put(np_tx);
+		of_node_put(np_rx);
+	}
+
+	return ret;
+}
+
 static int scmi_mbox_chan_setup(struct scmi_info *info, struct device *dev,
 				int prot_id, bool tx)
 {
@@ -760,6 +793,10 @@ static int scmi_mbox_chan_setup(struct s
 		goto idr_alloc;
 	}
 
+	ret = scmi_mailbox_chan_validate(dev);
+	if (ret)
+		return ret;
+
 	cinfo = devm_kzalloc(info->dev, sizeof(*cinfo), GFP_KERNEL);
 	if (!cinfo)
 		return -ENOMEM;



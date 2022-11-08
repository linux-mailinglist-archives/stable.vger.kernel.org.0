Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6EA621583
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235220AbiKHOMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235182AbiKHOMk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:12:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81AF8C8A14
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:12:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BB7AB81AF7
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F21BC433C1;
        Tue,  8 Nov 2022 14:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916739;
        bh=5z2Vp29ni1obbjA2WMDLQfFtsHYt6OGBrCA2pUSFwLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N9reCndu5LqoJ4kExLVyclFUyJlG5C8tHBnvHIPT9miyAE1L0AJYn60WhYsiUj2q9
         RMVOykDWaZloxlUCsvboY38KUb1PqFyi7Vbl5VybFZiDq0t48rbU7JvZ/GvBZGjvVf
         yetFA5ATCS49p0TtVUwadLY/G3LOrI0IjvwNULlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 117/197] firmware: arm_scmi: Make Rx chan_setup fail on memory errors
Date:   Tue,  8 Nov 2022 14:39:15 +0100
Message-Id: <20221108133400.292094049@linuxfoundation.org>
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

[ Upstream commit be9ba1f7f9e0b565b19f4294f5871da9d654bc6d ]

SCMI Rx channels are optional and they can fail to be setup when not
present but anyway channels setup routines must bail-out on memory errors.

Make channels setup, and related probing, fail when memory errors are
reported on Rx channels.

Fixes: 5c8a47a5a91d ("firmware: arm_scmi: Make scmi core independent of the transport type")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20221028140833.280091-4-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 1b9aa34b8e47..9022f5ee29aa 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2044,8 +2044,12 @@ scmi_txrx_setup(struct scmi_info *info, struct device *dev, int prot_id)
 {
 	int ret = scmi_chan_setup(info, dev, prot_id, true);
 
-	if (!ret) /* Rx is optional, hence no error check */
-		scmi_chan_setup(info, dev, prot_id, false);
+	if (!ret) {
+		/* Rx is optional, report only memory errors */
+		ret = scmi_chan_setup(info, dev, prot_id, false);
+		if (ret && ret != -ENOMEM)
+			ret = 0;
+	}
 
 	return ret;
 }
-- 
2.35.1




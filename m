Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6859960401C
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234018AbiJSJmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234440AbiJSJk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:40:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C30AEF5B5;
        Wed, 19 Oct 2022 02:16:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31B2061802;
        Wed, 19 Oct 2022 09:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46213C433C1;
        Wed, 19 Oct 2022 09:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170921;
        bh=pZTA8+b6t89yvqWaduEatUoC/Fpvy1u8fwa7q8EqwVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JqcRCss7xi4u/Rzls9U8ey4doJ89DvP7IbQxoN4e6o88gMcbsd2HXykW2veO2Zbdm
         ah3YI0f3W7AXREnd+v3yQNlzewDqmTC0qy0og93eJZ9KNTuYBpUnnVieoEr91f3Lw+
         SbHifRXOorWoFBEYjQw7Tv9u2fr4vaw/7L6cywKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wayne Chang <waynec@nvidia.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 837/862] usb: typec: ucsi: Dont warn on probe deferral
Date:   Wed, 19 Oct 2022 10:35:24 +0200
Message-Id: <20221019083326.876259062@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wayne Chang <waynec@nvidia.com>

[ Upstream commit fce703a991b7e8c7e1371de95b9abaa832ecf9c3 ]

Deferred probe is an expected return value for fwnode_usb_role_switch_get().
Given that the driver deals with it properly, there's no need to output a
warning that may potentially confuse users.

--
V2 -> V3: remove the Fixes and Cc
V1 -> V2: adjust the coding style for better reading format.
 drivers/usb/typec/ucsi/ucsi.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Signed-off-by: Wayne Chang <waynec@nvidia.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20220927134512.2651067-1-waynec@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 6364f0d467ea..74fb5a4c6f21 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1067,11 +1067,9 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
 
 	cap->fwnode = ucsi_find_fwnode(con);
 	con->usb_role_sw = fwnode_usb_role_switch_get(cap->fwnode);
-	if (IS_ERR(con->usb_role_sw)) {
-		dev_err(ucsi->dev, "con%d: failed to get usb role switch\n",
-			con->num);
-		return PTR_ERR(con->usb_role_sw);
-	}
+	if (IS_ERR(con->usb_role_sw))
+		return dev_err_probe(ucsi->dev, PTR_ERR(con->usb_role_sw),
+			"con%d: failed to get usb role switch\n", con->num);
 
 	/* Delay other interactions with the con until registration is complete */
 	mutex_lock(&con->lock);
-- 
2.35.1




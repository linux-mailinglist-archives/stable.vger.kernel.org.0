Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F575FD021
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiJMAYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbiJMAXq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:23:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7920E6F54;
        Wed, 12 Oct 2022 17:21:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C18BB81CC2;
        Thu, 13 Oct 2022 00:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A62C433C1;
        Thu, 13 Oct 2022 00:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620308;
        bh=pZTA8+b6t89yvqWaduEatUoC/Fpvy1u8fwa7q8EqwVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r4amPdAvezJqLUY8cphf639KGbG/VLYk0w1QvIdqxL2lC1i+gSvsTV8a1UlXf/8bw
         MfGx5wg9XfgR2VM2LINIRZKkIXljR/YsCi/RVgtQfp5hTyMlRTPWuev5KU9kLJUgLh
         EhnK+b8WM6jMgrG+Yyx3p9YHuAM2zcoNM3VVaFcn+KZ2p3ZZvT4RAZ8ZC/FLBPB/kA
         4C5hTb86hneJSSTxviWFDp0dzmhVgWNalg9JexEimvhWtujQ04nDC9t2dPcUbR6izc
         PCwDiNACIahlQ+0su1dLmI/veA2mhGEE8/VfM78kQJRj+KZDzYeQE98QehWJ1mSIff
         5tRdNQOS9Qfbg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wayne Chang <waynec@nvidia.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, quic_linyyuan@quicinc.com,
        tiwai@suse.de, saranya.gopal@intel.com, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 65/67] usb: typec: ucsi: Don't warn on probe deferral
Date:   Wed, 12 Oct 2022 20:15:46 -0400
Message-Id: <20221013001554.1892206-65-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001554.1892206-1-sashal@kernel.org>
References: <20221013001554.1892206-1-sashal@kernel.org>
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


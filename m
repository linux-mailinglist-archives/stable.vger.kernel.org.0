Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9A4608ADB
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 11:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiJVJKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 05:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235261AbiJVJJh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 05:09:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C252DF452;
        Sat, 22 Oct 2022 01:23:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79318B82E1F;
        Sat, 22 Oct 2022 08:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1BDC433C1;
        Sat, 22 Oct 2022 08:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666426115;
        bh=pZTA8+b6t89yvqWaduEatUoC/Fpvy1u8fwa7q8EqwVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K2/TNFwK2ZLPmMAKOnxBaBwnsvxw0rwLWbEKuEI90QuA2zE7bQ+gARZasAVyefA4F
         i3SYCF0x7Y5UfwRspEqsUVcRIcpcqn6h71RMnBbR6o5CsyfVq3R31bKhbK+6iQANFQ
         I1BxsAuw76NVWPbFBtTujiQpZgSEdt3OMmIpURlI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wayne Chang <waynec@nvidia.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 693/717] usb: typec: ucsi: Dont warn on probe deferral
Date:   Sat, 22 Oct 2022 09:29:32 +0200
Message-Id: <20221022072529.126182612@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 658E6541C88
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379253AbiFGWCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383440AbiFGWCG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:02:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6A524E034;
        Tue,  7 Jun 2022 12:14:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B37E861923;
        Tue,  7 Jun 2022 19:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59A5C385A2;
        Tue,  7 Jun 2022 19:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629261;
        bh=Kw55ogd+UksAEvHHk1V0dss2Rjc0d6qyG+RxuJsUNVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FXoOAfpzTps+iNTT4DkF2bvxKxShqQkddaa26NT3gnmUgSZPY/+17IztoNv48zpMK
         9tcPv+Zp5QcYk4+FOFerUPCcz5CDGw+DnRtBOsvzUesB3/0RmPO+LTp4Quc5hsrMKc
         /eW0TFEY/HVvncpeyOZrlr3oZz8aIXRw0IOTayH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 590/879] firmware: arm_scmi: Fix list protocols enumeration in the base protocol
Date:   Tue,  7 Jun 2022 19:01:48 +0200
Message-Id: <20220607165019.976475398@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 8009120e0354a67068e920eb10dce532391361d0 ]

While enumerating protocols implemented by the SCMI platform using
BASE_DISCOVER_LIST_PROTOCOLS, the number of returned protocols is
currently validated in an improper way since the check employs a sum
between unsigned integers that could overflow and cause the check itself
to be silently bypassed if the returned value 'loop_num_ret' is big
enough.

Fix the validation avoiding the addition.

Link: https://lore.kernel.org/r/20220330150551.2573938-4-cristian.marussi@arm.com
Fixes: b6f20ff8bd94 ("firmware: arm_scmi: add common infrastructure and support for base protocol")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/base.c b/drivers/firmware/arm_scmi/base.c
index f5219334fd3a..3fe172c03c24 100644
--- a/drivers/firmware/arm_scmi/base.c
+++ b/drivers/firmware/arm_scmi/base.c
@@ -197,7 +197,7 @@ scmi_base_implementation_list_get(const struct scmi_protocol_handle *ph,
 			break;
 
 		loop_num_ret = le32_to_cpu(*num_ret);
-		if (tot_num_ret + loop_num_ret > MAX_PROTOCOLS_IMP) {
+		if (loop_num_ret > MAX_PROTOCOLS_IMP - tot_num_ret) {
 			dev_err(dev, "No. of Protocol > MAX_PROTOCOLS_IMP");
 			break;
 		}
-- 
2.35.1




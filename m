Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E03560410B
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbiJSKgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbiJSKgT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:36:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782B1647E2;
        Wed, 19 Oct 2022 03:15:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F36BB823C9;
        Wed, 19 Oct 2022 08:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983D6C433D7;
        Wed, 19 Oct 2022 08:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169719;
        bh=HXWLNBSYweesCtmqEF+DBW6DuBS8+yAnyMRGdDnJ0Lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=px2hEt6LsBLrjF/QZItAz4Ri3R9y4kZWfgMwUX9K/78xuEkId69mfvpQHyEifc+0R
         S8NL/P+ERgpw1NoKbpAZW4h99LiE5i42AhVurZ/lQ2bTTc1Eu3gAuMNuaQs96MwMBv
         xtT4vmq3NErhBL9g9gRxUFf259xIKWJUEX+bLfZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prashant Malani <pmalani@chromium.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Tzung-Bi Shih <tzungbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 375/862] platform/chrome: cros_ec_typec: Add bit offset for DP VDO
Date:   Wed, 19 Oct 2022 10:27:42 +0200
Message-Id: <20221019083306.548843142@linuxfoundation.org>
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

From: Prashant Malani <pmalani@chromium.org>

[ Upstream commit 1903adae0464c1e1c36b132db474cb3aff7bc727 ]

Use the right macro while constructing the DP_PORT_VDO to ensure the Pin
Assignment offsets are correct.

Fixes: 1ff5d97f070c ("platform/chrome: cros_ec_typec: Register port altmodes")
Signed-off-by: Prashant Malani <pmalani@chromium.org>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://lore.kernel.org/r/20220819190807.1275937-2-pmalani@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_typec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/cros_ec_typec.c b/drivers/platform/chrome/cros_ec_typec.c
index de6ee0f926a6..4d81d8d45b73 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -25,7 +25,8 @@
 
 #define DRV_NAME "cros-ec-typec"
 
-#define DP_PORT_VDO	(BIT(DP_PIN_ASSIGN_C) | BIT(DP_PIN_ASSIGN_D) | DP_CAP_DFP_D)
+#define DP_PORT_VDO	(DP_CONF_SET_PIN_ASSIGN(BIT(DP_PIN_ASSIGN_C) | BIT(DP_PIN_ASSIGN_D)) | \
+				DP_CAP_DFP_D)
 
 /* Supported alt modes. */
 enum {
-- 
2.35.1




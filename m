Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 918B26213EC
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234778AbiKHNz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234789AbiKHNzZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:55:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE102BF6
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:55:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91D3DB81AF2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:55:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8150C433D6;
        Tue,  8 Nov 2022 13:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915721;
        bh=sEA+npjrGnZSQcOO90KPoehRSC0Tb47cgtuhsO9bzcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AWet+GPYeT5qGnFcSd27hKzKmmuyu+bJ2hnpB/LJnw1Zii50SmzYUMzDtqc2RgJiy
         i+xbJsY9xGoei3kppeWOhqR6A5+DW8wKPIohf73G5rb48BKmxRucLbF7mn/b0Cnb36
         KJ8ARruoLG9NU85sEqkRbUNT4LF+OPm47hh0qkgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/118] firmware: arm_scmi: Suppress the drivers bind attributes
Date:   Tue,  8 Nov 2022 14:39:10 +0100
Message-Id: <20221108133343.877125868@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
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

[ Upstream commit fd96fbc8fad35d6b1872c90df8a2f5d721f14d91 ]

Suppress the capability to unbind the core SCMI driver since all the
SCMI stack protocol drivers depend on it.

Fixes: aa4f886f3893 ("firmware: arm_scmi: add basic driver infrastructure for SCMI")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20221028140833.280091-2-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 745b7f9eb335..4bc974ead02b 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -942,6 +942,7 @@ MODULE_DEVICE_TABLE(of, scmi_of_match);
 static struct platform_driver scmi_driver = {
 	.driver = {
 		   .name = "arm-scmi",
+		   .suppress_bind_attrs = true,
 		   .of_match_table = scmi_of_match,
 		   .dev_groups = versions_groups,
 		   },
-- 
2.35.1




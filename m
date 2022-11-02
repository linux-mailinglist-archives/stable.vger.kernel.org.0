Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE476159E8
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiKBDUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbiKBDUr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:20:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17E11C916
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:20:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EA9DB8206F
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D938C433C1;
        Wed,  2 Nov 2022 03:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359241;
        bh=4fZijcWs+/dDJWHhq8afKdDw6CEwtGCj4r6Hv6U25Sg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HvYXAg1DzKLTpdXyb3Wlw4+997HwbakYnu9mrPq/Jotsp7N8InFuqwaljlxraAENa
         Kv0tlfR2MnA/C8ESU2qZVt4fuErg3lTGk0ZjqXtUdPYakM7RksT6O0WYTMDjXv7P/I
         HL2o6UGTX7yHQZT6bGB9pYvf6cOqIIWzjR/bb04I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sudeep Holla <sudeep.holla@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 74/91] PM: domains: Fix handling of unavailable/disabled idle states
Date:   Wed,  2 Nov 2022 03:33:57 +0100
Message-Id: <20221102022057.144961568@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit e0c57a5c70c13317238cb19a7ded0eab4a5f7de5 ]

Platforms can provide the information about the availability of each
idle states via status flag. Platforms may have to disable one or more
idle states for various reasons like broken firmware or other unmet
dependencies.

Fix handling of such unavailable/disabled idle states by ignoring them
while parsing the states.

Fixes: a3381e3a65cb ("PM / domains: Fix up domain-idle-states OF parsing")
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/domain.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index 743268996336..d0ba5459ce0b 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -2789,6 +2789,10 @@ static int genpd_iterate_idle_states(struct device_node *dn,
 		np = it.node;
 		if (!of_match_node(idle_state_match, np))
 			continue;
+
+		if (!of_device_is_available(np))
+			continue;
+
 		if (states) {
 			ret = genpd_parse_state(&states[i], np);
 			if (ret) {
-- 
2.35.1




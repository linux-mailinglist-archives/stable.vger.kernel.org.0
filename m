Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A65736158C4
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiKBC6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbiKBC6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:58:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E01922B19
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:58:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF429B82064
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:58:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF724C433D6;
        Wed,  2 Nov 2022 02:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357894;
        bh=MD6lUl5f601sYYN2u4KL3tXh6JVVHoViPFPndZKPYjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vK+jl4lnY0fM4zjcyq0ouMoVbQTSShv4mW8dFZ+IQfnByiJHNjM+keP9q4WTk3jp7
         97XvIXB8FZONhRhiFrT6g/ZRoHSPUQVDPrTuJ6lftA+ksVmBda9s1P1g20iDP/GbD9
         0jSpQ4cbRtsavXZOzZbJYcoWjexWzPhRdOlb19Dg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sudeep Holla <sudeep.holla@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 209/240] PM: domains: Fix handling of unavailable/disabled idle states
Date:   Wed,  2 Nov 2022 03:33:04 +0100
Message-Id: <20221102022116.126133005@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
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
index 55a10e6d4e2a..b7bb9df386de 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -2950,6 +2950,10 @@ static int genpd_iterate_idle_states(struct device_node *dn,
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




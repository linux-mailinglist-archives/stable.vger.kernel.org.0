Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 604E3615AA3
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiKBDhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiKBDho (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:37:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F032655C
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:37:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA6B461729
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5309DC433D6;
        Wed,  2 Nov 2022 03:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667360263;
        bh=rW1IYqcYQ1DD1viS3spLNZ1+QEjUnkW/V/pP8ZL/mPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BqSf0rAWIgeItboqpeDLJLMsjk7WHNqbm+qA+KQwqUusdnoch9eWepCk6o97iCEG6
         IeXs8o9Uyg3X0UeGSZVj4dNgsWpPKLuzqgNzLc79/BOlbaHzu1Qf+3upl2GIlHVvle
         N8Bh1uSOw4hoCWXiVJ+nOSjba6t2yTTn93oyaEVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sudeep Holla <sudeep.holla@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 72/78] PM: domains: Fix handling of unavailable/disabled idle states
Date:   Wed,  2 Nov 2022 03:34:57 +0100
Message-Id: <20221102022055.049721379@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
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
index 52c292d0908a..e865aa4b2504 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -2459,6 +2459,10 @@ static int genpd_iterate_idle_states(struct device_node *dn,
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




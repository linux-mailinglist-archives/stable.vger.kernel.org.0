Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E92B660443F
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiJSMAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbiJSL7c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:59:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185A0181C99;
        Wed, 19 Oct 2022 04:37:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE73AB823C0;
        Wed, 19 Oct 2022 08:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E8CC433C1;
        Wed, 19 Oct 2022 08:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169645;
        bh=GcEtVsWKnpmNwwgXJ7eWwXOSgwnZJUIhbPIQKSK6ZAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IxRqG3Ag8oO8yLR8KjzoEmSKE6gmd8kPAJVYNGeL9bRMGOH44KtcKw4mu3dtXba0d
         qQCVsYoaiEwyi1RXF3dL4voRzIb6tslXxpNlWevynQkes77uAuGQ1SM4OAvgQnnyGF
         3Rhokjuzk2smQ5qBk5m90Zgbop1NJKaf3n7SPJI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 355/862] drm/bridge: tc358767: Add of_node_put() when breaking out of loop
Date:   Wed, 19 Oct 2022 10:27:22 +0200
Message-Id: <20221019083305.720386538@linuxfoundation.org>
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

From: Liang He <windhl@126.com>

[ Upstream commit 14e7157afb055248ed34901fcd6fbf54201cfea1 ]

In tc_probe_bridge_endpoint(), we should call of_node_put() when
breaking out of the for_each_endpoint_of_node() which will automatically
increase and decrease the refcount.

Fixes: 71f7d9c03118 ("drm/bridge: tc358767: Detect bridge mode from connected endpoints in DT")
Signed-off-by: Liang He <windhl@126.com>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220719065447.1080817-2-windhl@126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358767.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/tc358767.c b/drivers/gpu/drm/bridge/tc358767.c
index 02bd757a8987..1dc107f13645 100644
--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -2010,9 +2010,10 @@ static int tc_probe_bridge_endpoint(struct tc_data *tc)
 
 	for_each_endpoint_of_node(dev->of_node, node) {
 		of_graph_parse_endpoint(node, &endpoint);
-		if (endpoint.port > 2)
+		if (endpoint.port > 2) {
+			of_node_put(node);
 			return -EINVAL;
-
+		}
 		mode |= BIT(endpoint.port);
 	}
 
-- 
2.35.1




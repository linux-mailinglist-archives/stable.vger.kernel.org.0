Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 447D96CC4D7
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjC1PJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbjC1PJZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:09:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3177C15C
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:08:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC196B81D8E
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE90C433EF;
        Tue, 28 Mar 2023 15:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016087;
        bh=uuM4XBtYW5w9jZkoNWMYEJHVqnGUNgx3ZCZryf/qqIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B0KRCP/X2slm09GBitI8yI5KXiHkP9z16uViVM1AlBWjRKcvCBxPBrlKPF19RXbBV
         le1uvOVLDiUlmGEZsAHBPCBRwlYathpA5c96NG45/fSgu1P60JtsQGLcXczCM9mavv
         lyidC+Bjpz6hIvy3AxYM0xbEyDRuDB9FLzBW36z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Joshua Washington <joshwash@google.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/146] gve: Cache link_speed value from device
Date:   Tue, 28 Mar 2023 16:42:28 +0200
Message-Id: <20230328142605.173330538@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joshua Washington <joshwash@google.com>

[ Upstream commit 68c3e4fc8628b1487c965aabb29207249657eb5f ]

The link speed is never changed for the uptime of a VM, and the current
implementation sends an admin queue command for each call. Admin queue
command invocations have nontrivial overhead (e.g., VM exits), which can
be disruptive to users if triggered frequently. Our telemetry data shows
that there are VMs that make frequent calls to this admin queue command.
Caching the result of the original admin queue command would eliminate
the need to send multiple admin queue commands on subsequent calls to
retrieve link speed.

Fixes: 7e074d5a76ca ("gve: Enable Link Speed Reporting in the driver.")
Signed-off-by: Joshua Washington <joshwash@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230321172332.91678-1-joshwash@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_ethtool.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index 878329ddcf8df..6a0663aadd1e9 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -526,7 +526,10 @@ static int gve_get_link_ksettings(struct net_device *netdev,
 				  struct ethtool_link_ksettings *cmd)
 {
 	struct gve_priv *priv = netdev_priv(netdev);
-	int err = gve_adminq_report_link_speed(priv);
+	int err = 0;
+
+	if (priv->link_speed == 0)
+		err = gve_adminq_report_link_speed(priv);
 
 	cmd->base.speed = priv->link_speed;
 	return err;
-- 
2.39.2




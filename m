Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C100B6D4979
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbjDCOiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233695AbjDCOiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:38:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CAD1716
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:38:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B22046146A
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5EEAC433EF;
        Mon,  3 Apr 2023 14:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532691;
        bh=bnXGSrJ5LYiSxPwVG+PHx16MB8M/+/Sp8dvWSvy+g1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qc91PVA3VXA1IbKma4JV+XoNv+QI5trmB88Mj9DP2YbF9ieegQk9v+OlRvIyRC+qz
         saMy5yJ/7e1hYPkvOl3BNDqB1j+5AD60K52dDFkC9+knhWbsvRG6HUDme5kAc/L0Wh
         mBszT4i3wPXTHHhq9PndppU5hxLvFAM2fiCrdAzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liang He <windhl@126.com>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/181] platform/surface: aggregator: Add missing fwnode_handle_put()
Date:   Mon,  3 Apr 2023 16:08:34 +0200
Message-Id: <20230403140417.709259981@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
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

From: Liang He <windhl@126.com>

[ Upstream commit acd0acb802b90f88d19ad4337183e44fd0f77c50 ]

In fwnode_for_each_child_node(), we should add
fwnode_handle_put() when break out of the iteration
fwnode_for_each_child_node() as it will automatically
increase and decrease the refcounter.

Fixes: fc622b3d36e6 ("platform/surface: Set up Surface Aggregator device registry")
Signed-off-by: Liang He <windhl@126.com>
Reviewed-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20230322033057.1855741-1-windhl@126.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/surface/aggregator/bus.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/surface/aggregator/bus.c b/drivers/platform/surface/aggregator/bus.c
index de539938896e2..b501a79f2a08a 100644
--- a/drivers/platform/surface/aggregator/bus.c
+++ b/drivers/platform/surface/aggregator/bus.c
@@ -485,8 +485,10 @@ int __ssam_register_clients(struct device *parent, struct ssam_controller *ctrl,
 		 * device, so ignore it and continue with the next one.
 		 */
 		status = ssam_add_client_device(parent, ctrl, child);
-		if (status && status != -ENODEV)
+		if (status && status != -ENODEV) {
+			fwnode_handle_put(child);
 			goto err;
+		}
 	}
 
 	return 0;
-- 
2.39.2




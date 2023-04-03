Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69186D4A55
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233917AbjDCOq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233984AbjDCOqX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:46:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B05448F
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:45:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4B9AB81D50
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DE7C433A0;
        Mon,  3 Apr 2023 14:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533155;
        bh=bnXGSrJ5LYiSxPwVG+PHx16MB8M/+/Sp8dvWSvy+g1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vsm9/+dH8TBer23eWh1ep6b96ju5OWWDtkojIGwL61imE+iGOYcmW7Cs2TKrscPn6
         RwKGshlxa2XO0tlIGcf7hIHCBxvfHNDR0XGnpRqOeRGP3pKDGoL/hbgjdixzQiVv2l
         N3FmRjNQMG42KwYPxbiHTzk4+3Y6SAxR0yHN24Eo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liang He <windhl@126.com>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 075/187] platform/surface: aggregator: Add missing fwnode_handle_put()
Date:   Mon,  3 Apr 2023 16:08:40 +0200
Message-Id: <20230403140418.415599854@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
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




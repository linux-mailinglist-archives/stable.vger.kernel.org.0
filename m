Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFC44A7011
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 12:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244594AbiBBLgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 06:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343899AbiBBLgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 06:36:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA42C06173D;
        Wed,  2 Feb 2022 03:36:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13330B8307E;
        Wed,  2 Feb 2022 11:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3C4C340EF;
        Wed,  2 Feb 2022 11:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643801767;
        bh=a1ae4CRR715CYUBaMy5Wvq7XIcUVZv3r/LRlFqiLhcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ACAYFu7lMBxzuwbdfNTStL40XCbFtT6GoVWnv4CP3EgQ/iOz+K6wOcHkZfBm4jv4W
         8+OYs7ENFOzdKOVFFenKyHPBfotEK0CvcdAWhyJTUZUY3j+czBWz1T/wuIik2zCqAW
         4GP37+mFhknWkybJEpIzfN11Jthh7wPR3RKWTebgsO+/IvpJO1cOkbdLMBTuozK45u
         pIlUpoqhbpD4X+r821bKC12WD9M/GJ+/j0iyqsHzmsVxy0uUYnzqlTztRoxkWyC2+1
         O4Ylgk2bLhogace9pchPCSNE0w754rhmj74YrLYRFbIT4hu2tLqQAnEPZgADgp4/3G
         SctclROqzLPWQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1nFDvT-0000Lx-8Z; Wed, 02 Feb 2022 12:35:51 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>,
        Mitchell Tasman <tasman@leaflabs.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        greybus-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/3] greybus: svc: fix an error handling bug in gb_svc_hello()
Date:   Wed,  2 Feb 2022 12:33:45 +0100
Message-Id: <20220202113347.1288-2-johan@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220202113347.1288-1-johan@kernel.org>
References: <20220202113347.1288-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

Cleanup if gb_svc_queue_deferred_request() fails.

Fixes: ee2f2074fdb2 ("greybus: svc: reconfig APBridgeA-Switch link to handle required load")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20220202072016.GA6748@kili
Cc: stable@vger.kernel.org      # 4.9
[johan: fix commit summary prefix and rename label ]
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/greybus/svc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/greybus/svc.c b/drivers/greybus/svc.c
index ce7740ef449b..51d0875a3480 100644
--- a/drivers/greybus/svc.c
+++ b/drivers/greybus/svc.c
@@ -866,8 +866,14 @@ static int gb_svc_hello(struct gb_operation *op)
 
 	gb_svc_debugfs_init(svc);
 
-	return gb_svc_queue_deferred_request(op);
+	ret = gb_svc_queue_deferred_request(op);
+	if (ret)
+		goto err_remove_debugfs;
+
+	return 0;
 
+err_remove_debugfs:
+	gb_svc_debugfs_exit(svc);
 err_unregister_device:
 	gb_svc_watchdog_destroy(svc);
 	device_del(&svc->dev);
-- 
2.34.1


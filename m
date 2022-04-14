Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E620C5014C5
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345020AbiDNNty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242291AbiDNNhK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:37:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB13B972EC;
        Thu, 14 Apr 2022 06:31:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76C656190F;
        Thu, 14 Apr 2022 13:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8136FC385A5;
        Thu, 14 Apr 2022 13:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943081;
        bh=Hxo4l3G3ezXXxyeir2RGiMkhpL4xQTk/wS0+4Y5M1K8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q0BeB8kWqju3xV1zz3pL/QvBFgBjUOeinRA5feTX7JLJtliHZMnVwR0IzE2tRJUKt
         umKHLgLHCxZ/kwLOBz9EBYQt6kgxp2md9VLDEcQ2oCUxRqE6xbppFNwNNG60b2uMbV
         FTLbJv42CWvV2QfGNAoTDWNQq1bCDFiurHih0tYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 028/475] greybus: svc: fix an error handling bug in gb_svc_hello()
Date:   Thu, 14 Apr 2022 15:06:53 +0200
Message-Id: <20220414110855.941883172@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 5f8583a3b7552092582a92e7bbd2153319929ad7 upstream.

Cleanup if gb_svc_queue_deferred_request() fails.

Link: https://lore.kernel.org/r/20220202072016.GA6748@kili
Fixes: ee2f2074fdb2 ("greybus: svc: reconfig APBridgeA-Switch link to handle required load")
Cc: stable@vger.kernel.org      # 4.9
[johan: fix commit summary prefix and rename label ]
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20220202113347.1288-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/greybus/svc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/greybus/svc.c
+++ b/drivers/greybus/svc.c
@@ -866,8 +866,14 @@ static int gb_svc_hello(struct gb_operat
 
 	gb_svc_debugfs_init(svc);
 
-	return gb_svc_queue_deferred_request(op);
+	ret = gb_svc_queue_deferred_request(op);
+	if (ret)
+		goto err_remove_debugfs;
 
+	return 0;
+
+err_remove_debugfs:
+	gb_svc_debugfs_exit(svc);
 err_unregister_device:
 	gb_svc_watchdog_destroy(svc);
 	device_del(&svc->dev);



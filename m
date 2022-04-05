Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E74614F2FD6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343665AbiDEI5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234501AbiDEIjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:39:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6686D21E3F;
        Tue,  5 Apr 2022 01:33:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BB40B81B92;
        Tue,  5 Apr 2022 08:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAA4C385A1;
        Tue,  5 Apr 2022 08:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147591;
        bh=Hxo4l3G3ezXXxyeir2RGiMkhpL4xQTk/wS0+4Y5M1K8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQ34fV7LJPq/dVQMYnoTsb8UizHxgrXRPHiFNGsHl/3+VfwT5AK2RBJWkrG+ayWWD
         BbV/+g3usMlhmugEO7vSSzoBOl95WLQeLgihtB76IWjMyOLjdgShTqyJru7OjiNq+P
         UOMm4adpzq0lc6AEQQa9EXmb7WFEUhJ3guMSysAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.16 0051/1017] greybus: svc: fix an error handling bug in gb_svc_hello()
Date:   Tue,  5 Apr 2022 09:16:04 +0200
Message-Id: <20220405070355.699128328@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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



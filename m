Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2564C734D
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237968AbiB1Re1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238571AbiB1Rdi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:33:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5419134B;
        Mon, 28 Feb 2022 09:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7978CB815A6;
        Mon, 28 Feb 2022 17:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D641DC340E7;
        Mon, 28 Feb 2022 17:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069413;
        bh=qrgm1kzt2di1ONuE+6wLgytVgwd7igoW8PBsESMIvNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJyBm8lJ8wBMksBhTSMVdN0/x8lOhdIq9JFfWQWAeZQ87ByjQD33YAqvuKK3pEaGN
         oCgiclX5hNEGMC4dbCYgwBAcUoWd5gkYBWnITU9QAm9drdFJBsnMIShzLd0OFPjC1+
         EwdXNHojKMU/BvmW8DVSnzPdIJVEK3YxgvtXp+ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>
Subject: [PATCH 5.4 11/53] tee: export teedev_open() and teedev_close_context()
Date:   Mon, 28 Feb 2022 18:24:09 +0100
Message-Id: <20220228172249.155940685@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172248.232273337@linuxfoundation.org>
References: <20220228172248.232273337@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Wiklander <jens.wiklander@linaro.org>

commit 1e2c3ef0496e72ba9001da5fd1b7ed56ccb30597 upstream.

Exports the two functions teedev_open() and teedev_close_context() in
order to make it easier to create a driver internal struct tee_context.

Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tee/tee_core.c  |    6 ++++--
 include/linux/tee_drv.h |   14 ++++++++++++++
 2 files changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/tee/tee_core.c
+++ b/drivers/tee/tee_core.c
@@ -28,7 +28,7 @@ static DEFINE_SPINLOCK(driver_lock);
 static struct class *tee_class;
 static dev_t tee_devt;
 
-static struct tee_context *teedev_open(struct tee_device *teedev)
+struct tee_context *teedev_open(struct tee_device *teedev)
 {
 	int rc;
 	struct tee_context *ctx;
@@ -56,6 +56,7 @@ err:
 	return ERR_PTR(rc);
 
 }
+EXPORT_SYMBOL_GPL(teedev_open);
 
 void teedev_ctx_get(struct tee_context *ctx)
 {
@@ -82,13 +83,14 @@ void teedev_ctx_put(struct tee_context *
 	kref_put(&ctx->refcount, teedev_ctx_release);
 }
 
-static void teedev_close_context(struct tee_context *ctx)
+void teedev_close_context(struct tee_context *ctx)
 {
 	struct tee_device *teedev = ctx->teedev;
 
 	teedev_ctx_put(ctx);
 	tee_device_put(teedev);
 }
+EXPORT_SYMBOL_GPL(teedev_close_context);
 
 static int tee_open(struct inode *inode, struct file *filp)
 {
--- a/include/linux/tee_drv.h
+++ b/include/linux/tee_drv.h
@@ -579,4 +579,18 @@ struct tee_client_driver {
 #define to_tee_client_driver(d) \
 		container_of(d, struct tee_client_driver, driver)
 
+/**
+ * teedev_open() - Open a struct tee_device
+ * @teedev:	Device to open
+ *
+ * @return a pointer to struct tee_context on success or an ERR_PTR on failure.
+ */
+struct tee_context *teedev_open(struct tee_device *teedev);
+
+/**
+ * teedev_close_context() - closes a struct tee_context
+ * @ctx:	The struct tee_context to close
+ */
+void teedev_close_context(struct tee_context *ctx);
+
 #endif /*__TEE_DRV_H*/



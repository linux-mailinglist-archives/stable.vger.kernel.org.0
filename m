Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E765580D3
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbiFWQxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbiFWQwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:52:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B92110B6;
        Thu, 23 Jun 2022 09:52:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B574461FC2;
        Thu, 23 Jun 2022 16:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A19C341C5;
        Thu, 23 Jun 2022 16:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003156;
        bh=YpkhMeXBrmX0JFVy3p78yrqaOUSWZX8GthRE//wHpMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nz2foMzqH5YA/P1PqV7Yh+t8SSGXygZ/O7dmJ3dK2HJUFbBEZJLyBJwEZAB5oprV4
         orxx0S2FQV59j8+8f4SJhGP2TPVdcaByE3y9DQUW2mXUH+gf178vvVr+PxLoLWi7SV
         4qoJQL1PZt/enjysA87iLPFVDIoxFEvyqxDDW6QM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 148/264] hwrng: core - Move hwrng miscdev minor number to include/linux/miscdevice.h
Date:   Thu, 23 Jun 2022 18:42:21 +0200
Message-Id: <20220623164348.252752481@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin LABBE <clabbe.montjoie@gmail.com>

commit fd50d71f94fb1c8614098949db068cd4c8dbb91d upstream.

This patch move the define for hwrng's miscdev minor number to
include/linux/miscdevice.h.
It's better that all minor number are in the same place.
Rename it to HWRNG_MINOR (from RNG_MISCDEV_MINOR) in he process since
no other miscdev define have MISCDEV in their name.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/hw_random/core.c |    3 +--
 include/linux/miscdevice.h    |    1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -26,7 +26,6 @@
 
 #define RNG_MODULE_NAME		"hw_random"
 #define PFX			RNG_MODULE_NAME ": "
-#define RNG_MISCDEV_MINOR	183 /* official */
 
 static struct hwrng *current_rng;
 static struct task_struct *hwrng_fill;
@@ -283,7 +282,7 @@ static const struct file_operations rng_
 static const struct attribute_group *rng_dev_groups[];
 
 static struct miscdevice rng_miscdev = {
-	.minor		= RNG_MISCDEV_MINOR,
+	.minor		= HWRNG_MINOR,
 	.name		= RNG_MODULE_NAME,
 	.nodename	= "hwrng",
 	.fops		= &rng_chrdev_ops,
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -31,6 +31,7 @@
 #define SGI_MMTIMER		153
 #define STORE_QUEUE_MINOR	155	/* unused */
 #define I2O_MINOR		166
+#define HWRNG_MINOR		183
 #define MICROCODE_MINOR		184
 #define VFIO_MINOR		196
 #define TUN_MINOR		200



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99BDD63587F
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237004AbiKWJ6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237095AbiKWJ54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:57:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4C41173EE
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:52:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0ECD61B6F
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:52:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF73C433C1;
        Wed, 23 Nov 2022 09:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197139;
        bh=3Ge9i+CN2V7C7c6CJ9UoxWD1b320vv3joU0Fa0Ejk5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AWsMtefUvnTOufAA5gBh4MAAs08mp/SNd91W7nHB5QOyxb5wzzXuX5iiNvZIbwc9g
         gCBRE1IYoFnDr0g2GcQgMAitNVMANiB54CmSdN9jBx5vA/X+nf38ruQKswVXcxMg88
         hwJe9MinV8wqu6TpGFnhDnEi8uNfRo2TNOMopTJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 177/314] drbd: use after free in drbd_create_device()
Date:   Wed, 23 Nov 2022 09:50:22 +0100
Message-Id: <20221123084633.599297403@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit a7a1598189228b5007369a9622ccdf587be0730f ]

The drbd_destroy_connection() frees the "connection" so use the _safe()
iterator to prevent a use after free.

Fixes: b6f85ef9538b ("drbd: Iterate over all connections")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Link: https://lore.kernel.org/r/Y3Jd5iZRbNQ9w6gm@kili
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index f3e4db16fd07..8532b839a343 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2672,7 +2672,7 @@ static int init_submitter(struct drbd_device *device)
 enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsigned int minor)
 {
 	struct drbd_resource *resource = adm_ctx->resource;
-	struct drbd_connection *connection;
+	struct drbd_connection *connection, *n;
 	struct drbd_device *device;
 	struct drbd_peer_device *peer_device, *tmp_peer_device;
 	struct gendisk *disk;
@@ -2789,7 +2789,7 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 	return NO_ERROR;
 
 out_idr_remove_from_resource:
-	for_each_connection(connection, resource) {
+	for_each_connection_safe(connection, n, resource) {
 		peer_device = idr_remove(&connection->peer_devices, vnr);
 		if (peer_device)
 			kref_put(&connection->kref, drbd_destroy_connection);
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 405AA66751C
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236174AbjALOSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236002AbjALORm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:17:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93205D6AA
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:09:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5592260110
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF23C433EF;
        Thu, 12 Jan 2023 14:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532561;
        bh=7qLmqE8QTVKMXtI49wmANbW9/uUd5pcOBlNAulz7ZJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v/RrIsIvUv2jK9+IclnRLiw43cNJT0zWa8fF6OBdZSq4eL1YWdyDp33hw8vhgGvz0
         AH2ZjElC80l+uj8Yno7OSWb8w485fVbz7KxBCZ3mP0aZmycySal9ZpU5ocjK/A06pp
         kqPrEkbxms7wuwDGnIcMVoLw4B0PtqALsVHVnfOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 172/783] drbd: fix an invalid memory access caused by incorrect use of list iterator
Date:   Thu, 12 Jan 2023 14:48:08 +0100
Message-Id: <20230112135532.297254798@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

[ Upstream commit ae4d37b5df749926891583d42a6801b5da11e3c1 ]

The bug is here:
	idr_remove(&connection->peer_devices, vnr);

If the previous for_each_connection() don't exit early (no goto hit
inside the loop), the iterator 'connection' after the loop will be a
bogus pointer to an invalid structure object containing the HEAD
(&resource->connections). As a result, the use of 'connection' above
will lead to a invalid memory access (including a possible invalid free
as idr_remove could call free_layer).

The original intention should have been to remove all peer_devices,
but the following lines have already done the work. So just remove
this line and the unneeded label, to fix this bug.

Cc: stable@vger.kernel.org
Fixes: c06ece6ba6f1b ("drbd: Turn connection->volumes into connection->peer_devices")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Reviewed-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Reviewed-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 51450f7c81af..420bdaf8c356 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2819,7 +2819,7 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 
 	if (init_submitter(device)) {
 		err = ERR_NOMEM;
-		goto out_idr_remove_vol;
+		goto out_idr_remove_from_resource;
 	}
 
 	add_disk(disk);
@@ -2836,8 +2836,6 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 	drbd_debugfs_device_add(device);
 	return NO_ERROR;
 
-out_idr_remove_vol:
-	idr_remove(&connection->peer_devices, vnr);
 out_idr_remove_from_resource:
 	for_each_connection_safe(connection, n, resource) {
 		peer_device = idr_remove(&connection->peer_devices, vnr);
-- 
2.35.1




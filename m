Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0C704FB5BD
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 10:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343635AbiDKISJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 04:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343665AbiDKIRg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 04:17:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71343E0D2
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 01:15:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72CE4614F4
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 08:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815FDC385A3;
        Mon, 11 Apr 2022 08:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649664921;
        bh=3YnMQsEfKeBx/uJ+2Ij+2kcX9i5NwbB6ZvhZNULeuAY=;
        h=Subject:To:Cc:From:Date:From;
        b=Kta4WFU+G0HGdm0ATaYzrjpDQpg/1fDuw028CpOa2jHMh1WuVPTQy+gE/BeP3Sk0n
         62ERGQHqSO1CCPaxfKYlMkofuC2BBqWiEEnhFfa8A91m0ZHgKNm7tWoGv1A/9XNO2a
         brpkXFsz3ruAnVidn0Tn5G9Os7ajfgnp2rsFIVwQ=
Subject: FAILED: patch "[PATCH] drbd: fix an invalid memory access caused by incorrect use of" failed to apply to 5.15-stable tree
To:     xiam0nd.tong@gmail.com, axboe@kernel.dk,
        christoph.boehmwalder@linbit.com, lars.ellenberg@linbit.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Apr 2022 10:15:19 +0200
Message-ID: <164966491918132@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ae4d37b5df749926891583d42a6801b5da11e3c1 Mon Sep 17 00:00:00 2001
From: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Date: Wed, 6 Apr 2022 21:04:44 +0200
Subject: [PATCH] drbd: fix an invalid memory access caused by incorrect use of
 list iterator
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 9676a1d214bc..d6dfa286ddb3 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2773,12 +2773,12 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 
 	if (init_submitter(device)) {
 		err = ERR_NOMEM;
-		goto out_idr_remove_vol;
+		goto out_idr_remove_from_resource;
 	}
 
 	err = add_disk(disk);
 	if (err)
-		goto out_idr_remove_vol;
+		goto out_idr_remove_from_resource;
 
 	/* inherit the connection state */
 	device->state.conn = first_connection(resource)->cstate;
@@ -2792,8 +2792,6 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 	drbd_debugfs_device_add(device);
 	return NO_ERROR;
 
-out_idr_remove_vol:
-	idr_remove(&connection->peer_devices, vnr);
 out_idr_remove_from_resource:
 	for_each_connection(connection, resource) {
 		peer_device = idr_remove(&connection->peer_devices, vnr);


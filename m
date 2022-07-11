Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49B756FCFF
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbiGKJtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233808AbiGKJtR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:49:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB14ACED0;
        Mon, 11 Jul 2022 02:24:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A26AD6134F;
        Mon, 11 Jul 2022 09:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A71C34115;
        Mon, 11 Jul 2022 09:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531441;
        bh=UB2l8rglaiJ+3138F+SK8mciJZH6/QYMdfUlOV/2Wbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mp+CnlDos+fgcOWzaINBSewS0AmA3TBHtChkTUf29+LIMrdei8V7tnMnJrir9Lh/5
         ccAYi2tXOupR8r92s3WqWIcovd97wAwAANE3a5no1qJgwe9IfadYNPtc6K2ymZn5/1
         QkgJSnawe2feSZ0lSK71RetTveKcEG7UWH3Pvh3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/230] drbd: add error handling support for add_disk()
Date:   Mon, 11 Jul 2022 11:05:45 +0200
Message-Id: <20220711090606.597054422@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit e92ab4eda516a5bfd96c087282ebe9521deba4f4 ]

We never checked for errors on add_disk() as this function
returned void. Now that this is fixed, use the shiny new
error handling.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 8ba2fe356f01..ae6a136d278e 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2798,7 +2798,9 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 		goto out_idr_remove_vol;
 	}
 
-	add_disk(disk);
+	err = add_disk(disk);
+	if (err)
+		goto out_cleanup_disk;
 
 	/* inherit the connection state */
 	device->state.conn = first_connection(resource)->cstate;
@@ -2812,6 +2814,8 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 	drbd_debugfs_device_add(device);
 	return NO_ERROR;
 
+out_cleanup_disk:
+	blk_cleanup_disk(disk);
 out_idr_remove_vol:
 	idr_remove(&connection->peer_devices, vnr);
 out_idr_remove_from_resource:
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1140E56FD1A
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233749AbiGKJu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbiGKJuc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:50:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DAE313A7;
        Mon, 11 Jul 2022 02:24:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5E8DB80D2C;
        Mon, 11 Jul 2022 09:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32138C341C0;
        Mon, 11 Jul 2022 09:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531471;
        bh=xZz0qpVyBij1ECB9UEqppt9fb3xkzJWlXqnbQzD241E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tlrz2eXoukHe8KHEapEYFtFIey496FM8RJFKkH1IzRz60rhGHN25rJ4QmzlCx7BOR
         aIK4Ry8ZEnNfeALjorOBFKx60k2yxiCmvFfXax6PjKgSCr9r7jEWds67W5JQNcNuHQ
         0mcGfb4zkmKsViIgEdv/gRiJhV+HJ3hw8YX/ayI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wu Bo <wubo40@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/230] drbd: Fix double free problem in drbd_create_device
Date:   Mon, 11 Jul 2022 11:05:46 +0200
Message-Id: <20220711090606.625323058@linuxfoundation.org>
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

From: Wu Bo <wubo40@huawei.com>

[ Upstream commit 27548088ac628109f70eb0b1eb521d035844dba8 ]

In drbd_create_device(), the 'out_no_io_page' lable has called
blk_cleanup_disk() when return failed.

So remove the 'out_cleanup_disk' lable to avoid double free the
disk pointer.

Fixes: e92ab4eda516 ("drbd: add error handling support for add_disk()")
Signed-off-by: Wu Bo <wubo40@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/1636013229-26309-1-git-send-email-wubo40@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index ae6a136d278e..b91d2a9dc238 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2800,7 +2800,7 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 
 	err = add_disk(disk);
 	if (err)
-		goto out_cleanup_disk;
+		goto out_idr_remove_vol;
 
 	/* inherit the connection state */
 	device->state.conn = first_connection(resource)->cstate;
@@ -2814,8 +2814,6 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 	drbd_debugfs_device_add(device);
 	return NO_ERROR;
 
-out_cleanup_disk:
-	blk_cleanup_disk(disk);
 out_idr_remove_vol:
 	idr_remove(&connection->peer_devices, vnr);
 out_idr_remove_from_resource:
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D894F4FD125
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239364AbiDLG5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351498AbiDLGxp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:53:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC5E37A3C;
        Mon, 11 Apr 2022 23:41:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE17CB81B29;
        Tue, 12 Apr 2022 06:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E630C385A6;
        Tue, 12 Apr 2022 06:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745686;
        bh=JqfoJ9G/LizlVO+EiCR+WslAeNQWlhpXohvizsOaUUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1tHCwmJ757JkYNiMQo3eCAs22AptH8C/wIIj6T1eRmL33kz/v+d6BuApxkysXZqBg
         UKiUApGkJPi52649STY2o7PKx+4RzDYkY1YuBv+3/dU6drbQk2pMwP01cXs3yhb6xF
         5xmq2Unt8eJg4H3b8k7FQWzghZibORrJs7IM5Y9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/277] nbd: add error handling support for add_disk()
Date:   Tue, 12 Apr 2022 08:26:47 +0200
Message-Id: <20220412062942.157057807@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit e1654f413fe08ffbc3292d8d2b8958b2cc5cb5e8 ]

We never checked for errors on add_disk() as this function
returned void. Now that this is fixed, use the shiny new
error handling.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 577c7dba5d78..946fdc1734f4 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1762,7 +1762,9 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
 	disk->fops = &nbd_fops;
 	disk->private_data = nbd;
 	sprintf(disk->disk_name, "nbd%d", index);
-	add_disk(disk);
+	err = add_disk(disk);
+	if (err)
+		goto out_err_disk;
 
 	/*
 	 * Now publish the device.
@@ -1771,6 +1773,8 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
 	nbd_total_devices++;
 	return nbd;
 
+out_err_disk:
+	blk_cleanup_disk(disk);
 out_free_idr:
 	mutex_lock(&nbd_index_mutex);
 	idr_remove(&nbd_index_idr, index);
-- 
2.35.1




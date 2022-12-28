Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A08365791E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbiL1O5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233352AbiL1O5q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:57:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC9712AAC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:57:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D61EC61553
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B75C433EF;
        Wed, 28 Dec 2022 14:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239456;
        bh=U2addjFdtshisNSgLVa56f4T+jCmby5Ax3MK2zgQy1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oCR4jxnuIx7oIbDHi2o7r5EmpyahQbYHYvqcfWVD+T5wALwQy4pO3FZwX3fQgsV8M
         k4WjG6Kz3IHOq6n/usMUi5Tgj7CQXk0isBfVz4FF+D1kvM2AZWbA4noQi/aL21BB29
         jL6gDYUqMqvs7Sq+ArW0p6ZVOf+dHKmGgDAEtlrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 228/731] drbd: remove call to memset before free device/resource/connection
Date:   Wed, 28 Dec 2022 15:35:35 +0100
Message-Id: <20221228144303.170804825@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Wang ShaoBo <bobo.shaobowang@huawei.com>

[ Upstream commit 6e7b854e4c1b02dba00760dfa79d8dbf6cce561e ]

This revert c2258ffc56f2 ("drbd: poison free'd device, resource and
connection structs"), add memset is odd here for debugging, there are
some methods to accurately show what happened, such as kdump.

Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Link: https://lore.kernel.org/r/20221124015817.2729789-2-bobo.shaobowang@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 8692814b77ca ("drbd: destroy workqueue when drbd device was freed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index f4e38c208b9f..be819f80884f 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2244,7 +2244,6 @@ void drbd_destroy_device(struct kref *kref)
 		kref_put(&peer_device->connection->kref, drbd_destroy_connection);
 		kfree(peer_device);
 	}
-	memset(device, 0xfd, sizeof(*device));
 	kfree(device);
 	kref_put(&resource->kref, drbd_destroy_resource);
 }
@@ -2336,7 +2335,6 @@ void drbd_destroy_resource(struct kref *kref)
 	idr_destroy(&resource->devices);
 	free_cpumask_var(resource->cpu_mask);
 	kfree(resource->name);
-	memset(resource, 0xf2, sizeof(*resource));
 	kfree(resource);
 }
 
@@ -2677,7 +2675,6 @@ void drbd_destroy_connection(struct kref *kref)
 	drbd_free_socket(&connection->data);
 	kfree(connection->int_dig_in);
 	kfree(connection->int_dig_vv);
-	memset(connection, 0xfc, sizeof(*connection));
 	kfree(connection);
 	kref_put(&resource->kref, drbd_destroy_resource);
 }
-- 
2.35.1




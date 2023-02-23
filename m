Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 363AC6A098B
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbjBWNIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234259AbjBWNIA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:08:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4801455C30
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:07:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2586E616ED
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB22C433D2;
        Thu, 23 Feb 2023 13:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157665;
        bh=d1xfaDcy+MagVCnP94QkBQvaUatNfXgfVuwxlr7hOEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8b97bbQHQlVVjEm9iiF36Ck4evS7C7OsR6QLeO73Ty2yguqLqmui9+AsSlGG4stp
         NE6nJ1a36Xmw2IJRoSDtJNhDqUx/GYrRK/cq7J+GOKU2cB12Dm2hnmYAumPG/Z6EdU
         k0Eet+NkAC+G+iGvbkCb+m93CFLpZjcp4fQ/VsM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Joel Stanley <joel@jms.id.au>,
        Christoph Hellwig <hch@lst.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        Wen Yang <wenyang.linux@foxmail.com>
Subject: [PATCH 5.10 18/25] Revert "Revert "block: nbd: add sanity check for first_minor""
Date:   Thu, 23 Feb 2023 14:06:35 +0100
Message-Id: <20230223130427.598666155@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130426.817998725@linuxfoundation.org>
References: <20230223130426.817998725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wenyang.linux@foxmail.com>

This reverts commit 0daa75bf750c400af0a0127fae37cd959d36dee7.

These problems such as:
https://lore.kernel.org/all/CACPK8XfUWoOHr-0RwRoYoskia4fbAbZ7DYf5wWBnv6qUnGq18w@mail.gmail.com/
It was introduced by introduced by commit b1a811633f73 ("block: nbd: add sanity check for first_minor")
and has been have been fixed by commit e4c4871a7394 ("nbd: fix max value for 'first_minor'").

Cc: Joel Stanley <joel@jms.id.au>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Pavel Skripkin <paskripkin@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Wen Yang <wenyang.linux@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/nbd.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1771,7 +1771,17 @@ static int nbd_dev_add(int index)
 	refcount_set(&nbd->refs, 1);
 	INIT_LIST_HEAD(&nbd->list);
 	disk->major = NBD_MAJOR;
+
+	/* Too big first_minor can cause duplicate creation of
+	 * sysfs files/links, since first_minor will be truncated to
+	 * byte in __device_add_disk().
+	 */
 	disk->first_minor = index << part_shift;
+	if (disk->first_minor > 0xff) {
+		err = -EINVAL;
+		goto out_free_idr;
+	}
+
 	disk->fops = &nbd_fops;
 	disk->private_data = nbd;
 	sprintf(disk->disk_name, "nbd%d", index);



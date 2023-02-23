Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5537D6A098F
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234261AbjBWNIG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234344AbjBWNIC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:08:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B670D3A8B
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:07:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FAAA615EA
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C428C433D2;
        Thu, 23 Feb 2023 13:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157670;
        bh=o/MvSD7XTSLEAyXjpthVv1oakAMjdRqXebAZP8Tyla4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aP6noMneSofe1MU0q+f4FM1DrQmX7gLu76dGbJh6WwYaxshKrSz5dseKTBekSKP9j
         lD0/zbL71LYYxFZvK8EH2CKzc7tWDNO19Ed2wpJy0Iw+/6UqXDxm3Hm5qYhTx3OPau
         Au+eOb7X8bHwD5yZd0UiVLb+mX2cVQr1hRqrAofk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yu Kuai <yukuai3@huawei.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>,
        Wen Yang <wenyang.linux@foxmail.com>
Subject: [PATCH 5.10 20/25] nbd: fix possible overflow for first_minor in nbd_dev_add()
Date:   Thu, 23 Feb 2023 14:06:37 +0100
Message-Id: <20230223130427.691761800@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130426.817998725@linuxfoundation.org>
References: <20230223130426.817998725@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

commit 940c264984fd1457918393c49674f6b39ee16506 upstream.

If 'part_shift' is not zero, then 'index << part_shift' might
overflow to a value that is not greater than '0xfffff', then sysfs
might complains about duplicate creation.

Fixes: b0d9111a2d53 ("nbd: use an idr to keep track of nbd devices")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/r/20211102015237.2309763-3-yebin10@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Wen Yang <wenyang.linux@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/nbd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1773,11 +1773,11 @@ static int nbd_dev_add(int index)
 	disk->major = NBD_MAJOR;
 
 	/* Too big first_minor can cause duplicate creation of
-	 * sysfs files/links, since MKDEV() expect that the max bits of
-	 * first_minor is 20.
+	 * sysfs files/links, since index << part_shift might overflow, or
+	 * MKDEV() expect that the max bits of first_minor is 20.
 	 */
 	disk->first_minor = index << part_shift;
-	if (disk->first_minor > MINORMASK) {
+	if (disk->first_minor < index || disk->first_minor > MINORMASK) {
 		err = -EINVAL;
 		goto out_free_idr;
 	}



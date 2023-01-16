Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C9266CA4A
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234060AbjAPRBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:01:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233961AbjAPRBD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:01:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3500B5A360
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:43:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBF0CB81071
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:43:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F781C433EF;
        Mon, 16 Jan 2023 16:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887407;
        bh=0kXwMbSk4TsFadYGIKLEPb7evQzpT9GyIsXDrwmABvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XxshulXlKoVB/nZ3omV12KhHu6jc2yzDk9bBO7dh4p2psh8GYP9zuyHX6XBut4qgx
         1qoAoERrhBkyRsl4PaYEdWBonR4M8kvdWdHf5LyVIwwpzE/yLUwau7lLRDCyI4a54x
         FvTCXfQdRZu89lsl2Osz1G9QYUrV9gzZW6L3QsS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 108/521] media: solo6x10: fix possible memory leak in solo_sysfs_init()
Date:   Mon, 16 Jan 2023 16:46:10 +0100
Message-Id: <20230116154852.090471275@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 7f5866dd96d95b74e439f6ee17b8abd8195179fb ]

If device_register() returns error in solo_sysfs_init(), the
name allocated by dev_set_name() need be freed. As comment of
device_register() says, it should use put_device() to give up
the reference in the error path. So fix this by calling
put_device(), then the name can be freed in kobject_cleanup().

Fixes: dcae5dacbce5 ("[media] solo6x10: sync to latest code from Bluecherry's git repo")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/solo6x10/solo6x10-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/solo6x10/solo6x10-core.c b/drivers/media/pci/solo6x10/solo6x10-core.c
index 19ffd2ed3cc7..d3bca099b78b 100644
--- a/drivers/media/pci/solo6x10/solo6x10-core.c
+++ b/drivers/media/pci/solo6x10/solo6x10-core.c
@@ -429,6 +429,7 @@ static int solo_sysfs_init(struct solo_dev *solo_dev)
 		     solo_dev->nr_chans);
 
 	if (device_register(dev)) {
+		put_device(dev);
 		dev->parent = NULL;
 		return -ENOMEM;
 	}
-- 
2.35.1




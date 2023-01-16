Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272DE66CA77
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234224AbjAPRDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234163AbjAPRDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:03:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA192F786
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:45:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF2E66104F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1039EC433EF;
        Mon, 16 Jan 2023 16:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887500;
        bh=z95TO89fnLiKLWmb1SFZ5etzvgdvBsEsKBgmJa9QzQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y58Lb0YFmBj5SkqucySPvBwCtxdTtEsmghY09HGHDIVFxv5XXtOBS0SI3ZiFeAxFJ
         BU8NEDX7kLs/RTDiuZ1QcqP30+sKrkL35yJRLpLrnazDZFG72mQVs+03VthmwvJlJM
         HSWuIGDxyUOCtnzF9cWljPgKtV6CL2iKVwIAzjOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liu Shixin <liushixin2@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 132/521] media: saa7164: fix missing pci_disable_device()
Date:   Mon, 16 Jan 2023 16:46:34 +0100
Message-Id: <20230116154853.161832006@linuxfoundation.org>
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

From: Liu Shixin <liushixin2@huawei.com>

[ Upstream commit 57fb35d7542384cac8f198cd1c927540ad38b61a ]

Add missing pci_disable_device() in the error path in saa7164_initdev().

Fixes: 443c1228d505 ("V4L/DVB (12923): SAA7164: Add support for the NXP SAA7164 silicon")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/saa7164/saa7164-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index 5102519df108..dba9071e8507 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -1237,7 +1237,7 @@ static int saa7164_initdev(struct pci_dev *pci_dev,
 
 	if (saa7164_dev_setup(dev) < 0) {
 		err = -EINVAL;
-		goto fail_free;
+		goto fail_dev;
 	}
 
 	/* print pci info */
@@ -1405,6 +1405,8 @@ static int saa7164_initdev(struct pci_dev *pci_dev,
 
 fail_irq:
 	saa7164_dev_unregister(dev);
+fail_dev:
+	pci_disable_device(pci_dev);
 fail_free:
 	v4l2_device_unregister(&dev->v4l2_dev);
 	kfree(dev);
-- 
2.35.1




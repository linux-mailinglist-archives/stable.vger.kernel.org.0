Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFDE5658236
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbiL1Qdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbiL1QdV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:33:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F3113F08
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:30:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E540561541
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028C8C433F0;
        Wed, 28 Dec 2022 16:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245050;
        bh=HRL0szz7m3tX6TfUqS2i3vmZRRETeIWr52yGzkEUzXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/TqCCOHpl8tdhgqjjQUUwMA1hsFjjJ6kJmbNIyEkZcT6ey8Fc3xASQQiTbKs6/VQ
         fywdhupwAj3muxce/dD5zgiRr1p+ckTeYlYEY0UUqdcygJq5dGLOloaqe2KxgZB5rV
         3wZMsxbD60hIruWiVaaB0vWIeQP67AW16rJuRlB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0748/1146] samples: vfio-mdev: Fix missing pci_disable_device() in mdpy_fb_probe()
Date:   Wed, 28 Dec 2022 15:38:07 +0100
Message-Id: <20221228144350.463732454@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit d1f0f50fbbbbca1e3e8157e51934613bf88f6d44 ]

Add missing pci_disable_device() in fail path of mdpy_fb_probe().
Besides, fix missing release functions in mdpy_fb_remove().

Fixes: cacade1946a4 ("sample: vfio mdev display - guest driver")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Link: https://lore.kernel.org/r/20221208013341.3999-1-shangxiaojing@huawei.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/vfio-mdev/mdpy-fb.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
index 9ec93d90e8a5..4eb7aa11cfbb 100644
--- a/samples/vfio-mdev/mdpy-fb.c
+++ b/samples/vfio-mdev/mdpy-fb.c
@@ -109,7 +109,7 @@ static int mdpy_fb_probe(struct pci_dev *pdev,
 
 	ret = pci_request_regions(pdev, "mdpy-fb");
 	if (ret < 0)
-		return ret;
+		goto err_disable_dev;
 
 	pci_read_config_dword(pdev, MDPY_FORMAT_OFFSET, &format);
 	pci_read_config_dword(pdev, MDPY_WIDTH_OFFSET,	&width);
@@ -191,6 +191,9 @@ static int mdpy_fb_probe(struct pci_dev *pdev,
 err_release_regions:
 	pci_release_regions(pdev);
 
+err_disable_dev:
+	pci_disable_device(pdev);
+
 	return ret;
 }
 
@@ -199,7 +202,10 @@ static void mdpy_fb_remove(struct pci_dev *pdev)
 	struct fb_info *info = pci_get_drvdata(pdev);
 
 	unregister_framebuffer(info);
+	iounmap(info->screen_base);
 	framebuffer_release(info);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
 }
 
 static struct pci_device_id mdpy_fb_pci_table[] = {
-- 
2.35.1




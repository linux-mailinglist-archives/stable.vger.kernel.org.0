Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1EFD657C93
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233433AbiL1PeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233829AbiL1PeD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:34:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2774415FFB
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:34:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3BECB81647
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E47C433EF;
        Wed, 28 Dec 2022 15:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241639;
        bh=SFPTuRawkPrLeC4Xej53eDm7pPjGgreFXTjfdwfB+Qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fBg5iJJ/ZcNLuoVpraMsNJZtFxpcV5aquVJwD08/8y3GCBAMPH8pFdIJRdQSndYPh
         LsmxbY0JR6UwogvI/0l3EFrny/QJ2dt4IyiyQurNnn4e7yLSofve8oYwWCSUO0uTGb
         yfvp9FxrxaWalnLebWsSKBrbgNxZst1uXYObCJU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 506/731] fbdev: vermilion: decrease reference count in error path
Date:   Wed, 28 Dec 2022 15:40:13 +0100
Message-Id: <20221228144311.215345629@linuxfoundation.org>
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

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit 001f2cdb952a9566c77fb4b5470cc361db5601bb ]

pci_get_device() will increase the reference count for the returned
pci_dev. For the error path, we need to use pci_dev_put() to decrease
the reference count.

Fixes: dbe7e429fedb ("vmlfb: framebuffer driver for Intel Vermilion Range")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/vermilion/vermilion.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/vermilion/vermilion.c b/drivers/video/fbdev/vermilion/vermilion.c
index ff61605b8764..a543643ce014 100644
--- a/drivers/video/fbdev/vermilion/vermilion.c
+++ b/drivers/video/fbdev/vermilion/vermilion.c
@@ -277,8 +277,10 @@ static int vmlfb_get_gpu(struct vml_par *par)
 
 	mutex_unlock(&vml_mutex);
 
-	if (pci_enable_device(par->gpu) < 0)
+	if (pci_enable_device(par->gpu) < 0) {
+		pci_dev_put(par->gpu);
 		return -ENODEV;
+	}
 
 	return 0;
 }
-- 
2.35.1




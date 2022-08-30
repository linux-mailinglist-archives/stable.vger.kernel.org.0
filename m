Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D70C5A6A8A
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbiH3Rad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbiH3RaA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:30:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D2CF8ED8;
        Tue, 30 Aug 2022 10:27:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A12EB81D2A;
        Tue, 30 Aug 2022 17:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0380EC433C1;
        Tue, 30 Aug 2022 17:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880333;
        bh=hL/0P9NZvhSOooiTe1PRQF0s5L0Ochs2JID39gpuJ3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R8Ir6aBia1VmRd74Hqm7duB79em3+co7LvP8R2osvuKnjsPyAmJ9Ejqy+ctdcghhc
         7poM7TOkh8VkOzsr6XzYJucTVgxtbRHUeVQ8Euy06jZG9uG1pz4qeT9zLZGf1s4Ueo
         oGmGLySlZJKIZrPWW4YSH/RYFjGM626Jf6+3GboEy90kRDiboL9B73k4UL9+xe2bsx
         pvwE+z5+1L5EyUnD7/quPq85zC/pBLwJ+dGZEbHO4QzYqkw+QTHACwtAxr8tyoPF3j
         7+im92ivVS+6lOJRVKwv7lPHGuXV5UwkYl6mYtTwJzg6bxyAG+xlJlGgiqEQSo11Eh
         qrLdvUSWyZZ0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        christophe.leroy@csgroup.eu, mpe@ellerman.id.au,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 11/12] fbdev: chipsfb: Add missing pci_disable_device() in chipsfb_pci_init()
Date:   Tue, 30 Aug 2022 13:24:42 -0400
Message-Id: <20220830172444.581654-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830172444.581654-1-sashal@kernel.org>
References: <20220830172444.581654-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 07c55c9803dea748d17a054000cbf1913ce06399 ]

Add missing pci_disable_device() in error path in chipsfb_pci_init().

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/chipsfb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/chipsfb.c b/drivers/video/fbdev/chipsfb.c
index 80fdd3ee0565f..57b1e011d2d34 100644
--- a/drivers/video/fbdev/chipsfb.c
+++ b/drivers/video/fbdev/chipsfb.c
@@ -430,6 +430,7 @@ static int chipsfb_pci_init(struct pci_dev *dp, const struct pci_device_id *ent)
  err_release_fb:
 	framebuffer_release(p);
  err_disable:
+	pci_disable_device(dp);
  err_out:
 	return rc;
 }
-- 
2.35.1


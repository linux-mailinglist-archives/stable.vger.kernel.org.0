Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7F15A6B8E
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 20:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiH3SAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 14:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiH3SAX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 14:00:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A8418E3B;
        Tue, 30 Aug 2022 11:00:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DC17B81D21;
        Tue, 30 Aug 2022 17:24:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B97EC433D7;
        Tue, 30 Aug 2022 17:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880270;
        bh=UyC6EuVYNPcXw2t8mig7weYbNDvzVVaZ6wLDTuTmYIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lcxianBDPHmZ9ZfzGcyfv9n/OqV5tyo0OjvHHU1npelBq9+Wr9NwKFBOB+U1D+ktr
         TB5E4iWQIDvG1yJVqcLD5/xr35TYxoGqz59vyWlDOzQIuvGv6Jr4PMwnSr8P1F7Op3
         z44i0CqcdtfIKI75MDOelZvG6RpcPpB5dRLJHxtsL/Lsk9jjLpxM/sYLDjOH5AZFaG
         MgCsF6+mgPPz3ygKs91xOGnNJ1JpwxooUVwNl3rv3c3G3UYsK1iya8qd8gjpUzs8li
         1OEt280E+twfRV528rVdf3Iis4F4EW78yDHJjfcY7wsBhtsevgmzXboLwcfe2iWBlH
         5MPrMUCCwTyeA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        christophe.leroy@csgroup.eu, mpe@ellerman.id.au,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 15/16] fbdev: chipsfb: Add missing pci_disable_device() in chipsfb_pci_init()
Date:   Tue, 30 Aug 2022 13:23:16 -0400
Message-Id: <20220830172317.581397-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830172317.581397-1-sashal@kernel.org>
References: <20220830172317.581397-1-sashal@kernel.org>
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
index 393894af26f84..2b00a9d554fc0 100644
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


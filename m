Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 617A65B747D
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236040AbiIMPYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236319AbiIMPYN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:24:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3117C1D1;
        Tue, 13 Sep 2022 07:37:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E9E9614A1;
        Tue, 13 Sep 2022 14:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A938C433D6;
        Tue, 13 Sep 2022 14:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079874;
        bh=tjMui3/sZ+L+ZhPIM7/IALO8nmLeCVVbPByfLgaGHUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IHw+Cu8Q1Gr71ARTp20ttInULCmYt1GTit4lM82aibug2aw5/F5cloQaOYfaIH0SK
         qxdnUyUId5+jjVC1yRpEdA/E3Db7Wh7wJdysl3OLlrdg9AkqGbshRhF5tRrvWENaso
         AQOUBc3euEYcfTgfiU+vH9za8ip+9Xuw1gJkZXDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 28/42] fbdev: chipsfb: Add missing pci_disable_device() in chipsfb_pci_init()
Date:   Tue, 13 Sep 2022 16:07:59 +0200
Message-Id: <20220913140343.751986286@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140342.228397194@linuxfoundation.org>
References: <20220913140342.228397194@linuxfoundation.org>
User-Agent: quilt/0.67
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
index 84a3778552eba..ec1f8af165e9e 100644
--- a/drivers/video/fbdev/chipsfb.c
+++ b/drivers/video/fbdev/chipsfb.c
@@ -432,6 +432,7 @@ static int chipsfb_pci_init(struct pci_dev *dp, const struct pci_device_id *ent)
  err_release_fb:
 	framebuffer_release(p);
  err_disable:
+	pci_disable_device(dp);
  err_out:
 	return rc;
 }
-- 
2.35.1




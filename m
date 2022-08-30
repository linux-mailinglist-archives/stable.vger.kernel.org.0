Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3DB5A6AD6
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbiH3ReU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232079AbiH3Rc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:32:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1D4C32CD;
        Tue, 30 Aug 2022 10:29:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1ED23B81CD0;
        Tue, 30 Aug 2022 17:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D195DC433C1;
        Tue, 30 Aug 2022 17:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880448;
        bh=tjMui3/sZ+L+ZhPIM7/IALO8nmLeCVVbPByfLgaGHUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CPMSQSTT8hdIGz+Ai2wkcHj9Z2X2Sm+xu6zgS/Fu9nbpqmHvnzM5awjua895w1PUb
         AAHu6piEoyB414f4hKRzzfBFhAMFqeExK0agDpGB0BeI35eJ1XqsV9mNGYQCD9cqx7
         2YXFKmc923EZoFEPzb59WSjpILE0AXPpYYp6YN8Jzrek4sOmIBX1t6JxAtPeHlPg6N
         8N4SCtQOrUCmsXcvizmuecOdnbV0n7jHvi9gQ7U841vUp6cyB5h1DK9VKe0Nrgipez
         7q0m/5hstdOhdv4ZEnI6JZhXxI6fNqYOUUluEyli7rrsB4vbsnJxpgK4DQLvzA9sDx
         57jx09HjSy2Kg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        christophe.leroy@csgroup.eu, mpe@ellerman.id.au,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.9 6/6] fbdev: chipsfb: Add missing pci_disable_device() in chipsfb_pci_init()
Date:   Tue, 30 Aug 2022 13:27:06 -0400
Message-Id: <20220830172706.582088-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830172706.582088-1-sashal@kernel.org>
References: <20220830172706.582088-1-sashal@kernel.org>
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


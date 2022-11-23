Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A726355FB
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237505AbiKWJ0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237678AbiKWJZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:25:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B114D205D7
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:24:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 315F861B40
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F8BC433D7;
        Wed, 23 Nov 2022 09:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195479;
        bh=lSh7dWGbiTy18SerLpyw2sdeqDmywC414TJRby9OZEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zeBlKPiyITjmTvTcuAk8rlZHBxiEdsCT8DMJhqeYcLeMzqZLtzVxCofHhbi9CLcSy
         IQTN9INAGdtK9ZkiWTNoLnYFyItmiI6bDpz/jG0F6gSHwEocPD4+HOWsaxNYiC5FIz
         RKxPpCwwmzDCN7uqn1vLVZgEQCGeSjx91jTdPY8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/149] mISDN: fix possible memory leak in mISDN_dsp_element_register()
Date:   Wed, 23 Nov 2022 09:50:47 +0100
Message-Id: <20221123084600.224188113@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
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

[ Upstream commit 98a2ac1ca8fd6eca6867726fe238d06e75eb1acd ]

Afer commit 1fa5ae857bb1 ("driver core: get rid of struct device's
bus_id string array"), the name of device is allocated dynamically,
use put_device() to give up the reference, so that the name can be
freed in kobject_cleanup() when the refcount is 0.

The 'entry' is going to be freed in mISDN_dsp_dev_release(), so the
kfree() is removed. list_del() is called in mISDN_dsp_dev_release(),
so it need be initialized.

Fixes: 1fa5ae857bb1 ("driver core: get rid of struct device's bus_id string array")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221109132832.3270119-1-yangyingliang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/mISDN/dsp_pipeline.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/isdn/mISDN/dsp_pipeline.c b/drivers/isdn/mISDN/dsp_pipeline.c
index c3b2c99b5cd5..cfbcd9e973c2 100644
--- a/drivers/isdn/mISDN/dsp_pipeline.c
+++ b/drivers/isdn/mISDN/dsp_pipeline.c
@@ -77,6 +77,7 @@ int mISDN_dsp_element_register(struct mISDN_dsp_element *elem)
 	if (!entry)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&entry->list);
 	entry->elem = elem;
 
 	entry->dev.class = elements_class;
@@ -107,7 +108,7 @@ int mISDN_dsp_element_register(struct mISDN_dsp_element *elem)
 	device_unregister(&entry->dev);
 	return ret;
 err1:
-	kfree(entry);
+	put_device(&entry->dev);
 	return ret;
 }
 EXPORT_SYMBOL(mISDN_dsp_element_register);
-- 
2.35.1




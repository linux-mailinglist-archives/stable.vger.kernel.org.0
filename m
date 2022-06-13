Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F71548856
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377501AbiFMNc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378060AbiFMNau (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:30:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8BD241;
        Mon, 13 Jun 2022 04:25:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12144B80EB6;
        Mon, 13 Jun 2022 11:25:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B61C34114;
        Mon, 13 Jun 2022 11:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119528;
        bh=Ag5ss0LGA89ufCYoaNA2Cd4xvnIBH+rHrF/uUkOMu0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lA9wvNT3ED2VIgKmBvc2wzkLGX3RWGa3kdPFhZfOfDtNGxPvL/v/AOXexkuzCqusI
         ENsdMac6CQPAwtYj7GDrj2h0BmzDYmZfNj9mw0+jo5/p28k69gdqx//EjpQK4B+tgp
         FqB4tGpS6oao/+vAc5eZlBlcJrUqddJFGqAFj3DM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Yongjun <zhengyongjun3@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 026/339] usb: dwc3: pci: Fix pm_runtime_get_sync() error checking
Date:   Mon, 13 Jun 2022 12:07:31 +0200
Message-Id: <20220613094927.303914756@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit a03e2ddab8e735e2cc315609b297b300e9cc60d2 ]

If the device is already in a runtime PM enabled state
pm_runtime_get_sync() will return 1, so a test for negative
value should be used to check for errors.

Fixes: 8eed00b237a28 ("usb: dwc3: pci: Runtime resume child device from wq")
Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Link: https://lore.kernel.org/r/20220422062652.10575-1-zhengyongjun3@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 2e19e0e4ea53..ba51de7dd760 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -288,7 +288,7 @@ static void dwc3_pci_resume_work(struct work_struct *work)
 	int ret;
 
 	ret = pm_runtime_get_sync(&dwc3->dev);
-	if (ret) {
+	if (ret < 0) {
 		pm_runtime_put_sync_autosuspend(&dwc3->dev);
 		return;
 	}
-- 
2.35.1




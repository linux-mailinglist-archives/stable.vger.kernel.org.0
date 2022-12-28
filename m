Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5344A657F7B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbiL1QFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:05:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiL1QFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:05:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A521902A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:05:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB22AB81719
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C90FC433D2;
        Wed, 28 Dec 2022 16:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243517;
        bh=/UY257NmbrzbEjPLlv4DpVUh4oKX7pRmTV9Kiqeb/Hk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v2aGdH9nokmeljYkmkl2agHUPTMfHqwsFXKZYivH58H8MkGVo6CK/iJJJnR3w6/D0
         K6tlNqRu8zWeKZ8R924uzxLjweH5AyGAOgpUgmiwJjirMpQ0xtnHAT+jxoLQR/hCdx
         erJ2yxWk0i2ZktzDjrzrH3aoqDwBSxsY1Zkte4K0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0538/1073] Bluetooth: hci_core: fix error handling in hci_register_dev()
Date:   Wed, 28 Dec 2022 15:35:26 +0100
Message-Id: <20221228144342.667150456@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 0d75da38e060d21f948b3df5f5e349c962cf1ed2 ]

If hci_register_suspend_notifier() returns error, the hdev and rfkill
are leaked. We could disregard the error and print a warning message
instead to avoid leaks, as it just means we won't be handing suspend
requests.

Fixes: 9952d90ea288 ("Bluetooth: Handle PM_SUSPEND_PREPARE and PM_POST_SUSPEND")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index c8ea03edd081..995d950872af 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2653,7 +2653,7 @@ int hci_register_dev(struct hci_dev *hdev)
 
 	error = hci_register_suspend_notifier(hdev);
 	if (error)
-		goto err_wqueue;
+		BT_WARN("register suspend notifier failed error:%d\n", error);
 
 	queue_work(hdev->req_workqueue, &hdev->power_on);
 
-- 
2.35.1




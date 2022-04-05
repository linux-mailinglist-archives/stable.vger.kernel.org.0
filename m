Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF554F3805
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359844AbiDELVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349306AbiDEJtg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45CBFC25;
        Tue,  5 Apr 2022 02:43:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08A52B818F3;
        Tue,  5 Apr 2022 09:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6798DC385A2;
        Tue,  5 Apr 2022 09:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151828;
        bh=v3JF/BNyYc42Tn3GEZ1YJSBj9rcJ3PoyEg98ZcKHGR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IIHq2FX/b/djjP/dtpxNbcc25QvZBShXrRKLWz0x6fIrKsN17dgKZoSNSAmTz54WN
         1o1PpeH7F2aUVJyzKfahX4EpzHPDv7uSDnb3ZYbew6nXBvXYcGOuCPto2KFlpTG6ec
         BN9Dw1gS/LtHAfrSttbgwJu2hSNZZV7Te4ct/L94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b9bd12fbed3485a3e51f@syzkaller.appspotmail.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 556/913] Bluetooth: hci_uart: add missing NULL check in h5_enqueue
Date:   Tue,  5 Apr 2022 09:26:58 +0200
Message-Id: <20220405070356.512876285@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 32cb08e958696908a9aad5e49a78d74f7e32fffb ]

Syzbot hit general protection fault in __pm_runtime_resume(). The problem
was in missing NULL check.

hu->serdev can be NULL and we should not blindly pass &serdev->dev
somewhere, since it will cause GPF.

Reported-by: syzbot+b9bd12fbed3485a3e51f@syzkaller.appspotmail.com
Fixes: d9dd833cf6d2 ("Bluetooth: hci_h5: Add runtime suspend")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_h5.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index d49a39d17d7d..e0ea9d25bb39 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -629,9 +629,11 @@ static int h5_enqueue(struct hci_uart *hu, struct sk_buff *skb)
 		break;
 	}
 
-	pm_runtime_get_sync(&hu->serdev->dev);
-	pm_runtime_mark_last_busy(&hu->serdev->dev);
-	pm_runtime_put_autosuspend(&hu->serdev->dev);
+	if (hu->serdev) {
+		pm_runtime_get_sync(&hu->serdev->dev);
+		pm_runtime_mark_last_busy(&hu->serdev->dev);
+		pm_runtime_put_autosuspend(&hu->serdev->dev);
+	}
 
 	return 0;
 }
-- 
2.34.1




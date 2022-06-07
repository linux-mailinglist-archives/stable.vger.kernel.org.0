Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B3B540C27
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351854AbiFGSeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353113AbiFGSbn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:31:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBAD517D3A7;
        Tue,  7 Jun 2022 10:56:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41D8C611FE;
        Tue,  7 Jun 2022 17:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA862C36AFF;
        Tue,  7 Jun 2022 17:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624610;
        bh=H/ojBjv8RedJ1tRhj7i5pR0yqtBqO8nR4KB/LsnXy2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XlUlHJEtG1KKfJzold6SoQ2872pBnMVeP3HPdBdh8fPzheUyflg1mjD1/FTIJL5c/
         /xIdLeHtx19oTtWBvteKEhVV4Tw3MxCGrx/EiaurPG4O9OhuXO39mJMW9wi7Pb5nPn
         z9E3rNpEPUVyvSkHlykXNZ/FFNMicPK3NrCZj5j4XUc5j11pQPxqgi8ZXgASQ3Kc+K
         IPVCoX52ORZxbeOmcb3I/u42m+4aMWAg3kptV9wzVFljqgPXZY7+uUsGaaU+Xa2eUv
         +R15QXfsMzThyOwpxx1YiGcUn5jUmIAhXYKnZeQpjNQdosOlB1uIKbLmgIdceZUXZ2
         mfeA/1AWbFxgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangyu Hua <hbh25y@gmail.com>,
        Eli Billauer <eli.billauer@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.15 16/51] char: xillybus: fix a refcount leak in cleanup_dev()
Date:   Tue,  7 Jun 2022 13:55:15 -0400
Message-Id: <20220607175552.479948-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175552.479948-1-sashal@kernel.org>
References: <20220607175552.479948-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit b67d19662fdee275c479d21853bc1239600a798f ]

usb_get_dev is called in xillyusb_probe. So it is better to call
usb_put_dev before xdev is released.

Acked-by: Eli Billauer <eli.billauer@gmail.com>
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Link: https://lore.kernel.org/r/20220406075703.23464-1-hbh25y@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/xillybus/xillyusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/xillybus/xillyusb.c b/drivers/char/xillybus/xillyusb.c
index dc3551796e5e..39bcbfd908b4 100644
--- a/drivers/char/xillybus/xillyusb.c
+++ b/drivers/char/xillybus/xillyusb.c
@@ -549,6 +549,7 @@ static void cleanup_dev(struct kref *kref)
 	if (xdev->workq)
 		destroy_workqueue(xdev->workq);
 
+	usb_put_dev(xdev->udev);
 	kfree(xdev->channels); /* Argument may be NULL, and that's fine */
 	kfree(xdev);
 }
-- 
2.35.1


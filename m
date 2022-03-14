Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 921034D8395
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239501AbiCNMRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236182AbiCNMQZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:16:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91CA344EA;
        Mon, 14 Mar 2022 05:12:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A81AF612FC;
        Mon, 14 Mar 2022 12:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E99C340EC;
        Mon, 14 Mar 2022 12:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259926;
        bh=KDeKeSrBscd88xlJvU6ol2p8TedSnBm20d6bP+U4DyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xxaxujiSePbL/tNqY5cMiCBobGZIRmdb12pAgCrqSOebgF4udM4ekFReHk2g50YST
         yFkSV0XPLcGmfOeda3WyFhpa6TJmWlFyaBpXf7KAP6hR2LKFJlM2W+/3VQy68uC/yy
         wV3EXltK/D5CR+bj6QTs9PqHFhapSCoXglNxFSeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Silvan Jegen <s.jegen@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 010/121] HID: nintendo: check the return value of alloc_workqueue()
Date:   Mon, 14 Mar 2022 12:53:13 +0100
Message-Id: <20220314112744.413091251@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit fe23b6bbeac40de957724b90a88d46fb336e29a9 ]

The function alloc_workqueue() in nintendo_hid_probe() can fail, but
there is no check of its return value. To fix this bug, its return value
should be checked with new error handling code.

Fixes: c4eae84feff3e ("HID: nintendo: add rumble support")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Reviewed-by: Silvan Jegen <s.jegen@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-nintendo.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/hid-nintendo.c b/drivers/hid/hid-nintendo.c
index b6a9a0f3966e..2204de889739 100644
--- a/drivers/hid/hid-nintendo.c
+++ b/drivers/hid/hid-nintendo.c
@@ -2128,6 +2128,10 @@ static int nintendo_hid_probe(struct hid_device *hdev,
 	spin_lock_init(&ctlr->lock);
 	ctlr->rumble_queue = alloc_workqueue("hid-nintendo-rumble_wq",
 					     WQ_FREEZABLE | WQ_MEM_RECLAIM, 0);
+	if (!ctlr->rumble_queue) {
+		ret = -ENOMEM;
+		goto err;
+	}
 	INIT_WORK(&ctlr->rumble_worker, joycon_rumble_worker);
 
 	ret = hid_parse(hdev);
-- 
2.34.1




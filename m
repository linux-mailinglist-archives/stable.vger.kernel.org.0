Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACAA966CAD3
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234211AbjAPRIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234241AbjAPRHn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:07:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF054521E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:48:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DA89B8108F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80160C433EF;
        Mon, 16 Jan 2023 16:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887691;
        bh=zDSe1fCpW15JHXVl1zLrWCJragmwvt3ZJ5ExCkqDhlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K2+eZY8x69IwUR0g4dWMgYyt4bUJloCOnJFgKuCvHNm50J1lQ7/TywE/77wrk7VY/
         3di7K5QDEehHB2Eg2vQYU+wecYp9wP2O9PIWjm/62r7qHiessntUI780yRZ0lYj2os
         DnhRUuq1ktHvVq98vapzCp4TEjDDQL199XXLooT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 246/521] vme: Fix error not catched in fake_init()
Date:   Mon, 16 Jan 2023 16:48:28 +0100
Message-Id: <20230116154858.134960121@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit 7bef797d707f1744f71156b21d41e3b8c946631f ]

In fake_init(), __root_device_register() is possible to fail but it's
ignored, which can cause unregistering vme_root fail when exit.

 general protection fault,
 probably for non-canonical address 0xdffffc000000008c
 KASAN: null-ptr-deref in range [0x0000000000000460-0x0000000000000467]
 RIP: 0010:root_device_unregister+0x26/0x60
 Call Trace:
  <TASK>
  __x64_sys_delete_module+0x34f/0x540
  do_syscall_64+0x38/0x90
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

Return error when __root_device_register() fails.

Fixes: 658bcdae9c67 ("vme: Adding Fake VME driver")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Link: https://lore.kernel.org/r/20221205084805.147436-1-chenzhongjin@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vme/bridges/vme_fake.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vme/bridges/vme_fake.c b/drivers/vme/bridges/vme_fake.c
index 685a43bdc2a1..06bfc7f0e0b6 100644
--- a/drivers/vme/bridges/vme_fake.c
+++ b/drivers/vme/bridges/vme_fake.c
@@ -1077,6 +1077,8 @@ static int __init fake_init(void)
 
 	/* We need a fake parent device */
 	vme_root = __root_device_register("vme", THIS_MODULE);
+	if (IS_ERR(vme_root))
+		return PTR_ERR(vme_root);
 
 	/* If we want to support more than one bridge at some point, we need to
 	 * dynamically allocate this so we get one per device.
-- 
2.35.1




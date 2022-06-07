Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADED540A6A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351798AbiFGSUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352053AbiFGSQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:16:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A1F71A31;
        Tue,  7 Jun 2022 10:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B1976159C;
        Tue,  7 Jun 2022 17:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1351AC341C4;
        Tue,  7 Jun 2022 17:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624218;
        bh=H/ojBjv8RedJ1tRhj7i5pR0yqtBqO8nR4KB/LsnXy2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VoxjbqSGP974L+niTK+6OS/6nhnJGnyZNptbaWapcg3BgajAEaTWW1xZ0ScNE+u4A
         y/916y001GXtUKNNJERngq7aE3jtlGBIVMdSMSKdajC4raQ1BK+gTtmTOjFYRhIUoB
         7KMo3bMt4JUASc5vPmVX1L62a5yICa0k7WRGCOplBv1gMTmwXk634+ofCp/M2iv7AZ
         4wHaxrnc4JsOswdbj2SJISe4QtFDuzG1lySRtKsMk/oA4FF20kqaHHNmRMcsnhm8zC
         7rIBNzrpzCAcdvLfVR5SerMzbfQD8puq3/c/31+oW2mMWhvmvKWRxO80q5jdp5L4Wm
         FV//86/kUhH9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangyu Hua <hbh25y@gmail.com>,
        Eli Billauer <eli.billauer@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.18 17/68] char: xillybus: fix a refcount leak in cleanup_dev()
Date:   Tue,  7 Jun 2022 13:47:43 -0400
Message-Id: <20220607174846.477972-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607174846.477972-1-sashal@kernel.org>
References: <20220607174846.477972-1-sashal@kernel.org>
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


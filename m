Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36075540AD8
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350946AbiFGSYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352136AbiFGSUu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:20:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250F823BE9;
        Tue,  7 Jun 2022 10:53:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4126617A5;
        Tue,  7 Jun 2022 17:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4ECC36B00;
        Tue,  7 Jun 2022 17:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624427;
        bh=H/ojBjv8RedJ1tRhj7i5pR0yqtBqO8nR4KB/LsnXy2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ca1VytFutja0JqZ/VCGPPZa6M13aKaZLNZv5EPORhzqseaQpUPiIy35hzw73bj8r/
         ssmnkSHWvNMmer6ZUi8bqj3vjHQpF0fdUquiin6Mg/lgwgYr+ku2lRgba1pARxn/vZ
         eDxYRkYdWwTIFqLpo6VX/HZTAhNa2/mAy7G/IQcoW+wsDX1wU6O3CExOMzKIcka9z1
         kuW/e9Z2qtrwRRgu8lQ4Nu6jsiMnPcr9YBqxq6F14pP4fwugnbh9KQcstximPfS/XI
         eFPiX0ImjdSgALK0PQeQojubJTmOE4C6ohrSTe0i6HGzn3NQzDVAYN79x4LN3VG1Ki
         9HEqsQq4qKPxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangyu Hua <hbh25y@gmail.com>,
        Eli Billauer <eli.billauer@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.17 16/60] char: xillybus: fix a refcount leak in cleanup_dev()
Date:   Tue,  7 Jun 2022 13:52:13 -0400
Message-Id: <20220607175259.478835-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175259.478835-1-sashal@kernel.org>
References: <20220607175259.478835-1-sashal@kernel.org>
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


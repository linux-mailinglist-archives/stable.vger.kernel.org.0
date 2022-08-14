Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C672A59221A
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241359AbiHNPnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiHNPmR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:42:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FB31C11E;
        Sun, 14 Aug 2022 08:33:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BCA9B80B56;
        Sun, 14 Aug 2022 15:33:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A549C433D6;
        Sun, 14 Aug 2022 15:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491215;
        bh=QwleLkPpMUtNrPJ2hpugjtXEVqvUzO1wsjJ02z4FvRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0bRmdoI39bRYMLHM0YkUB8cWZ6FPRe6uqfwQ6FrlunRaCtLroV4Ho5VY0tHfFumY
         dGIdvg0PoWaFN92L0n43ZTxLd+Qx9t9lzsLJx2FdlRUoTyi7ZmhcRVrrCX9VzE6QjW
         3M6hbdylH5WpZt1PrP66YhmwR6dMpsOLVtKoGg602P3iccIXVf4kPYNZ0fWKsXPyX4
         Ij89hFcPCHSDGVUkhNv2vPkowGSv+MgspJVQcFoIUsQDH7ca8fM4wZxHk5eWVZS+r1
         b0IxyyW9qkXh39FyjoKCw6Kxras5Febx37/UqLecY3dTGQc2e1gX7pxJN7zaiSIw4d
         0PkypofrmbZhg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jozef Martiniak <jomajm@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, balbi@kernel.org,
        stern@rowland.harvard.edu, axboe@kernel.dk, hbh25y@gmail.com,
        mingo@kernel.org, rdunlap@infradead.org, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 23/46] gadgetfs: ep_io - wait until IRQ finishes
Date:   Sun, 14 Aug 2022 11:32:24 -0400
Message-Id: <20220814153247.2378312-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153247.2378312-1-sashal@kernel.org>
References: <20220814153247.2378312-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jozef Martiniak <jomajm@gmail.com>

[ Upstream commit 04cb742d4d8f30dc2e83b46ac317eec09191c68e ]

after usb_ep_queue() if wait_for_completion_interruptible() is
interrupted we need to wait until IRQ gets finished.

Otherwise complete() from epio_complete() can corrupt stack.

Signed-off-by: Jozef Martiniak <jomajm@gmail.com>
Link: https://lore.kernel.org/r/20220708070645.6130-1-jomajm@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/legacy/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index 3279b4767424..9e8b678f0548 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -362,6 +362,7 @@ ep_io (struct ep_data *epdata, void *buf, unsigned len)
 				spin_unlock_irq (&epdata->dev->lock);
 
 				DBG (epdata->dev, "endpoint gone\n");
+				wait_for_completion(&done);
 				epdata->status = -ENODEV;
 			}
 		}
-- 
2.35.1


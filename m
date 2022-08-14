Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53787592323
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242138AbiHNPxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242014AbiHNPuz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:50:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF88F18B0E;
        Sun, 14 Aug 2022 08:36:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4786A60DD3;
        Sun, 14 Aug 2022 15:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1C0C433C1;
        Sun, 14 Aug 2022 15:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491385;
        bh=VNknJr8nYr0dzeiUWFTgY649fGVvL9DKEOfXsU2hyI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8GRLhZLn8UE4cRTFzTnTFGj8/Rd6BF0pCOd3yEQOYgKgetcPEXkO3DdwM97DdZNh
         9fT1zPnF8iIXdeznh9E+YRP76EGViE3fIxGVAR1PPsiqM0OBf9HAC0s7VnsFZ89Q8u
         EH6tNp3vzrHtvcyyQqBwrxr48w5XFrUlPjVZMBEkNA8X0sgFm0dRwwy0aeX07yN9Uo
         eHS1iUTf8ZamNvWn0OZ1EF435t7cVU/1IgLddWkQ0NuGizk71ubXKX21RSqaPiWdnm
         zcGI/Dkbo1hFbG9HrWBlR8TODX4xyInGzViugAglROyTtXWmwiPOXeWVV4Gn/ySSKD
         GFMcxrn8CjNaA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jozef Martiniak <jomajm@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, balbi@kernel.org,
        stern@rowland.harvard.edu, hbh25y@gmail.com, axboe@kernel.dk,
        djwong@kernel.org, rdunlap@infradead.org, mingo@kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/13] gadgetfs: ep_io - wait until IRQ finishes
Date:   Sun, 14 Aug 2022 11:36:04 -0400
Message-Id: <20220814153610.2380234-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153610.2380234-1-sashal@kernel.org>
References: <20220814153610.2380234-1-sashal@kernel.org>
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
index 3ebcbd199a79..b0a2b8805f41 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -361,6 +361,7 @@ ep_io (struct ep_data *epdata, void *buf, unsigned len)
 				spin_unlock_irq (&epdata->dev->lock);
 
 				DBG (epdata->dev, "endpoint gone\n");
+				wait_for_completion(&done);
 				epdata->status = -ENODEV;
 			}
 		}
-- 
2.35.1


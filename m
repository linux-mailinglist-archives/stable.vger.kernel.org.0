Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4BE59DC40
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352974AbiHWKMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352555AbiHWKJk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:09:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 013C37DF6C;
        Tue, 23 Aug 2022 01:55:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 924C16155E;
        Tue, 23 Aug 2022 08:55:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9729EC433D6;
        Tue, 23 Aug 2022 08:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244948;
        bh=2IANWfcDXn8gdk1Z4gv51ItWI+UvkHS6CpqklXgJFeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HVHvHTDwPpUwJrQeq0MmZbPc9f+4Zz0GEzkb1MsrIAIl/QNh/wIYMeVUkrn6gZZPo
         GrWdhDRCNq15ibtqiI6XwCqrUHF8nZxexW0DO8sSUZHwDO1A6a9OOWlowbW5le61XR
         trEuAW2Sbl+1L1kZtMefQmc0fBUZLL9XMZNnupc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jozef Martiniak <jomajm@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 216/229] gadgetfs: ep_io - wait until IRQ finishes
Date:   Tue, 23 Aug 2022 10:26:17 +0200
Message-Id: <20220823080101.366251007@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
User-Agent: quilt/0.67
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
index 53d17e1bb65a..f0f41cc8b2f1 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -365,6 +365,7 @@ ep_io (struct ep_data *epdata, void *buf, unsigned len)
 				spin_unlock_irq (&epdata->dev->lock);
 
 				DBG (epdata->dev, "endpoint gone\n");
+				wait_for_completion(&done);
 				epdata->status = -ENODEV;
 			}
 		}
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4A16CC335
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbjC1OwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233317AbjC1Ovv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:51:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A790DD510
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:51:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45909617F1
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D23C4339B;
        Tue, 28 Mar 2023 14:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015099;
        bh=58zc0AzHfesSx+M9pKNJIvOAgE7ILLowXaKun9ELkcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S7q/Sh72Rui7Sw/j0sS4P7uN+ojQXJ8rU58/gEBzJGOSyXqe/iSoclhgeV7cTPkK8
         JLHuXscMFJJYIXJq9NeIzPb0tfeSVY5jJVtwRn9L5rZoT7cIzKCZtKnNUDz8COL1Pn
         F6dtCU1Ep3d08NnH5+X30vHR74jY+laJ+3wqW3Fs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Danny Kaehn <kaehndan@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 134/240] HID: cp2112: Fix driver not registering GPIO IRQ chip as threaded
Date:   Tue, 28 Mar 2023 16:41:37 +0200
Message-Id: <20230328142625.355176892@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Danny Kaehn <kaehndan@gmail.com>

[ Upstream commit 37f5b858a66543b2b67c0288280af623985abc29 ]

The CP2112 generates interrupts from a polling routine on a thread,
and can only support threaded interrupts. This patch configures the
gpiochip irq chip with this flag, disallowing consumers to request
a hard IRQ from this driver, which resulted in a segfault previously.

Signed-off-by: Danny Kaehn <kaehndan@gmail.com>
Link: https://lore.kernel.org/r/20230210170044.11835-1-kaehndan@gmail.com
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-cp2112.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-cp2112.c b/drivers/hid/hid-cp2112.c
index 1e16b0fa310d1..27cadadda7c9d 100644
--- a/drivers/hid/hid-cp2112.c
+++ b/drivers/hid/hid-cp2112.c
@@ -1354,6 +1354,7 @@ static int cp2112_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	girq->parents = NULL;
 	girq->default_type = IRQ_TYPE_NONE;
 	girq->handler = handle_simple_irq;
+	girq->threaded = true;
 
 	ret = gpiochip_add_data(&dev->gc, dev);
 	if (ret < 0) {
-- 
2.39.2




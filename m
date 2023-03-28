Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5317B6CC4E5
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbjC1PKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbjC1PK0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:10:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA78AD3B
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:09:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61BD461866
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9CAC433D2;
        Tue, 28 Mar 2023 15:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016158;
        bh=P4CzGikgM7jVUFgJYP7iZJQTknwuEyOTArmUon2XDVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1UBWdIowDqzyM0wEo1O9w9QzgAzvDVtNYe3iU282F/HB3iNCWepTV27JKVl8h1iNP
         GSWuGqH3PgZYOclYufTB3gxZFN1l/aLqbDU2P9RRZMJAwSrJzyhQBuo/5OCXziC7XI
         M/kvbzXujqjejRGwXsjkN+hfULmZCqAUhSKlYkgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Danny Kaehn <kaehndan@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/146] HID: cp2112: Fix driver not registering GPIO IRQ chip as threaded
Date:   Tue, 28 Mar 2023 16:42:55 +0200
Message-Id: <20230328142606.272190043@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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
index 172f20e88c6c9..d902fe43cb818 100644
--- a/drivers/hid/hid-cp2112.c
+++ b/drivers/hid/hid-cp2112.c
@@ -1352,6 +1352,7 @@ static int cp2112_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	girq->parents = NULL;
 	girq->default_type = IRQ_TYPE_NONE;
 	girq->handler = handle_simple_irq;
+	girq->threaded = true;
 
 	ret = gpiochip_add_data(&dev->gc, dev);
 	if (ret < 0) {
-- 
2.39.2




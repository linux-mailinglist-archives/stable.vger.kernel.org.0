Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B36C6C07A3
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 02:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjCTBAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 21:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbjCTA7L (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 20:59:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D454519690;
        Sun, 19 Mar 2023 17:56:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6216611EE;
        Mon, 20 Mar 2023 00:56:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F775C433A1;
        Mon, 20 Mar 2023 00:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273763;
        bh=P4CzGikgM7jVUFgJYP7iZJQTknwuEyOTArmUon2XDVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CvXZ7B9lnwLOjFKofHeSwbx3eKUfQNUlBKAt4uXY7Gs4jYtrxo3nJkQjsEG5ba3a/
         6bBFHopPE97c7TkUnYJdavbwwH0fZPqGiAvXo4OPprIFQJojOLNpETkkvREdFJoXhT
         tjrj/SFk+oV5KWqtsdAPuEpOVUShrun3dW2hj6qMth/njhJgz2ntOU2hoMk2HvgvFb
         IoQNF+tgOQjfxoNB4WMIQ2fFhdrlvLzQOnmyoKCeQumZGOzdo5lBMOKdgxcdqmKJSA
         /8fomuIh2D5RSB3Na5b9B3OTIYAHPgKkJNNQD8/R0rA6QMlc6qwwfx7DQDl8WG2G48
         dWNjVIcFhcs1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Danny Kaehn <kaehndan@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>, jikos@kernel.org,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 02/15] HID: cp2112: Fix driver not registering GPIO IRQ chip as threaded
Date:   Sun, 19 Mar 2023 20:55:46 -0400
Message-Id: <20230320005559.1429040-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005559.1429040-1-sashal@kernel.org>
References: <20230320005559.1429040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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


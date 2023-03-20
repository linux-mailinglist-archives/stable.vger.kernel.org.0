Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFB26C077F
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 01:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjCTA6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 20:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbjCTA52 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 20:57:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE26420551;
        Sun, 19 Mar 2023 17:55:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DABCB80D4A;
        Mon, 20 Mar 2023 00:54:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B95C4339C;
        Mon, 20 Mar 2023 00:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273658;
        bh=58zc0AzHfesSx+M9pKNJIvOAgE7ILLowXaKun9ELkcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D4m/TC/4wWhp4S4p/ZLZlVj/fvQ/PCI0DYZt6NqDVjyH3/LrGF7f5Fndd6R9bxrGi
         E9Sl9Pf0CHsJxqmqKja9R58IxI83sh1KdQuBMRpyFDpJmJ8VC4fvJY9DrMMgCEZugU
         kaa93qTs99ou+juVPw8DZgnciU4g0DECsjYDG72Xe4Z2L/1hWpFaV7/PE7gQ+YIho3
         krOUnzjmfhcl+8MjtrZXKjGBh07Mcwz1CPiDar8oVi6rtkSmN19l5ap6SfOljhcnKr
         1+jDAzG/68BBGW333J2QGrQk2WUk3gU8mxHPjatTfCZ+Y3TQUk1gP+DiMjQvbsMK2A
         fNYch7P+TTxfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Danny Kaehn <kaehndan@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>, jikos@kernel.org,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 02/29] HID: cp2112: Fix driver not registering GPIO IRQ chip as threaded
Date:   Sun, 19 Mar 2023 20:53:44 -0400
Message-Id: <20230320005413.1428452-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005413.1428452-1-sashal@kernel.org>
References: <20230320005413.1428452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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


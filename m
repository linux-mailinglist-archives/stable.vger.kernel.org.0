Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8844F70F5
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238493AbiDGBX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238588AbiDGBSY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:18:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC591890C8;
        Wed,  6 Apr 2022 18:13:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BE4DBCE2519;
        Thu,  7 Apr 2022 01:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AAD0C385A3;
        Thu,  7 Apr 2022 01:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649293992;
        bh=ZxERjJN2xL45S6oKLKU5GRaDVAklc6MvrPJF7AQQpm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BuUwWpNvGZCOiIuFzWFHkmFwDwbsu87SKO7tNWnOTQR9pwQXLbckUaCzSo9df7/gS
         jdTXBqr56OApPOJD4gStEiVt0Y3NJ9lpBY/kZBfbzzNahbx4wC1XeWKkA6PiSMNRXe
         ltxZOFN9yaNP5yIo4m/HNu44XbSIGxjJmCX3it+3Gk5dpDQ9ItUlkKWuuRHKnxfBXt
         CSNLjw1T6DjwlyRap6KhcGMl1d9o1EzxC0NnMxrAEP+mfDZ7RdiqU6yBRJjOx6ZiDd
         rcLhHWYa4ZUM5KI7m9BNDJSYSn9V9NweMgdb4cBf4aHNLQPESsI/zdu5vfuocYOqw1
         y/YlLTFu1XcMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff LaBundy <jeff@labundy.com>,
        =?UTF-8?q?Tomasz=20Mo=C5=84?= <tomasz.mon@camlingroup.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 06/27] Input: add bounds checking to input_set_capability()
Date:   Wed,  6 Apr 2022 21:12:36 -0400
Message-Id: <20220407011257.114287-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011257.114287-1-sashal@kernel.org>
References: <20220407011257.114287-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Jeff LaBundy <jeff@labundy.com>

[ Upstream commit 409353cbe9fe48f6bc196114c442b1cff05a39bc ]

Update input_set_capability() to prevent kernel panic in case the
event code exceeds the bitmap for the given event type.

Suggested-by: Tomasz Moń <tomasz.mon@camlingroup.com>
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Reviewed-by: Tomasz Moń <tomasz.mon@camlingroup.com>
Link: https://lore.kernel.org/r/20220320032537.545250-1-jeff@labundy.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/input.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index c3139bc2aa0d..42099c8c417c 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -47,6 +47,17 @@ static DEFINE_MUTEX(input_mutex);
 
 static const struct input_value input_value_sync = { EV_SYN, SYN_REPORT, 1 };
 
+static const unsigned int input_max_code[EV_CNT] = {
+	[EV_KEY] = KEY_MAX,
+	[EV_REL] = REL_MAX,
+	[EV_ABS] = ABS_MAX,
+	[EV_MSC] = MSC_MAX,
+	[EV_SW] = SW_MAX,
+	[EV_LED] = LED_MAX,
+	[EV_SND] = SND_MAX,
+	[EV_FF] = FF_MAX,
+};
+
 static inline int is_event_supported(unsigned int code,
 				     unsigned long *bm, unsigned int max)
 {
@@ -2074,6 +2085,14 @@ EXPORT_SYMBOL(input_get_timestamp);
  */
 void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int code)
 {
+	if (type < EV_CNT && input_max_code[type] &&
+	    code > input_max_code[type]) {
+		pr_err("%s: invalid code %u for type %u\n", __func__, code,
+		       type);
+		dump_stack();
+		return;
+	}
+
 	switch (type) {
 	case EV_KEY:
 		__set_bit(code, dev->keybit);
-- 
2.35.1


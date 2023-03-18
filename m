Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC82E6BFB33
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 16:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjCRPZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 11:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjCRPZf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 11:25:35 -0400
X-Greylist: delayed 1199 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 18 Mar 2023 08:25:25 PDT
Received: from hyperium.qtmlabs.xyz (hyperium.qtmlabs.xyz [194.163.182.183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740751ABCC;
        Sat, 18 Mar 2023 08:25:25 -0700 (PDT)
Received: from dong.kernal.eu (unknown [222.254.17.84])
        by hyperium.qtmlabs.xyz (Postfix) with ESMTPSA id B9055820257;
        Sat, 18 Mar 2023 15:46:24 +0100 (CET)
Received: from localhost (unknown [171.255.115.39])
        by dong.kernal.eu (Postfix) with ESMTPSA id 2975F44496AC;
        Sat, 18 Mar 2023 21:46:19 +0700 (+07)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qtmlabs.xyz; s=syka;
        t=1679150779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QS6eRcg3qz0+dvGL11XvXEsHicDLuvrO+aW9MNPSbOE=;
        b=BIj85WG2x2uqf88mxb7tsgmbgKVsvHC0nx2oc4yjIX0OSYloylRPs9rdl8mJQamv79M4iO
        xIC8L2pjq6gWknVs+tTzYU8aBq1V1Vd0gSWSlyp6YHgLJL0yqJL28Xwaa58nCEO9gHOLh5
        +RJepBA8M/EX9Be8lo+XLWQ0Hq9sTB9iyoKHd7rL7ahGrP6FZzV10CJbgJV/7XzRnbrcSv
        5AxGTC6cbe1G/b2zZUHdmyxDwfn7PziA1hu06v1obLgdvhpSOjA+lyO/oQT34sF4SsQQlI
        49k7O9hhQvdfSbqVSDitP67I7OnFgqLRckjkXUpDtCZ44L6ntIAizSwU/Pbd0g==
From:   msizanoen <msizanoen@qtmlabs.xyz>
To:     =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Cc:     msizanoen <msizanoen@qtmlabs.xyz>, stable@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] input: alps: fix compatibility with -funsigned-char
Date:   Sat, 18 Mar 2023 21:42:07 +0700
Message-Id: <20230318144206.14309-1-msizanoen@qtmlabs.xyz>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The AlpsPS/2 code previously relied on the assumption that `char` is a
signed type, which was true on x86 platforms (the only place where this
driver is used) before kernel 6.2. However, on 6.2 and later, this
assumption is broken due to the introduction of -funsigned-char as a new
global compiler flag.

Fix this by explicitly specifying the signedness of `char` when sign
extending the values received from the device.

Fixes: f3f33c677699 ("Input: alps - Rushmore and v7 resolution support")
Cc: stable@vger.kernel.org
Signed-off-by: msizanoen <msizanoen@qtmlabs.xyz>
---
 drivers/input/mouse/alps.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 989228b5a0a4..1c570d373b30 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -2294,20 +2294,20 @@ static int alps_get_v3_v7_resolution(struct psmouse *psmouse, int reg_pitch)
 	if (reg < 0)
 		return reg;
 
-	x_pitch = (char)(reg << 4) >> 4; /* sign extend lower 4 bits */
+	x_pitch = (signed char)(reg << 4) >> 4; /* sign extend lower 4 bits */
 	x_pitch = 50 + 2 * x_pitch; /* In 0.1 mm units */
 
-	y_pitch = (char)reg >> 4; /* sign extend upper 4 bits */
+	y_pitch = (signed char)reg >> 4; /* sign extend upper 4 bits */
 	y_pitch = 36 + 2 * y_pitch; /* In 0.1 mm units */
 
 	reg = alps_command_mode_read_reg(psmouse, reg_pitch + 1);
 	if (reg < 0)
 		return reg;
 
-	x_electrode = (char)(reg << 4) >> 4; /* sign extend lower 4 bits */
+	x_electrode = (signed char)(reg << 4) >> 4; /* sign extend lower 4 bits */
 	x_electrode = 17 + x_electrode;
 
-	y_electrode = (char)reg >> 4; /* sign extend upper 4 bits */
+	y_electrode = (signed char)reg >> 4; /* sign extend upper 4 bits */
 	y_electrode = 13 + y_electrode;
 
 	x_phys = x_pitch * (x_electrode - 1); /* In 0.1 mm units */
-- 
2.39.2


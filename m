Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1128244B181
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 17:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240476AbhKIQtn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 11:49:43 -0500
Received: from mail-ot1-f47.google.com ([209.85.210.47]:45568 "EHLO
        mail-ot1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239633AbhKIQtj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 11:49:39 -0500
Received: by mail-ot1-f47.google.com with SMTP id l7-20020a0568302b0700b0055ae988dcc8so28549936otv.12;
        Tue, 09 Nov 2021 08:46:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FuoNLU2ihR8xE4baLdLGuDw4e9lBu4yjMMhbdtSzI80=;
        b=uk/QLJozEPWj1/ZciXGl2qWe33XqvCuntAdihBgh5s7ziaVa7V/q9TUPFvZjJ0oVXA
         xWw9iNJTpZRrlfQVRUisbvTNGzATNaVQwMkwNQqjqRWLG/ARZXM8bktXsMUO2R7ezD4Q
         UFUYGpCDrYtCDxp3XsM0u5uKGPmszfq46TY3O5Q04HDPfenbZsQJMgM5YmfmRoEbLWiO
         Ma2BatV/3YsKEE8X88f/RNsLx/Vvp6Y1S4BwcCWxOJ5Ki+hDxyL8qI//cVy/j0XSIuOI
         JN7MIV74Q+CjZf9IpzM5ye0wHm9CnyxLT7o0RJEynnWYj3kfPNHA99JJXqwGYl6ifDk8
         v+nA==
X-Gm-Message-State: AOAM533iqCWSY47ZLDxhmsUIOoxkXzmPfqkEVTZVA0ec7ZF8VauOKOFs
        ZeZIpz/CzArQmZP19fH0XA==
X-Google-Smtp-Source: ABdhPJxj8cu03iQliTA8pQk4Vf2vzLvExFYWnjGcmE/j6gl759ekZMmZWg/EJ3bfPdaCi9cn9QLPBQ==
X-Received: by 2002:a9d:2923:: with SMTP id d32mr6834589otb.149.1636476413029;
        Tue, 09 Nov 2021 08:46:53 -0800 (PST)
Received: from xps15.herring.priv (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.googlemail.com with ESMTPSA id w22sm7514338otp.50.2021.11.09.08.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 08:46:52 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Guenter Roeck <linux@roeck-us.net>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-clk@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Frank Rowand <frowand.list@gmail.com>
Subject: [PATCH 1/2] of: Support using 'mask' in making device bus id
Date:   Tue,  9 Nov 2021 10:46:49 -0600
Message-Id: <20211109164650.2233507-2-robh@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211109164650.2233507-1-robh@kernel.org>
References: <20211109164650.2233507-1-robh@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 25b892b583cc ("ARM: dts: arm: Update register-bit-led nodes
'reg' and node names") added a 'reg' property to nodes. This change has
the side effect of changing how the kernel generates the device name.
The assumption was a translatable 'reg' address is unique. However, in
the case of the register-bit-led binding (and a few others) that is not
the case. The 'mask' property must also be used in this case to make a
unique device name.

Fixes: 25b892b583cc ("ARM: dts: arm: Update register-bit-led nodes 'reg' and node names")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Rob Herring <robh@kernel.org>
---
This should be applied to stable to minimize DT ABI breakage.
---
 drivers/of/platform.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 07813fb1ef37..b3faf89744aa 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -76,6 +76,7 @@ static void of_device_make_bus_id(struct device *dev)
 	struct device_node *node = dev->of_node;
 	const __be32 *reg;
 	u64 addr;
+	u32 mask;
 
 	/* Construct the name, using parent nodes if necessary to ensure uniqueness */
 	while (node->parent) {
@@ -85,8 +86,13 @@ static void of_device_make_bus_id(struct device *dev)
 		 */
 		reg = of_get_property(node, "reg", NULL);
 		if (reg && (addr = of_translate_address(node, reg)) != OF_BAD_ADDR) {
-			dev_set_name(dev, dev_name(dev) ? "%llx.%pOFn:%s" : "%llx.%pOFn",
-				     addr, node, dev_name(dev));
+			if (!of_property_read_u32(node, "mask", &mask))
+				dev_set_name(dev, dev_name(dev) ? "%llx.%x.%pOFn:%s" : "%llx.%x.%pOFn",
+					     addr, ffs(mask) - 1, node, dev_name(dev));
+
+			else
+				dev_set_name(dev, dev_name(dev) ? "%llx.%pOFn:%s" : "%llx.%pOFn",
+					     addr, node, dev_name(dev));
 			return;
 		}
 
-- 
2.32.0


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5DCB1B659D
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 22:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgDWUka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 16:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgDWUk3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 16:40:29 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50875C09B042
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:29 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id v4so8377692wme.1
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3YC6pyybi6G5bn9vYupqc8C2qtwqHiQkVZLXEFbQNI4=;
        b=PjaL3uYMp2rgHl3IlJnLKwude0XXqK1ZPywoi1daPCpvqJg0vdEY6i7UUpvGeFpIYV
         rXnVzuwiCHF2LMmuunru6D3iwOSDrA55JN33rksvGmn5r1mJkysFDKxvFKuBEvZZfjmp
         Z/2NzBytexNQbsmrTpVf7wRdmnq42kjF4ws6gX7C1Z1kJVtQbOMzhVbtWTXWTatNlqWc
         EAEyqHR0YUcobZMXP+v9pONjfumgbwNIDJNhzq9CgxsScBfn7GfzRW1O1+q8b1ZCL9rA
         lXbY99hpuaKXvg/0ar+dshUh5pQmYq/b6TvqIO/ds7BcZdh1kC2IF0qE7lfWSYmSlABp
         j5RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3YC6pyybi6G5bn9vYupqc8C2qtwqHiQkVZLXEFbQNI4=;
        b=QHsgwpIN8hnugbFgE4n4VwQXYIhNNAJzt6jvxVFUvupYUJFANKEf5quwbGSKTMvUIC
         /QaW6s+9THFp6uF9MAXzZgJGoQ1QRuWyzPeaBkTNJ/DGTqCRIGzQExX4cvWi2wbRyVjQ
         uliXNO0u8CCsnWfn/ZpcdVdcpisCg3KXRseovh9E2yBE3q1DiaNEHGxoqk6NRAnGyiPk
         qknoP8XVs/wNkn5aO/yFf4PXicx2cBj+yO7nb3QZRG27DUIFFvtgWDPi61iGGXQwG8Rz
         pqq9d+weHNHOx8lvh8RcsfIRCALuERMUFrOBh0tX5DEEAcJdVzRC9AJDrn+TP23QxB2+
         bv6A==
X-Gm-Message-State: AGi0PubWWNCMwsIUgVyfnyYcbrd8hm8m7j1fothjKPrseqCmxTDvoqhY
        hXPiByKT/8ywyj3TdDiH7ZwmgqpX0ds=
X-Google-Smtp-Source: APiQypKEySmKDgddqpo4st9A9JILHRulL1ihwRQ0sskgoAHeqfp2ei39wp/1UL0bvrzABAgEjSKEKQ==
X-Received: by 2002:a1c:5f46:: with SMTP id t67mr6474028wmb.156.1587674427776;
        Thu, 23 Apr 2020 13:40:27 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u17sm5933726wra.63.2020.04.23.13.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 13:40:26 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Yangtao Li <tiny.windzz@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 08/16] serial/sunsu: add missing of_node_put()
Date:   Thu, 23 Apr 2020 21:40:06 +0100
Message-Id: <20200423204014.784944-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200423204014.784944-1-lee.jones@linaro.org>
References: <20200423204014.784944-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <tiny.windzz@gmail.com>

[ Upstream commit 20d8e8611eb0596047fd4389be7a7203a883b9bf ]

of_find_node_by_path() acquires a reference to the node
returned by it and that reference needs to be dropped by its caller.
This place is not doing this, so fix it.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/tty/serial/sunsu.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/sunsu.c b/drivers/tty/serial/sunsu.c
index e124d2e88996f..8db64282260fb 100644
--- a/drivers/tty/serial/sunsu.c
+++ b/drivers/tty/serial/sunsu.c
@@ -1393,22 +1393,32 @@ static inline struct console *SUNSU_CONSOLE(void)
 static enum su_type su_get_type(struct device_node *dp)
 {
 	struct device_node *ap = of_find_node_by_path("/aliases");
+	enum su_type rc = SU_PORT_PORT;
 
 	if (ap) {
+		struct device_node *tmp;
 		const char *keyb = of_get_property(ap, "keyboard", NULL);
 		const char *ms = of_get_property(ap, "mouse", NULL);
 
 		if (keyb) {
-			if (dp == of_find_node_by_path(keyb))
-				return SU_PORT_KBD;
+			tmp = of_find_node_by_path(keyb);
+			if (tmp && dp == tmp){
+				rc = SU_PORT_KBD;
+				goto out;
+			}
 		}
 		if (ms) {
-			if (dp == of_find_node_by_path(ms))
-				return SU_PORT_MS;
+			tmp = of_find_node_by_path(ms);
+			if (tmp && dp == tmp){
+				rc = SU_PORT_MS;
+				goto out;
+			}
 		}
 	}
 
-	return SU_PORT_PORT;
+out:
+	of_node_put(ap);
+	return rc;
 }
 
 static int su_probe(struct platform_device *op)
-- 
2.25.1


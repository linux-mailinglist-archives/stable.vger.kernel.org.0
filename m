Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2018E23E5D
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 19:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392856AbfETRXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 13:23:46 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45628 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730508AbfETRXp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 13:23:45 -0400
Received: by mail-lj1-f194.google.com with SMTP id r76so13190015lja.12
        for <stable@vger.kernel.org>; Mon, 20 May 2019 10:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/XllLktKT+RmUaf9RIAEUli+Wt4Aghgk5ujtbcVtYIU=;
        b=xS5vIR5Wqk8T0np8EZ1RMfB4FRajZp/gOzlrKdVIjK2BoJwYolJqeCIyT4g+aAQ2+t
         Dy+Azz96b1Wf31SPKnneU5G/ssAnxOqtsEGj0xuuaelKKcaVmzFs5ATOYTtEdLPnx1sf
         Sx84UgPIJm/cmFvCNCBF9KJQgI2blFs3pHJORu1xNkQP5ZO9+eodrra484x0yX/wHfFS
         BKe71vG1csfo+dticSsHgZWJk+AAUo8pJJfjScor7KVZ37xEUJMIBqxca/xEjdH2PsBW
         FpeA+Dg9LcpXKGZnB+/I6v+VkqNPCrA6EfSBVlIDSfcByV+VBr2ovI16J9n8XiK2dEAN
         4/8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/XllLktKT+RmUaf9RIAEUli+Wt4Aghgk5ujtbcVtYIU=;
        b=fx4dZ9aD5Ufmblt7HtSjwZ9xQZbNATHx/Kwy5MmFE6hyL+LVsSrs/neyHjFObU8ZBh
         8MKc9NoK+F08aC8jAFotuEQy01HSfI0DEf4uJkMu8CE7GnI8Hw8UAcj9TLDmgKLnl+MP
         jy+GLvdgdQGWuV2QWDgjvQxRlpfWfukNrzSyhv5KKzZtt+40EZZ0RIgQE4pHrx5qtKW1
         pBA2JLvjOD1Tb6iPtvC83Ac+wX/JtsdOZa3H+YIyXuZodViYdpxAh8hnkhsDV46WlAzu
         W/vQu3S5hrtiRVNfgjfDEyIxhZ75rID9MXPDMmrWfgGoK8EcE+DS9qAA5Y4ge+W7TZx/
         Xr8Q==
X-Gm-Message-State: APjAAAVbI6FXx3dOzGwLtqqXY9zapi0GjRPpi2A1Rnvu9qrEu0ildXCg
        GkQJuNSH8F8i+1G4ONZmi+KjSg==
X-Google-Smtp-Source: APXvYqxqcBMQK1yvH44quISDx05o5DxfTIv+l6ZOUSVR5FOYWdiZmftU1NeDPag/TIRxCS4nPw1DtA==
X-Received: by 2002:a2e:1f02:: with SMTP id f2mr37362997ljf.86.1558373023429;
        Mon, 20 May 2019 10:23:43 -0700 (PDT)
Received: from localhost.localdomain (c-d2cd225c.014-348-6c756e10.bbcust.telenor.se. [92.34.205.210])
        by smtp.gmail.com with ESMTPSA id f189sm4117149lfe.66.2019.05.20.10.23.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 May 2019 10:23:42 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Mark Zhang <markz@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Jinyoung Park <jinyoungp@nvidia.com>,
        Venkat Reddy Talla <vreddytalla@nvidia.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH] regmap-irq: do not write mask register if mask_base is zero
Date:   Mon, 20 May 2019 19:21:39 +0200
Message-Id: <20190520172139.16991-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Zhang <markz@nvidia.com>

commit 7151449fe7fa5962c6153355f9779d6be99e8e97 upstream.

If client have not provided the mask base register then do not
write into the mask register.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Signed-off-by: Jinyoung Park <jinyoungp@nvidia.com>
Signed-off-by: Venkat Reddy Talla <vreddytalla@nvidia.com>
Signed-off-by: Mark Zhang <markz@nvidia.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
This commit was found in an nVidia product tree based on
v4.19, and looks like definitive stable material to me.
It should go into v4.19 only as far as I can tell.
---
 drivers/base/regmap/regmap-irq.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 429ca8ed7e51..982c7ac311b8 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -91,6 +91,9 @@ static void regmap_irq_sync_unlock(struct irq_data *data)
 	 * suppress pointless writes.
 	 */
 	for (i = 0; i < d->chip->num_regs; i++) {
+		if (!d->chip->mask_base)
+			continue;
+
 		reg = d->chip->mask_base +
 			(i * map->reg_stride * d->irq_reg_stride);
 		if (d->chip->mask_invert) {
@@ -526,6 +529,9 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 	/* Mask all the interrupts by default */
 	for (i = 0; i < chip->num_regs; i++) {
 		d->mask_buf[i] = d->mask_buf_def[i];
+		if (!chip->mask_base)
+			continue;
+
 		reg = chip->mask_base +
 			(i * map->reg_stride * d->irq_reg_stride);
 		if (chip->mask_invert)
-- 
2.20.1


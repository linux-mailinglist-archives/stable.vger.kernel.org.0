Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD4110A48E
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 20:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfKZTaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 14:30:46 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42995 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727312AbfKZTaq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 14:30:46 -0500
Received: by mail-lj1-f193.google.com with SMTP id n5so21574835ljc.9;
        Tue, 26 Nov 2019 11:30:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N1fma/rzZbsK0KgJkH5gDE4TEHvO2HL1ft3nAMVM09o=;
        b=DH9OE1isC9wMnuJMDGOHRni1GwxOUfsJU0ywmLSPLdfWPuomlkUHP8ykBHs1KwwoNZ
         IJftDyO+OQGKxgrWaR0Bird2WXdpg7JQ9WPQTWKm7kLMz5l8yTUSlLy9lR6+twon3BEh
         EB6ZMe5P7AwiA+ntl+Nn8ygQu1ODMZv5/opG4sn7DXVu57YHDoSxUbWgOblojTYE5OiK
         6bpufoW/OvY8x5WIF4Ugk/rykcm4PGNjfe4M7+WT1L9t2ngWMLGuZy5LhvaJbQV+cYRT
         865N738hDX8lXfnjCAPGvdp10UKPvPSQjjmjkLYLAW8NOmVywCz/EaS7QwF/z0HlnYgV
         sXUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N1fma/rzZbsK0KgJkH5gDE4TEHvO2HL1ft3nAMVM09o=;
        b=HCpTZltzV4WqwYmTjJrkfsa72bpQysuzKFjlxARVOH20xsiF8+mzNhEr8QqpIEIyie
         XbwLau1cDvjvJaqaOXsak+inpX96WbgNEgGq54nvYp2KfPFhG9PXEwGBzgFOow8hfPFp
         S9XFi+VVF/D8Zpwz1wVJxSAONYk4mCl1/urMD1M8Mr5WMq5sgifeDHoJt+GR3R3zSZbO
         FObWoTjRQhhYnkNw5jlwIrMbWjm8bIugIep2YX8agUVil8j57qO7Fl+tDlGCEQ+z1OVI
         aiWkBhiZvjOr6+fRMavY5Z5QF8QnhXXTguXF90iYUx4UqOdOPeJjeWBpewJndxLsyw1H
         ZfOA==
X-Gm-Message-State: APjAAAWuSrIa00Y7qChAI4lXUP+0aW23WCVIvi5vcYJUcZadpMq5E+Pq
        x9lusRPmlJmKxbTAlGZa2l8=
X-Google-Smtp-Source: APXvYqx9/2noQaJq7x/KWqh0xaR3KlZk66kcGXCNzZVnDIkbRFG0nnLsPyaQcfSma3Bx0Mn7mgvzSg==
X-Received: by 2002:a2e:894b:: with SMTP id b11mr28263730ljk.118.1574796643636;
        Tue, 26 Nov 2019 11:30:43 -0800 (PST)
Received: from octofox.cadence.com (jcmvbkbc-1-pt.tunnel.tserv24.sto1.ipv6.he.net. [2001:470:27:1fa::2])
        by smtp.gmail.com with ESMTPSA id m18sm6134434ljg.3.2019.11.26.11.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 11:30:43 -0800 (PST)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     linux-xtensa@linux-xtensa.org
Cc:     Chris Zankel <chris@zankel.net>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Max Filippov <jcmvbkbc@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] drivers/gpio/gpio-xtensa: fix driver build
Date:   Tue, 26 Nov 2019 11:30:27 -0800
Message-Id: <20191126193027.11970-1-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit cad6fade6e78 ("xtensa: clean up WSR*/RSR*/get_sr/set_sr") removed
{RSR,WSR}_CPENABLE from xtensa code, but did not fix up all users,
breaking gpio-xtensa driver build.
Update gpio-xtensa to use new xtensa_{get,set}_sr API.

Cc: stable@vger.kernel.org # v5.0+
Fixes: cad6fade6e78 ("xtensa: clean up WSR*/RSR*/get_sr/set_sr")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 drivers/gpio/gpio-xtensa.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-xtensa.c b/drivers/gpio/gpio-xtensa.c
index 43d3fa5f511a..0fb2211f9573 100644
--- a/drivers/gpio/gpio-xtensa.c
+++ b/drivers/gpio/gpio-xtensa.c
@@ -44,15 +44,14 @@ static inline unsigned long enable_cp(unsigned long *cpenable)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	RSR_CPENABLE(*cpenable);
-	WSR_CPENABLE(*cpenable | BIT(XCHAL_CP_ID_XTIOP));
-
+	*cpenable = xtensa_get_sr(cpenable);
+	xtensa_set_sr(*cpenable | BIT(XCHAL_CP_ID_XTIOP), cpenable);
 	return flags;
 }
 
 static inline void disable_cp(unsigned long flags, unsigned long cpenable)
 {
-	WSR_CPENABLE(cpenable);
+	xtensa_set_sr(cpenable, cpenable);
 	local_irq_restore(flags);
 }
 
-- 
2.20.1


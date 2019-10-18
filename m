Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F18BDC5B3
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 15:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442789AbfJRNFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 09:05:17 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:41948 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389472AbfJRNFQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 09:05:16 -0400
Received: by mail-il1-f196.google.com with SMTP id z10so5449082ilo.8;
        Fri, 18 Oct 2019 06:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wslZP9DyUNwxdK90AGoUp/+vNWKDF9e6TBPPPKDycR4=;
        b=R26e3FoL8FgJN2mCMM/VZQPzwm6UsJc7GLuX4uVFH2N2mklVJoAxY7Umfit1hI6Z5z
         MShdWDJwM5jodqTXjq/gWkY5ApLNa1lFw5MXEJAJD5B52mjrYGJ1zASE4D87kJYZpM80
         u0l0APphzADqlPbWMlI7qI2lGrYmldhOQP1N/5qFN3lIBUtyurGrHEw3gkbqlvEU1bHp
         33r7rwaSFhMll9ldeioA7+/ElW3Vpi/snZ7TCdmGZzkHkxupp/DrSznmacIqnOYDKyHN
         oXAzRt7VlzJKcRUCHItkJjV+RCPJEaVOX/w53mRNN6ahpzySIhLjFy04aSf6Ze6LQ3h5
         lpyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wslZP9DyUNwxdK90AGoUp/+vNWKDF9e6TBPPPKDycR4=;
        b=D8os1W1cz89RqtXgRBWh0AD1oY9j2mlO1qoRqdMmqJIeTOlVchramGqPzkf4WBea3O
         erjrCBw8BzOAKcjb1XY/NXhO4iVy1SLuhuz2NipjgfNHEhd0VroLQnya+D8W/0qnsF2B
         ZeZJ+wxK2bzIFxlfAD8IfBnwKtmdx4/xp9zQ7Hkvt3d8fNWLVN+VoGWJjTUo1sFd5sFK
         SdjxCaqZDpqujPteUWsD//XL++E19eKDRFaZcgFvKUDWj9ozHd/M4U4yBTWS26A0gjU+
         nBPA2zaUC2yrqXM+nSa5qg0JSS952HYrWGCopFdOWy5lS+PrD0LlGB21hxkLe8+tljmk
         9vkg==
X-Gm-Message-State: APjAAAXO+117DIhZGfBBOXhtLNxK/zGTOZWuucGEXdErFn5CMy4JiaRn
        gZqprxoSaZpofWRqjeERP1QqO0Bg9Bs=
X-Google-Smtp-Source: APXvYqyVLyg3TSt8bgKaczCT8sQ+l5ipZRXdDehyXDMBnKImdJLAjHgbrbjbyA85mvpwRuxVNcHyew==
X-Received: by 2002:a92:c849:: with SMTP id b9mr9215673ilq.68.1571403914324;
        Fri, 18 Oct 2019 06:05:14 -0700 (PDT)
Received: from localhost.localdomain (c-73-37-219-234.hsd1.mn.comcast.net. [73.37.219.234])
        by smtp.gmail.com with ESMTPSA id h62sm2622831ild.78.2019.10.18.06.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 06:05:13 -0700 (PDT)
From:   Adam Ford <aford173@gmail.com>
To:     linux-fbdev@vger.kernel.org
Cc:     linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        tomi.valkeinen@ti.com, adam.ford@logicpd.com,
        Adam Ford <aford173@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] fbdev/omap: fix max fclk divider for omap36xx
Date:   Fri, 18 Oct 2019 08:05:07 -0500
Message-Id: <20191018130507.29893-1-aford173@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The OMAP36xx and AM/DM37x TRMs say that the maximum divider for DSS fclk
(in CM_CLKSEL_DSS) is 32. Experimentation shows that this is not
correct, and using divider of 32 breaks DSS with a flood or underflows
and sync losts. Dividers up to 31 seem to work fine.

There is another patch to the DT files to limit the divider correctly,
but as the DSS driver also needs to know the maximum divider to be able
to iteratively find good rates, we also need to do the fix in the DSS
driver.

Signed-off-by: Adam Ford <aford173@gmail.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: stable@vger.kernel.org # linux-4.4.y only

diff --git a/drivers/video/fbdev/omap2/dss/dss.c b/drivers/video/fbdev/omap2/dss/dss.c
index 9200a8668b49..a57c3a5f4bf8 100644
--- a/drivers/video/fbdev/omap2/dss/dss.c
+++ b/drivers/video/fbdev/omap2/dss/dss.c
@@ -843,7 +843,7 @@ static const struct dss_features omap34xx_dss_feats = {
 };
 
 static const struct dss_features omap3630_dss_feats = {
-	.fck_div_max		=	32,
+	.fck_div_max		=	31,
 	.dss_fck_multiplier	=	1,
 	.parent_clk_name	=	"dpll4_ck",
 	.dpi_select_source	=	&dss_dpi_select_source_omap2_omap3,
-- 
2.17.1


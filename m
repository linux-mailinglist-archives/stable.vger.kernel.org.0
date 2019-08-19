Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8222894AA4
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 18:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfHSQmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 12:42:31 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40846 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfHSQma (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Aug 2019 12:42:30 -0400
Received: by mail-pg1-f196.google.com with SMTP id w10so1522179pgj.7;
        Mon, 19 Aug 2019 09:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3wOK2xieVDMgFi4nncqOUlZUjSIiUaR7EHfTJW3Nr7U=;
        b=j0sL4OeiBMSn+xPuzScaBeBYnpsb+6H204LHZA5hXFVWFiQ181sgiqN7mtfF00tEfY
         B/CF6Fo1p0q/yPaQFjf0giRRzCv3c8Trs0jIKzWcgrYl/P1iFg6+uuogjubvyfjaFMpO
         9l1KLF476EG7FIl9+x/ipizzCNeJFbY5inw6IyiuMq4Ne/Mz+5e935R9II3n2EPNXvdN
         R0Bh02g3ipkhwB0gBDOl/jGSxDX6lv8sbbbaHTU9KkWIcAxT//X9Nnx8dsiu/PmjuFzv
         E3+v79do/qJA2K1TyGBKpVMT8KJJD4Aki0dE/sQppmvsNsHXSINcidez9HlpSZi2XknC
         RVcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3wOK2xieVDMgFi4nncqOUlZUjSIiUaR7EHfTJW3Nr7U=;
        b=RyOOom8BdoCRccJXyyu0s2YZrvh0asZvRLxh0JdW9ivr+ZLiSj0lURLrN6go78iYs1
         bGD+bb2w6HLPkreEM6s7GAqaol/CvYWB6R+SMVt5ITxlB7JjA+F7V3D6fyPG7HqR5JuU
         dZ8FWoZz940nR+Raf9J3W+fvsmkpYKlJujhCN9nB3vn3vVSf00cWg+dsvTT7sTxVJtAR
         h9Htrt4bclnUrY4XfFQLUYNccobIYSMbCw5IMk9KOYfKdbsikzqrauuNQpj0qxfu8UN5
         En0iBt2G0zspS09h4++uGRnrzcqXdRMvz7LMRB1iPvD3KGTthw8k6G2Lkpaj49s4TS32
         ggMg==
X-Gm-Message-State: APjAAAVKkOi6BDNSQGfZPThn9fU+rZSR557FNBgnlc6iNT11EoAGSj0R
        wrinMAZ31ZaejyWDs2Dj2Is=
X-Google-Smtp-Source: APXvYqyt1+BzUhuj88rGQ7gbLvhJ47+cjroOW58Mp2RFmFUD33sxQWdcTZbtqGecKd3bGlbDCXa19w==
X-Received: by 2002:a17:90a:17c4:: with SMTP id q62mr21241026pja.135.1566232950039;
        Mon, 19 Aug 2019 09:42:30 -0700 (PDT)
Received: from west.Home ([97.115.133.135])
        by smtp.googlemail.com with ESMTPSA id u7sm16885452pfm.96.2019.08.19.09.42.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 19 Aug 2019 09:42:29 -0700 (PDT)
From:   Aaron Armstrong Skomra <skomra@gmail.com>
X-Google-Original-From: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
To:     sashal@kernel.org, linux-input@vger.kernel.org, jikos@kernel.org,
        benjamin.tissoires@redhat.com, ping.cheng@wacom.com,
        jason.gerecke@wacom.com
Cc:     Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        "# v4 . 3+" <stable@vger.kernel.org>
Subject: [PATCH] HID: wacom: correct misreported EKR ring values
Date:   Mon, 19 Aug 2019 09:41:54 -0700
Message-Id: <1566232914-9919-1-git-send-email-aaron.skomra@wacom.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The EKR ring claims a range of 0 to 71 but actually reports
values 1 to 72. The ring is used in relative mode so this
change should not affect users.

Signed-off-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Fixes: 72b236d60218f ("HID: wacom: Add support for Express Key Remote.")
Cc: <stable@vger.kernel.org> # v4.3+
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
Reviewed-by: Jason Gerecke <jason.gerecke@wacom.com>
---
Patch specifically targeted to v4.9.189

 drivers/hid/wacom_wac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 6c3bf8846b52..949761dd29ca 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -819,7 +819,7 @@ static int wacom_remote_irq(struct wacom_wac *wacom_wac, size_t len)
 	input_report_key(input, BTN_BASE2, (data[11] & 0x02));
 
 	if (data[12] & 0x80)
-		input_report_abs(input, ABS_WHEEL, (data[12] & 0x7f));
+		input_report_abs(input, ABS_WHEEL, (data[12] & 0x7f) - 1);
 	else
 		input_report_abs(input, ABS_WHEEL, 0);
 
-- 
2.17.1


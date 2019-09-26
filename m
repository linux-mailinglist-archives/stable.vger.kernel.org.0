Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3011BBEC91
	for <lists+stable@lfdr.de>; Thu, 26 Sep 2019 09:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbfIZHbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Sep 2019 03:31:53 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45677 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729451AbfIZHbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Sep 2019 03:31:53 -0400
Received: by mail-pg1-f195.google.com with SMTP id q7so1034513pgi.12;
        Thu, 26 Sep 2019 00:31:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l//Gs0c7u01pz7zaVnzd0AwQx7M2oEVS4q0mnEANanc=;
        b=NMM1H4ErcjMpnXMzEEKmFufNPSy2l88ypgYTBaYByxbB6z5dwwHVMnsiOpd9fUV8Cy
         101bf2q5egtTVsmcxs0y1UiA+b4uLMmtBXm/zE6JQcn24BxsGwK2rQ4rF/N3q1Rs2N2f
         IDQVH3yxxxsCfJ/f8QnS74kmVeVwkxTxu5Q9zTVucw1Eg7WXGCg59B2aqufWJgb6nffv
         mQ5eTPkvYkOIyjJ6WPzwYqXVFBKiYTMq3shp+ozAoWze5YLxxGvIo/WeGFmMws2mu/7T
         Jr7cV++Q/rFDAyFdn45sMC185B4JLQAZvkQ2PdBSpMb0Rdhc+3SRiR2Bl6PxW3Wvckzd
         z3xA==
X-Gm-Message-State: APjAAAXxVLjScGgAwIYqY7Y+dHy7ehlRqOWrcPcKSr7tI3zzCrPmJKQM
        jCEh2tPufFwkgRB91V8Ea4k=
X-Google-Smtp-Source: APXvYqwqr9ObHLgAsANuqN/VDH/rHyyWlH2MoqZFXC3aCXP8ZedkRrcb/NTTeCvd0dwkVTkQPnOnNA==
X-Received: by 2002:a17:90a:236f:: with SMTP id f102mr2087877pje.130.1569483112674;
        Thu, 26 Sep 2019 00:31:52 -0700 (PDT)
Received: from black.wifi.public.euroopa.ee (99-48-196-88.sta.estpak.ee. [88.196.48.99])
        by smtp.googlemail.com with ESMTPSA id u31sm3092013pgn.93.2019.09.26.00.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2019 00:31:51 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     devel@driverdev.osuosl.org
Cc:     Denis Efremov <efremov@linux.com>, linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michael Straube <straube.linux@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] staging: rtl8188eu: fix HighestRate check in odm_ARFBRefresh_8188E()
Date:   Thu, 26 Sep 2019 10:31:38 +0300
Message-Id: <20190926073138.12109-1-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It's incorrect to compare HighestRate with 0x0b twice in the following
manner "if (HighestRate > 0x0b) ... else if (HighestRate > 0x0b) ...". The
"else if" branch is constantly false. The second comparision should be
with 0x03 according to the max_rate_idx in ODM_RAInfo_Init().

Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michael Straube <straube.linux@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/staging/rtl8188eu/hal/hal8188e_rate_adaptive.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/hal/hal8188e_rate_adaptive.c b/drivers/staging/rtl8188eu/hal/hal8188e_rate_adaptive.c
index 9ddd51685063..5792f491b59a 100644
--- a/drivers/staging/rtl8188eu/hal/hal8188e_rate_adaptive.c
+++ b/drivers/staging/rtl8188eu/hal/hal8188e_rate_adaptive.c
@@ -409,7 +409,7 @@ static int odm_ARFBRefresh_8188E(struct odm_dm_struct *dm_odm, struct odm_ra_inf
 		pRaInfo->PTModeSS = 3;
 	else if (pRaInfo->HighestRate > 0x0b)
 		pRaInfo->PTModeSS = 2;
-	else if (pRaInfo->HighestRate > 0x0b)
+	else if (pRaInfo->HighestRate > 0x03)
 		pRaInfo->PTModeSS = 1;
 	else
 		pRaInfo->PTModeSS = 0;
-- 
2.21.0


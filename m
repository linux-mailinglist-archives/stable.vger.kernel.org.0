Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 363BDC1FB2
	for <lists+stable@lfdr.de>; Mon, 30 Sep 2019 13:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730892AbfI3LCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 07:02:22 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34167 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730759AbfI3LCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Sep 2019 07:02:22 -0400
Received: by mail-wm1-f65.google.com with SMTP id y135so13855382wmc.1;
        Mon, 30 Sep 2019 04:02:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ms5iPF2H4/EUN9qkeORDrpoKQjqFYv3fNdSR7vI74Ys=;
        b=oKpJq6bwizuB392evzxhJP6Gb2mKQPj3+rMZucZuE/UQuYAWZePTUkB4iJzdZgkd+E
         c97Dn4UlNJdJL0fIQwwWfuYcyx8ICWu8Ir0vPbl0jEpEJPHNtoMWse2QvKAiL/mffKOi
         igRlX1HhRRHK5fdnEEvlTp+HMshpDni0pg6jlOsJAhfloQyBQQqZVuLuGY04EVkYhBS/
         ImRT+w8bldAJ9mLZ2L4XrA43jVpehCNeEVxnXXgXHTc7cm+rFjXAuGKRxafsOC53Z7Bt
         C40dPqwin1s7vymhQG+L+9O7lH5fpGdHKI0jbhuULiqPJyyO8ysRhUtl6yZOrMBLX5p3
         EqCg==
X-Gm-Message-State: APjAAAWpzvpUM6Y2zitFPumyBPN78risi1zKsgh81VWaYDxpxoivx0w5
        AEa+OGHeaGLkw8DtIJTpM3E=
X-Google-Smtp-Source: APXvYqy6G2bUP18h/dG1Ymznd8phlt997hcwRCX+r1Htrq6oj5itwm6aXYaENnbK/mISBPIjuISu7A==
X-Received: by 2002:a7b:c088:: with SMTP id r8mr17824239wmh.44.1569841340181;
        Mon, 30 Sep 2019 04:02:20 -0700 (PDT)
Received: from green.intra.ispras.ru (bran.ispras.ru. [83.149.199.196])
        by smtp.googlemail.com with ESMTPSA id j26sm23653452wrd.2.2019.09.30.04.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 04:02:19 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     devel@driverdev.osuosl.org
Cc:     Denis Efremov <efremov@linux.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Bastien Nocera <hadess@hadess.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <jes.sorensen@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] staging: rtl8723bs: hal: Fix memcpy calls
Date:   Mon, 30 Sep 2019 14:01:41 +0300
Message-Id: <20190930110141.29271-1-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

memcpy() in phy_ConfigBBWithParaFile() and PHY_ConfigRFWithParaFile() is
called with "src == NULL && len == 0". This is an undefined behavior.
Moreover this if pre-condition "pBufLen && (*pBufLen == 0) && !pBuf"
is constantly false because it is a nested if in the else brach, i.e.,
"if (cond) { ... } else { if (cond) {...} }". This patch alters the
if condition to check "pBufLen && pBuf" pointers are not NULL.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Bastien Nocera <hadess@hadess.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jes Sorensen <jes.sorensen@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
---
Not tested. I don't have the hardware. The fix is based on my guess.

 drivers/staging/rtl8723bs/hal/hal_com_phycfg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c b/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
index 6539bee9b5ba..0902dc3c1825 100644
--- a/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
+++ b/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
@@ -2320,7 +2320,7 @@ int phy_ConfigBBWithParaFile(
 			}
 		}
 	} else {
-		if (pBufLen && (*pBufLen == 0) && !pBuf) {
+		if (pBufLen && pBuf) {
 			memcpy(pHalData->para_file_buf, pBuf, *pBufLen);
 			rtStatus = _SUCCESS;
 		} else
@@ -2752,7 +2752,7 @@ int PHY_ConfigRFWithParaFile(
 			}
 		}
 	} else {
-		if (pBufLen && (*pBufLen == 0) && !pBuf) {
+		if (pBufLen && pBuf) {
 			memcpy(pHalData->para_file_buf, pBuf, *pBufLen);
 			rtStatus = _SUCCESS;
 		} else
-- 
2.21.0


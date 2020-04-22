Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3421B40B7
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729659AbgDVKPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:15:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729304AbgDVKPo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:15:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 925202075A;
        Wed, 22 Apr 2020 10:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550544;
        bh=EZbrKX1EsilYJ37ASjFlx/jbs5C55Og1fqhF5UYxPaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EqIkbCQ5LIPlEMet97mY6SeV7amJbHOlR/f+F4RHL8W8yJuZ7LgQBSAFyr0gmp1F6
         eHaqSZ/9+O4GR2R7JOnLVeqeT29MGwawM41NvjwAN/bG/Dv2221qo1/eBDGa2lZmRX
         +assGc6VJm2L0AjnYOLD2rlHaO+cM+zve6ojl5kU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Thomas Winischhofer <thomas@winischhofer.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 4.19 17/64] video: fbdev: sis: Remove unnecessary parentheses and commented code
Date:   Wed, 22 Apr 2020 11:57:01 +0200
Message-Id: <20200422095015.933393475@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095008.799686511@linuxfoundation.org>
References: <20200422095008.799686511@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit 864eb1afc60cb43e7df879b97f8ca0d719bbb735 upstream.

Clang warns when multiple pairs of parentheses are used for a single
conditional statement.

drivers/video/fbdev/sis/init301.c:851:42: warning: equality comparison
with extraneous parentheses [-Wparentheses-equality]
      } else if((SiS_Pr->SiS_IF_DEF_LVDS == 1) /* ||
                 ~~~~~~~~~~~~~~~~~~~~~~~~^~~~
drivers/video/fbdev/sis/init301.c:851:42: note: remove extraneous
parentheses around the comparison to silence this warning
      } else if((SiS_Pr->SiS_IF_DEF_LVDS == 1) /* ||
                ~                        ^   ~
drivers/video/fbdev/sis/init301.c:851:42: note: use '=' to turn this
equality comparison into an assignment
      } else if((SiS_Pr->SiS_IF_DEF_LVDS == 1) /* ||
                                         ^~
                                         =
1 warning generated.

Remove the parentheses and while we're at it, clean up the commented
code, which has been here since the beginning of git history.

Link: https://github.com/ClangBuiltLinux/linux/issues/118
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbdev/sis/init301.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/video/fbdev/sis/init301.c
+++ b/drivers/video/fbdev/sis/init301.c
@@ -848,9 +848,7 @@ SiS_PanelDelay(struct SiS_Private *SiS_P
 	    SiS_DDC2Delay(SiS_Pr, 0x4000);
 	 }
 
-      } else if((SiS_Pr->SiS_IF_DEF_LVDS == 1) /* ||
-	 (SiS_Pr->SiS_CustomT == CUT_COMPAQ1280) ||
-	 (SiS_Pr->SiS_CustomT == CUT_CLEVO1400) */ ) {			/* 315 series, LVDS; Special */
+      } else if (SiS_Pr->SiS_IF_DEF_LVDS == 1) {			/* 315 series, LVDS; Special */
 
 	 if(SiS_Pr->SiS_IF_DEF_CH70xx == 0) {
 	    PanelID = SiS_GetReg(SiS_Pr->SiS_P3d4,0x36);



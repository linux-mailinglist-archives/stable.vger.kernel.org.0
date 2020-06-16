Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B99A1FB6C3
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731113AbgFPPkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:40:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731110AbgFPPkJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:40:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56705214DB;
        Tue, 16 Jun 2020 15:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322008;
        bh=gGUmW2DrTIls4lFdQDuM1ToOLsMmr9KRvqtR7zLRIM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rSy40E9v15L3EdQsDlZ7aAcfzUFGgNjXisbs6KeemqgqQGZCIX7RRvMBE5klH8PJr
         RFi9uLMYA4J6OvTtqkIvcylW3ZG68uammECCBGmrB4U1/EKvcH4yzh70RKSrtxrn5T
         of7kW+awl9NExus9+GgPyR6JBdw1s1RrSd28Te/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        kbuild test robot <lkp@intel.com>,
        Alexey Charkov <alchark@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 5.4 100/134] video: vt8500lcdfb: fix fallthrough warning
Date:   Tue, 16 Jun 2020 17:34:44 +0200
Message-Id: <20200616153105.577537094@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>

commit 1c49f35e9e9156273124a0cfd38b57f7a7d4828f upstream.

Fix following warning:
vt8500lcdfb.c: In function 'vt8500lcd_blank':
vt8500lcdfb.c:229:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
      if (info->fix.visual == FB_VISUAL_PSEUDOCOLOR ||
         ^
vt8500lcdfb.c:233:2: note: here
     case FB_BLANK_UNBLANK:
     ^~~~

Adding a simple "fallthrough;" fixed the warning.
The fix was build tested.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Reported-by: kbuild test robot <lkp@intel.com>
Fixes: e41f1a989408 ("fbdev: Implement simple blanking in pseudocolor modes for vt8500lcdfb")
Cc: Alexey Charkov <alchark@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: <stable@vger.kernel.org> # v2.6.38+
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200412202143.GA26948@ravnborg.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbdev/vt8500lcdfb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/vt8500lcdfb.c
+++ b/drivers/video/fbdev/vt8500lcdfb.c
@@ -230,6 +230,7 @@ static int vt8500lcd_blank(int blank, st
 		    info->fix.visual == FB_VISUAL_STATIC_PSEUDOCOLOR)
 			for (i = 0; i < 256; i++)
 				vt8500lcd_setcolreg(i, 0, 0, 0, 0, info);
+		fallthrough;
 	case FB_BLANK_UNBLANK:
 		if (info->fix.visual == FB_VISUAL_PSEUDOCOLOR ||
 		    info->fix.visual == FB_VISUAL_STATIC_PSEUDOCOLOR)



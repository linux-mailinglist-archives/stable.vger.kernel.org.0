Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 954D744044
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390102AbfFMQEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:04:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731350AbfFMIqr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:46:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4823720851;
        Thu, 13 Jun 2019 08:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415606;
        bh=N8qfoztD7dRorllnB+Hau1xtrZJQ97QIH7SlFYFD3ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bUMvCvpbilBl7vr+DWkmeRg0FYils+lFfxqgRafRQle0yRqlaI33zp4188WSo97xP
         VrXy9epDP6A47GH9009AqspbTcTGHRbPz1gYs3ivq6AoaAXdWWoOScdYBL1gF4K/Gx
         ln0cwAB3CxbN2in4HhkIwrQOrSbsCNB19PXd/9rY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Schwab <schwab@linux-m68k.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Yisheng Xie <ysxie@foxmail.com>,
        Kees Cook <keescook@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Steven Rostedt <rostedt@goodmis.org>,
        Marko Myllynen <myllynen@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Thierry Reding <treding@nvidia.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 061/155] fbcon: Dont reset logo_shown when logo is currently shown
Date:   Thu, 13 Jun 2019 10:32:53 +0200
Message-Id: <20190613075656.477705080@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3c5a1b111373e669c8220803464c3a508a87e254 ]

When the logo is currently drawn on a virtual console, and the console
loglevel is reduced to quiet, logo_shown must be left alone, so that it
the scrolling region on that virtual console is properly reset.

Fixes: 10993504d647 ("fbcon: Silence fbcon logo on 'quiet' boots")
Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Yisheng Xie <ysxie@foxmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Marko Myllynen <myllynen@redhat.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Thierry Reding <treding@nvidia.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index c59b23f6e9ba..a9c69ae30878 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -1069,7 +1069,7 @@ static void fbcon_init(struct vc_data *vc, int init)
 
 	cap = info->flags;
 
-	if (console_loglevel <= CONSOLE_LOGLEVEL_QUIET)
+	if (logo_shown < 0 && console_loglevel <= CONSOLE_LOGLEVEL_QUIET)
 		logo_shown = FBCON_LOGO_DONTSHOW;
 
 	if (vc != svc || logo_shown == FBCON_LOGO_DONTSHOW ||
-- 
2.20.1




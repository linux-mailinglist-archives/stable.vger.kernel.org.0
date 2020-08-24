Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613D224F590
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbgHXIuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:50:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729621AbgHXIup (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:50:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ABAD2075B;
        Mon, 24 Aug 2020 08:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259044;
        bh=UCnJzkF6jvo0O/ktC5flsal+jXhEzxyjOp0Dxit5d6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D4kq8cJdeGnK3HXs1K8VbYXlCE64SP4KEH6IdSIa4/aUpLiXzciLftUkiHwVOw4/z
         IBKcgWtIZbgVOiWO0OdW5jj5oKgd2dNh7tXmWNVFMbBnDpyi4c04HO4ACOLwZbMLVq
         ZMOl+AhiohrNuXA+e7OtL9+F7gI9iH8wS/rWk3nw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "tomi.valkeinen@ti.com, aford@beaconembedded.com, Adam Ford" 
        <aford173@gmail.com>, tomi.valkeinen@ti.com,
        Adam Ford <aford173@gmail.com>
Subject: [PATCH 4.4 33/33] omapfb: dss: Fix max fclk divider for omap36xx
Date:   Mon, 24 Aug 2020 10:31:29 +0200
Message-Id: <20200824082348.191071695@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082346.498653578@linuxfoundation.org>
References: <20200824082346.498653578@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

There appears to be a timing issue where using a divider of 32 breaks
the DSS for OMAP36xx despite the TRM stating 32 is a valid
number.  Through experimentation, it appears that 31 works.

This same fix was issued for kernels 4.5+.  However, between
kernels 4.4 and 4.5, the directory structure was changed when the
dss directory was moved inside the omapfb directory. That broke the
patch on kernels older than 4.5, because it didn't permit the patch
to apply cleanly for 4.4 and older.

A similar patch was applied to the 3.16 kernel already, but not to 4.4.
Commit 4b911101a5cd ("drm/omap: fix max fclk divider for omap36xx") is
on the 3.16 stable branch with notes from Ben about the path change.

Since this was applied for 3.16 already, this patch is for kernels
3.17 through 4.4 only.

Fixes: f7018c213502 ("video: move fbdev to drivers/video/fbdev")
Cc: <stable@vger.kernel.org> #3.17 - 4.4
CC: <tomi.valkeinen@ti.com>
Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbdev/omap2/dss/dss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/fbdev/omap2/dss/dss.c
+++ b/drivers/video/fbdev/omap2/dss/dss.c
@@ -843,7 +843,7 @@ static const struct dss_features omap34x
 };
 
 static const struct dss_features omap3630_dss_feats = {
-	.fck_div_max		=	32,
+	.fck_div_max		=	31,
 	.dss_fck_multiplier	=	1,
 	.parent_clk_name	=	"dpll4_ck",
 	.dpi_select_source	=	&dss_dpi_select_source_omap2_omap3,



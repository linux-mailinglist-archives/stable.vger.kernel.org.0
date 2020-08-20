Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDEDF24B8B6
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730541AbgHTLZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:25:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729742AbgHTKGT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:06:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81C57206DA;
        Thu, 20 Aug 2020 10:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917979;
        bh=zo6pltTSim6Y8TsnJDxGpq+mDQQrhpbRbxryvqJAlSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wYeZEU78IpYpfba3XcWmgKWKv5amnR0hqKvmv04tcuoU4sfTIE7pEP4apB3o7wk6X
         PCo7mj+k+JQkQctLgMWMPp9fs4jJ1mkEX2Hv7tfzQlTGzhQpVAJDX/KD3FzT6LqGFN
         K86295YOSpF3NBz8a4bJxvNKNabFvjvLqgHOCC74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Dave Airlie <airlied@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 4.14 011/228] omapfb: dss: Fix max fclk divider for omap36xx
Date:   Thu, 20 Aug 2020 11:19:46 +0200
Message-Id: <20200820091608.088999708@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

commit 254503a2b186caa668a188dbbd7ab0d25149c0a5 upstream.

The drm/omap driver was fixed to correct an issue where using a
divider of 32 breaks the DSS despite the TRM stating 32 is a valid
number.  Through experimentation, it appears that 31 works, and
it is consistent with the value used by the drm/omap driver.

This patch fixes the divider for fbdev driver instead of the drm.

Fixes: f76ee892a99e ("omapfb: copy omapdss & displays for omapfb")
Cc: <stable@vger.kernel.org> #4.5+
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Rob Clark <robdclark@gmail.com>
[b.zolnierkie: mark patch as applicable to stable 4.5+ (was 4.9+)]
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200630182636.439015-1-aford173@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbdev/omap2/omapfb/dss/dss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/fbdev/omap2/omapfb/dss/dss.c
+++ b/drivers/video/fbdev/omap2/omapfb/dss/dss.c
@@ -843,7 +843,7 @@ static const struct dss_features omap34x
 };
 
 static const struct dss_features omap3630_dss_feats = {
-	.fck_div_max		=	32,
+	.fck_div_max		=	31,
 	.dss_fck_multiplier	=	1,
 	.parent_clk_name	=	"dpll4_ck",
 	.dpi_select_source	=	&dss_dpi_select_source_omap2_omap3,



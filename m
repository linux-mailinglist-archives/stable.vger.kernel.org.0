Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF08ED2483
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389276AbfJJIqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:46:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389269AbfJJIqM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:46:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0384208C3;
        Thu, 10 Oct 2019 08:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697171;
        bh=ULwYx4Q1NCG16srlI3fJS7zmEXdK3GkZILdEY+2LNlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B+72YhTuXkOp0DgnemKSAuUU3HRntgcmL0y9by+U3Nd5505MZXOXsiWrBzbOV4VV8
         Ayr/K2JZTqb9I5U0sv5xmoCUgRb4+6BPkK5DaqUgcG7VJ9eF3q9br6eFJjLnyoT88S
         kxWOey4vGY8x61OV1gM+dmBR/pa8ctuKDHduOwgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Adam Ford <aford173@gmail.com>, Jyri Sarha <jsarha@ti.com>
Subject: [PATCH 4.19 037/114] drm/omap: fix max fclk divider for omap36xx
Date:   Thu, 10 Oct 2019 10:35:44 +0200
Message-Id: <20191010083603.611123885@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

commit e2c4ed148cf3ec8669a1d90dc66966028e5fad70 upstream.

The OMAP36xx and AM/DM37x TRMs say that the maximum divider for DSS fclk
(in CM_CLKSEL_DSS) is 32. Experimentation shows that this is not
correct, and using divider of 32 breaks DSS with a flood or underflows
and sync losts. Dividers up to 31 seem to work fine.

There is another patch to the DT files to limit the divider correctly,
but as the DSS driver also needs to know the maximum divider to be able
to iteratively find good rates, we also need to do the fix in the DSS
driver.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Adam Ford <aford173@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20191002122542.8449-1-tomi.valkeinen@ti.com
Tested-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Jyri Sarha <jsarha@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/omapdrm/dss/dss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/omapdrm/dss/dss.c
+++ b/drivers/gpu/drm/omapdrm/dss/dss.c
@@ -1110,7 +1110,7 @@ static const struct dss_features omap34x
 
 static const struct dss_features omap3630_dss_feats = {
 	.model			=	DSS_MODEL_OMAP3,
-	.fck_div_max		=	32,
+	.fck_div_max		=	31,
 	.fck_freq_max		=	173000000,
 	.dss_fck_multiplier	=	1,
 	.parent_clk_name	=	"dpll4_ck",



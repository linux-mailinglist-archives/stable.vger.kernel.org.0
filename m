Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED3BC10E8E2
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfLBKbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:31:09 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35732 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727366AbfLBKbJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:31:09 -0500
Received: by mail-wr1-f68.google.com with SMTP id g17so11474732wro.2
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=u3Ch75wUUvhwXD3EeMuBMicQ6oTRlT4EyUjisae7FTo=;
        b=sWn/wz7gXCkWA6ZW52w4XXPfmqi7tUX6NPd0Bww9Gi4bdk8d1CKRCp2q1RcdIFGLNP
         Z798RoSpCXj/FQZJy5kC7hc3RyFIRHCMYYvu1rL9fq6ONvSmX8achhpguE8QF2SAskVC
         eWPA67O+OxVZ9+mjK2JTfPCGxJUN7pOvI/VTrJ/Ly1sUPWd90cKad+wc6rhLegasuTPv
         s1pmddKrlhGnZ7z8mE0eAiqEjRUHAwvzUhfKR4sSwddYZ9BwoUW/DWH6JHOuvfyk8gdl
         vsI8tTWNMqlPAHyhTMPtzqxfoGYBBGzt0ArRdsGo93bj2DAOmao++mVdR1JEpbHOLllT
         SqYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u3Ch75wUUvhwXD3EeMuBMicQ6oTRlT4EyUjisae7FTo=;
        b=TmL/0oxbIlGRVBIz9mFzsizQ3mwAIBEIB63me7IDPlgStDfu8jua0XnBB2lcMCd437
         XNvCNd0jlKaai2gFrPrVJGuDscOI3mpSYmCfXmxtXYooaI/Tkhqd1L+BUs+OVzCorgr+
         5DrjUHmJJZvvB87uC4Pu+P9a8JlvhObenDRlJ+yKKBlhzK/mXIgM55TAJ8lEyGUXlru7
         l0yIXxxiNKWCFI6+QJ3lFY7fataNxQx4tlN1J7eX6q5hKbKEEg+RZeBxhBi0UgvnHqBH
         rS8AX4HR6a7EuTsdWksyPKTDd6xakuq3eWHIF7Rb6PVRX0W1KA4ntmHi9xN6ot4I3wUf
         qYDQ==
X-Gm-Message-State: APjAAAWn+dRG1Mvzino5zSott618++YFhJYY+GP8YSqEly35RSQQA7K1
        8OArZzwJCooS8VuRdBJtBG6m4U7ztpc=
X-Google-Smtp-Source: APXvYqwYRi++vCNaisSvc6hJW+w85bCJLv0UoQHWCNW18CdvWyJ2N+fJ8QhNG47UyUlQkgqj1KHgrw==
X-Received: by 2002:a05:6000:1047:: with SMTP id c7mr15716708wrx.341.1575282666772;
        Mon, 02 Dec 2019 02:31:06 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id r6sm26402860wrq.92.2019.12.02.02.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:31:06 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 04/15] drm/atmel-hlcdc: revert shift by 8
Date:   Mon,  2 Dec 2019 10:30:39 +0000
Message-Id: <20191202103050.2668-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202103050.2668-1-lee.jones@linaro.org>
References: <20191202103050.2668-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit cbb32079149dbf557fa3f7bab8fa3c5fec857da7 ]

Revert shift by 8 of state->base.alpha. This introduced a
regression on planes.

Fixes: 7f73c10b256b ("drm/atmel-hclcdc: Convert to the new generic alpha property")
Cc: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/1556195748-11106-7-git-send-email-claudiu.beznea@microchip.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
index 04440064b9b7..e5b3ba73e661 100644
--- a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
+++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
@@ -382,7 +382,7 @@ atmel_hlcdc_plane_update_general_settings(struct atmel_hlcdc_plane *plane,
 			cfg |= ATMEL_HLCDC_LAYER_LAEN;
 		else
 			cfg |= ATMEL_HLCDC_LAYER_GAEN |
-			       ATMEL_HLCDC_LAYER_GA(state->base.alpha >> 8);
+			       ATMEL_HLCDC_LAYER_GA(state->base.alpha);
 	}
 
 	if (state->disc_h && state->disc_w)
-- 
2.24.0


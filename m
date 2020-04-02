Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A63219C9B5
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388696AbgDBTRC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:17:02 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44672 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388621AbgDBTRC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:17:02 -0400
Received: by mail-wr1-f66.google.com with SMTP id m17so5553456wrw.11
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=pLD0AxSqeVbetyKa4mssFFnMxF0OJMxGy++Z8dISm14=;
        b=M8VYDtGhyWQLr49vLhJlUn8z0AW5kxQuBE/xc7ydofcnmmCEe1LENbDeEOLWLG6VNc
         rksRs859GhL3xHevJULNeKz4Gx+PjdDfpLEM7XhJQV8Yr8Ne0UR5xrtZ5+mjFtZyjH9V
         GW112ZOVCAQfWTfNk67bH/zz2r8UhQ4Ly8zDRwzv9q6WJDFBdWe1LgauYwA2xYOYudSI
         tsgERD84e5nNoOpVtiyE3g2XxMHzb6ApDb5kwfCpFrKe2dbHdr8HFDvx7hwMvLz9tuob
         UBp+FyF1AY0EVO83HQxWnNyOdNq6pPej0kyLOrDoB2TJw9RV2JUN1h8lsRq07wQrZeXl
         IptA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pLD0AxSqeVbetyKa4mssFFnMxF0OJMxGy++Z8dISm14=;
        b=dr962uYE3ApqE65BGMcp0u7OEj8M2UYsNGDTeoYspdGPB0unrjkZd5b/5eb9dPt5f/
         2fnOD+XT5i6Af02LTWUcu6PNEBde8Pw4Rwx/EvGqk6EVVqeS/GX/Lc4+nsEz40eIVBhn
         2fNdjAmOYAAGkeKOnhEDdqVawaIeBbV7cIVNkBdcYXdgQH98TPHWyFg39yOR34HHn7to
         c14dCACFX6CaYJNQoHN1iQN1dX9CBmEKNa8SOcDd+J4XDFZlZAv4oFS9B7V/6zivdNHr
         ILcBT30OWkI9/6GQugPZblQK6jO8ec/9M1q9qVnKbwCZmvnaFHXzLtEmAFxDgd1GBGQZ
         Fe4Q==
X-Gm-Message-State: AGi0PuaqxOiRtjAhovk5QExQOKt+Cjp3PI+1pGqYacyCAIG3tVFLc1rj
        oP2YOSXDsU2GzYtf9gGCgZwG6quTWwaCCg==
X-Google-Smtp-Source: APiQypIFAVM2DvX+jW50hbl5/iODFDaLmleLBZO9b8BCtrIlZhXm3cwR9moNQRc8a91LWm/raK3rYA==
X-Received: by 2002:adf:f68b:: with SMTP id v11mr4782316wrp.270.1585855020119;
        Thu, 02 Apr 2020 12:17:00 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y1sm879050wmd.14.2020.04.02.12.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:16:59 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 06/24] drm: NULL pointer dereference [null-pointer-deref] (CWE 476) problem
Date:   Thu,  2 Apr 2020 20:17:29 +0100
Message-Id: <20200402191747.789097-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191747.789097-1-lee.jones@linaro.org>
References: <20200402191747.789097-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Moriarty <joe.moriarty@oracle.com>

[ Upstream commit 22a07038c0eaf4d1315a493ce66dcd255accba19 ]

The Parfait (version 2.1.0) static code analysis tool found the
following NULL pointer derefernce problem.

- drivers/gpu/drm/drm_dp_mst_topology.c
The call to drm_dp_calculate_rad() in function drm_dp_port_setup_pdt()
could result in a NULL pointer being returned to port->mstb due to a
failure to allocate memory for port->mstb.

Signed-off-by: Joe Moriarty <joe.moriarty@oracle.com>
Reviewed-by: Steven Sistare <steven.sistare@oracle.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20180212195144.98323-3-joe.moriarty@oracle.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 93f2033b414a2..a38be6dd7cfb1 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -1052,10 +1052,12 @@ static bool drm_dp_port_setup_pdt(struct drm_dp_mst_port *port)
 		lct = drm_dp_calculate_rad(port, rad);
 
 		port->mstb = drm_dp_add_mst_branch_device(lct, rad);
-		port->mstb->mgr = port->mgr;
-		port->mstb->port_parent = port;
+		if (port->mstb) {
+			port->mstb->mgr = port->mgr;
+			port->mstb->port_parent = port;
 
-		send_link = true;
+			send_link = true;
+		}
 		break;
 	}
 	return send_link;
-- 
2.25.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F77519C9D5
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389471AbgDBTSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:18:11 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51608 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389467AbgDBTSL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:18:11 -0400
Received: by mail-wm1-f65.google.com with SMTP id z7so4625098wmk.1
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=do9oCzdCQ7pqjo1kJBT1w8qp4s4gKQnKnP0s37N0tn4=;
        b=aXY7ZdDATD8PZXIuEkctd/398KkfjE3NUF9iUCiQgyVoJ1KFdUqqQvx58rbsIqYvuO
         pkPRs3QsAaCLA6WEt7vYNbguMDgqPUsbs4FThBeHsyaOoutCc5hxuAc4ZLS7KG1Ftm+O
         rzipMgGCI/BSxuka0mhjuPO2fj3isonpr1vJyL+yONArjv3Vwz3sLaMu6dEuR0Eqqdpn
         IfM6l81OcvzEnBoW1lnRMpeTD8hPJ2wcVw9CqngvznFsNwgqGWV/namWbwzYY+5X+mRJ
         lEmezU/rxOwSy7rKBXZMzNqCdbb7cRFUMKd4LEgniY9g/6a+Dqzw7zl+hTUakyPTxB7d
         jlZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=do9oCzdCQ7pqjo1kJBT1w8qp4s4gKQnKnP0s37N0tn4=;
        b=RvnAmadPgpkLhnzsvCa6tFoeVmZACJPPfCovNSLuEm3QO2QUjncoVRpCtd22jCjEQV
         pAXL9x7Z2/jnqOaX1MSyKKSGXiszEa+f2mtWXwowqvtBVstRGF3eJmvPPEk6N+po98MA
         yIeC4Itj2LkDt9K/sVXagQkW7Y8Ha83WMAuzv2JBMGnQ2jetYBV50PoiutBJ2dvZHIQ4
         taAA7cLFJ3XT58DcJfVlHyCYWQnD57ipE7A3Sqv3uq3xwEWYdR9SoEPf1JRxil7YG4Qv
         w+6zq1e1QejAaErgdQeiHr2eEmPQe0Q/a1ickQHKwY24sgAzxVGv77BWGeFLuVMzo6eq
         jX4g==
X-Gm-Message-State: AGi0PuZ/avVeaixooAOSo6T5lGli6Hj6qWhpFRZpO0aG4eVOUGDXhaIA
        eoIDMGtESTWFE1bzrnGKFlm9eyVik3dK7w==
X-Google-Smtp-Source: APiQypLYxEZoffjbl42SEsIIeOHGd5G/T//J+AvUSiICUn+NWyUMFzP1KqJPR+JVBYqopHTk8Ogvyw==
X-Received: by 2002:a7b:c8cd:: with SMTP id f13mr4957248wml.181.1585855089044;
        Thu, 02 Apr 2020 12:18:09 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id l10sm8622707wrq.95.2020.04.02.12.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:18:08 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 07/20] drm: NULL pointer dereference [null-pointer-deref] (CWE 476) problem
Date:   Thu,  2 Apr 2020 20:18:43 +0100
Message-Id: <20200402191856.789622-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191856.789622-1-lee.jones@linaro.org>
References: <20200402191856.789622-1-lee.jones@linaro.org>
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
index 6f6a6325b4691..9fc634d6074b0 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -1047,10 +1047,12 @@ static bool drm_dp_port_setup_pdt(struct drm_dp_mst_port *port)
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


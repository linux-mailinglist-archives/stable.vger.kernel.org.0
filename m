Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9D41B2653
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 14:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbgDUMkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 08:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728739AbgDUMkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 08:40:47 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7074C061A10
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:40:46 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id g13so14257618wrb.8
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o52HgE6vtTr4ukwLmsBnTEMam/haSnG9EfojG3rdDcg=;
        b=Zw+fbxzXfJ+EbaH1RANOXtZgZHXj4l+ZCymWDg4HLUhSONEVxeQw+HoGaiHoe55EWy
         neIW1kI0JRnAxpmrrxzB54DaCBFRkCT3Axv7ymPTKORCp8CjWUUyLxtuLaXQ7NeTlyW/
         vsv0z6cVPGkLGEiRnH4UcFZbeUMNlW0pR2krMBtW279R9gAtmdidZ1EJKnQJCVKBowXF
         HriPFf1hNKNawblr9TDzppf9n0rnGOZsCJhbW3BySWw/vDDp/mkryMAACvCTYx4V5Ikm
         OFExHxezYJ0iME9xhFlSA60orX4zvtX9jybNNvpa8k2fhgvwdJUNfOwECuOA8qZRqN60
         M6rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o52HgE6vtTr4ukwLmsBnTEMam/haSnG9EfojG3rdDcg=;
        b=cUI7OK5CcrusXmw4DmkEPudgIRlhKtC1ac/GX5oQdiNPTD9mje24F9Uaer9Pud0ACb
         xo+1ybU96NJth+xAxUBUS5NPcjTVgUhcsJ0pU63cd5nujzziFfBL8+uVf10/QqgM/77g
         EFk6Y+3v49ulj/p+8Qs2e1DltcFKSRzPGS5G/Ydy4RgM+z3ifTtdaLAON97ia6pwgBtz
         drVuKlvSi/c0uf/GUJta0fO9r99WRmJmqUx4nLSb+Hw0EDke+giSkzQ1hCFfJtOkFM8F
         rdADrYPb6Ron3z9PvSbLq6HxHzsbtcLkaevtTSxePcxkVALAQcu9YemEjSFXJN5v83Ho
         4Muw==
X-Gm-Message-State: AGi0PuahHXWVcXSIpjjKWq/Pty2/qbUOcdc3GypURZiQDy5Npt8+KKZy
        Xx0ZGrvDI4kDVtnviK4p9bEvo6Z0QDQ=
X-Google-Smtp-Source: APiQypKFVf/wE3tY2Xwz9ptmJ/oNNP6/+IY12QZhLCxfOSgonuKknE8FyGHKTRmJHBgsvvTcHaa/ZQ==
X-Received: by 2002:a5d:52d1:: with SMTP id r17mr22716894wrv.333.1587472845359;
        Tue, 21 Apr 2020 05:40:45 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u3sm3408232wrt.93.2020.04.21.05.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:40:44 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Joe Moriarty <joe.moriarty@oracle.com>,
        Steven Sistare <steven.sistare@oracle.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 01/24] drm: NULL pointer dereference [null-pointer-deref] (CWE 476) problem
Date:   Tue, 21 Apr 2020 13:39:54 +0100
Message-Id: <20200421124017.272694-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200421124017.272694-1-lee.jones@linaro.org>
References: <20200421124017.272694-1-lee.jones@linaro.org>
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
index f0d819fc16cd7..4a008fb8b1afc 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -1043,10 +1043,12 @@ static bool drm_dp_port_setup_pdt(struct drm_dp_mst_port *port)
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


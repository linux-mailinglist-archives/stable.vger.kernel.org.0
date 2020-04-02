Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91C4B19C98C
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389167AbgDBTNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:07 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43431 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389176AbgDBTNG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:06 -0400
Received: by mail-wr1-f67.google.com with SMTP id 91so3642773wri.10
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=fzL9s9Yiv7xXMi2iCxfhQznYtRkR2kzBx6Fly/MA7Nk=;
        b=W6i6FMWYklp5dna6PgjNP4Ldc+beD8x37lhxTJcww+VbMojNiKWWken/+h9X0B23cV
         p079tp3oiImPuk5rLvuM6d1AkUR1N+W3Bjpa3QeY/I2DhQHkDKr6MaYc2F238c3M0FB+
         SCGkkQH8goFP/jqZh6UMNa1Wvsje7qdGS+vgd/hBO5vqkn7HiL0lFCsWmg1qYxTTPqdq
         EwOPDMPhjXIvSxW6t7bZzyqcKkln4E+UFZDlLEsMF+hQ1m6cyBMW7v/4mLRhyAeba0dj
         TbqVK0Yo1mBgtOqH1fSKolCrgZUgr6cJ664vr0VoY7tkNJm4V4vF3iFXzhirnuxh0zso
         muIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fzL9s9Yiv7xXMi2iCxfhQznYtRkR2kzBx6Fly/MA7Nk=;
        b=RM/gLhgjor9CuolkC0vLOkeneY5mYy8nyHr40BtGGhMlo1DrBhm0H3C7dDbkZ087hc
         Cd1IhfsyLeYfmTgriYONAvc4buPYik5nMmslVJi1tdIitzM5h9w6FNFNx/Td4sz+/a76
         PRmBp8AzABCDwb3FyV+1mf4LkQKqJ7HApK8ulSeirw8txpkm93bhAozFeM2BL0b0//eg
         Sp2Yub5y2TN2D0i0goqms5naypPanr359lkTUDh3pbP6wr7gBW7TchW+WxFyxVCc/51Y
         JMHfbF7vrjwhYdvYFvSHtSDvNLhf/Z+FJiGviyoGxXnHdB8v1Mv7zHClZlDoGSnDt+oG
         XgqA==
X-Gm-Message-State: AGi0PuYTEF9UbXeASyX7ZXq2zYa69gg7QF+YjwKx9dvOZdl7WeIzReKt
        U6791n/8eTKhm6tGb9Eblq2sMDfusr+gmg==
X-Google-Smtp-Source: APiQypJqF4pLfCJtpbeu8Tebz7poTaW803MoMadKaFVD1pIBblcrnHD473kUad07QxPDqFAl6Qr+RA==
X-Received: by 2002:adf:e942:: with SMTP id m2mr4872914wrn.364.1585854784331;
        Thu, 02 Apr 2020 12:13:04 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:03 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 05/33] drm: NULL pointer dereference [null-pointer-deref] (CWE 476) problem
Date:   Thu,  2 Apr 2020 20:13:25 +0100
Message-Id: <20200402191353.787836-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
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
index a4bf98e6af57d..9f67e1c8474bc 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -1054,10 +1054,12 @@ static bool drm_dp_port_setup_pdt(struct drm_dp_mst_port *port)
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0A21B430B
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgDVLUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 07:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726797AbgDVLUK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 07:20:10 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2CCC03C1A8
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:08 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id x17so1186284wrt.5
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pLD0AxSqeVbetyKa4mssFFnMxF0OJMxGy++Z8dISm14=;
        b=IpJopXpLyQj5bDKBZwQPu9nfT7G1sL1hHRPIosy5KgNSyu0WaWIOynKK28Xuhvxlr7
         +V+uOKazTXmyWYle6ii37tAAcAHY4sIKfTpXSbwjxl8W8lIzzqnVF+4unX76LJAOi/1y
         dIQN6y7uP/NL9HgwRoODdvkgNmHCOQEH3ZZNBBxi5uf5DxMRrxJFm1shGJ8WrMAUjhjq
         Ir8U1dnh+hgfeOD9g1N9auBK1yqQHK/BgEIx77sKpGBdnQHsxFAz/4oiUIe8u/oTtCIf
         ihqGCTxw2Km03Dn603DAqmk6peJW1ZMSa1A8cTdN5TQQMw1INoAm8UBUcTdZED2QBc/+
         IMYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pLD0AxSqeVbetyKa4mssFFnMxF0OJMxGy++Z8dISm14=;
        b=ffBAzn0DFQy3RJIGfQgMcHAXFjHmUNLuiuc+hhgo39YGNeNAx/dK8+eEO6cD/C3ovO
         V3vZtrLeanx3m2UGPS+FHy7hiOi4UCEObdd1XmEGM87uHv348whgk9GUAj54Lgv/orEN
         qLg1j4OI7w774OEV0GM2cRceGbRw6ogyK9Gi1kO8tf3epXozU9TgW/hyJEQA5PH8/zxk
         eX20TqY4bKNdrYEpbuIZi467Th0TTGVRp4Cnm06NYWsRhto1Cen4DNxVH/RZW3ZvnoL/
         zsVquEDWExESJa5HOPB4SdWFvoh/5sVcImkAVMnv15ZNWPWL5127/C7U4H7QWcASvXVb
         loPg==
X-Gm-Message-State: AGi0Pubnzx1faTFEIE8j97AKrlVG8H43X5aZgg/f7265tIyWqaDeG3Aj
        h0WJMAkb+Yi5XDMHRZX1QgyLJUyo8+g=
X-Google-Smtp-Source: APiQypINtca548P6nkM9Cf7pD+PAoi31EY3YbqsKBN4IL9Q8L2/t4VZKvArebWl0h1W9cn33YqNjJg==
X-Received: by 2002:adf:dd8a:: with SMTP id x10mr28584984wrl.308.1587554407460;
        Wed, 22 Apr 2020 04:20:07 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id n6sm8247255wrs.81.2020.04.22.04.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 04:20:06 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Joe Moriarty <joe.moriarty@oracle.com>,
        Steven Sistare <steven.sistare@oracle.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 06/21] drm: NULL pointer dereference [null-pointer-deref] (CWE 476) problem
Date:   Wed, 22 Apr 2020 12:19:42 +0100
Message-Id: <20200422111957.569589-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200422111957.569589-1-lee.jones@linaro.org>
References: <20200422111957.569589-1-lee.jones@linaro.org>
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


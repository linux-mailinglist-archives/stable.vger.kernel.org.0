Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C891B659A
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 22:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgDWUk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 16:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgDWUkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 16:40:25 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ACFBC09B042
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:25 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id g13so8229606wrb.8
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ew2Jpv/icPL2fFBz/NSetkxvuqhRbbQqlWSu01ZZe7k=;
        b=gP3/LICIST+uyZSXUIWtRp76JpME4XsSbcRzo2YA+RpJnJhXiVLbKxlJIBnSQ+wHNM
         QvsoE5yPiNJgPFMahU1V+HtjQlshcD2dxYXDmePfCAXQxhjnsbYlYa2RuM0yAIFmVtkL
         b0fDwJREk9StpiLFYHm2tPMmwLtazP5cfKIid7HvANCawPlHOBD6xgWt+ARRzfdWrx9x
         pKp/tOJRLnqxY8T1H6an6/3DzhlTby8EeoMRYovxS4Jg9dM+LV8K4hcoPxmr4ufFHDAW
         osdUTDbXK/dHRehou//4f0xywlVQGhfzh2vTMiPEQArmqMj4IEuGMH1kCnalSHNhVk48
         U+Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ew2Jpv/icPL2fFBz/NSetkxvuqhRbbQqlWSu01ZZe7k=;
        b=UGeN1zepLjNdZuV58nat4m//uEPTtVAjurwHH+mD6SS2wNlpIg24nDbEJQizhOz6dM
         Ax7PI3F63Q2Yst2+4TN4rDYqwH/Mc+NSBYVs9NlJSeLLW4Vhd1JLwzxjCOiHRKhZsG83
         WJFAJSTtvj3PtKoq+ucVukmSS4gy1PXdPb4q74Je0wHZj9eyIfsgMstBULHpgrFqbhc8
         VfbSHB0HgmxBxNe/dD79BwE7x9WaaUqQ07dH44isgGQ8krm0dWe13Ab2dy8gkBEsHpTi
         QXnB6853nUUjtdp960llATje9nWGrFI1IVvIZ0uI/kV/e1AizVkRoc1lt0ZbI9cgvNQL
         peJQ==
X-Gm-Message-State: AGi0PuYTgOveicUMMYdP1hqPEdSvtUVLlNwkv32YmYwlMQZ2qpny0Tr7
        12r4yHb9K1WhSKq4OmZrF3i2abkV6OA=
X-Google-Smtp-Source: APiQypLzTUOypQ2yuVImV2sNpTdc2VAuClxn9BmdVyromIMQQ+fxm1Gz5aOheFx3O3KYZkekfvwH0w==
X-Received: by 2002:adf:dbce:: with SMTP id e14mr6432260wrj.337.1587674423909;
        Thu, 23 Apr 2020 13:40:23 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u17sm5933726wra.63.2020.04.23.13.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 13:40:22 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Joe Moriarty <joe.moriarty@oracle.com>,
        Steven Sistare <steven.sistare@oracle.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 05/16] drm: NULL pointer dereference [null-pointer-deref] (CWE 476) problem
Date:   Thu, 23 Apr 2020 21:40:03 +0100
Message-Id: <20200423204014.784944-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200423204014.784944-1-lee.jones@linaro.org>
References: <20200423204014.784944-1-lee.jones@linaro.org>
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
index f5229b083f8ea..abf5bd09de33b 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -1036,10 +1036,12 @@ static bool drm_dp_port_setup_pdt(struct drm_dp_mst_port *port)
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


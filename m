Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9275E19C9C4
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389006AbgDBTRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:17:16 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43961 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389016AbgDBTRQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:17:16 -0400
Received: by mail-wr1-f65.google.com with SMTP id 91so3656196wri.10
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+fghok1gB+76TrHDpTqaBXzeyc4G/qE0r24JbvN7snI=;
        b=nGM+IvJ9G+y4fTE/Cm4jkUF9UoE+h3zn2P1tp/kQ9/laQxjJoRim0wC7Q9mJl/UV7r
         wxtZLZdPbd0Qy8JTjgooZoPK11+4C/ERCvMDep0IFosz51ibmJ8hGHSGFzNkGD15MFfs
         FKSZGujJjH/GLlGJ34D5DPY/r5xGuhCU0xlVnSpTc7tvCtbVnIFIJq0DPuGx/yGvTzJn
         6NUJCT7IwyE1/eUCdosLxxtY3dTaEdeH+KIklqbgBK4Fk7sq7lxgl5Q7lu+yvJdQck09
         82erUN2CvBHKQRoF9IR85t9xL9ve3YptK8rL4ygbzoc9s5IkPk9yv0JpD/XtP+QhmZIS
         gijg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+fghok1gB+76TrHDpTqaBXzeyc4G/qE0r24JbvN7snI=;
        b=rvF7IDumajm17u3eLA05G0JhJ1qzzXpX4HwGEoouBqaB9f2C77NQDw/QjzofLWHjTw
         iRbvqxK81P0mQ8VJRrkEop7i6OwxvE4IdgBaKqn3YrIL4WTA1Xk6zIxh63u+hAjm7Ywt
         ltZH9iSgNFb6ChAEqbXBpZuYZkDKcViOlo2FlC8MZEMJHRdibvhUcjx9A17R5EBBnpSY
         vc/+sDqztmHvJms1z0wIFgVyycdJou0oKPiRD+JTiwIfr1BtDf9i5IGeyrvDvCt8OSXT
         taWZpsKM+Ax8t+nrycn0q2C6pnN2P2L01k3y+IiKjvAf5v5fFkHcEf7GKfkvGWMzkjSN
         C/FQ==
X-Gm-Message-State: AGi0Pub2zXRV0uL/KxZCUsdmOq3hnYGgSH+lcNYHMWpIVVTGrwjrXtjR
        3s5i+0tdldmLmfJqfS+NBeByJHC4GNEYkg==
X-Google-Smtp-Source: APiQypKpjZxxGup4NU6x44SKP3sGsIFkiI0INdglIvikhyZf2Gp+jGMrexEBjxjwhPij8ceyIsncLw==
X-Received: by 2002:adf:dfc6:: with SMTP id q6mr4645356wrn.325.1585855034494;
        Thu, 02 Apr 2020 12:17:14 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y1sm879050wmd.14.2020.04.02.12.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:17:13 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 20/24] of: fix missing kobject init for !SYSFS && OF_DYNAMIC config
Date:   Thu,  2 Apr 2020 20:17:43 +0100
Message-Id: <20200402191747.789097-20-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191747.789097-1-lee.jones@linaro.org>
References: <20200402191747.789097-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit bd82bbf38cbe27f2c65660da801900d71bcc5cc8 ]

The ref counting is broken for OF_DYNAMIC when sysfs is disabled because
the kobject initialization is skipped. Only the properties
add/remove/update should be skipped for !SYSFS config.

Tested-by: Nicolas Pitre <nico@linaro.org>
Reviewed-by: Frank Rowand <frowand.list@gmail.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/of/base.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index c66cdc4307fd7..af80e3d34eda7 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -170,9 +170,6 @@ int __of_attach_node_sysfs(struct device_node *np)
 	struct property *pp;
 	int rc;
 
-	if (!IS_ENABLED(CONFIG_SYSFS))
-		return 0;
-
 	if (!of_kset)
 		return 0;
 
-- 
2.25.1


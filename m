Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8D23A4022
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 12:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhFKK0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 06:26:37 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:39890 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhFKK0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Jun 2021 06:26:37 -0400
Received: by mail-wr1-f50.google.com with SMTP id l2so5488207wrw.6
        for <stable@vger.kernel.org>; Fri, 11 Jun 2021 03:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2f7/TFgLVrG5lfOiI4zi8HzRCiY/70uX27quxfvnzbY=;
        b=jKGxIQHdD6gjIrzQmopPo2aSyn3PhYLolsFqRZP4AnTV1WTgXzPoqql6wnFSyjQgOW
         popRktZsPNNUJEWKc45RrZ+3bgZKqK3Q42YExWMGLoLi4woqg2eRKMmwsTFlCjXpbdcf
         CbaVOEzAh7z+36/OnnZ4JJHsZywSCelJz/VZXkaDVGXfByvg8p/OPJP1duYohYQTV4DL
         bUzL4S9g6bgVSvDn26LNk38/v+RNfiWozQZSPHUmYyCvE9UJmbtF8S6KF1LrJrVkLH8f
         XkrXeH+7/tVvbSOTx0teONFsJ+608OB4C/FnCnmbSDW+76Ko0nVhzam+SLwmp08sRSd+
         xPBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2f7/TFgLVrG5lfOiI4zi8HzRCiY/70uX27quxfvnzbY=;
        b=q6n72GpRpN+oYpL8UxCHKXi4bvrANXu/Dx5SVAt3d8VZtKFHQKDNHJgDDxg0CU5ftR
         XkrfZReByt1BMs77d+SmL/sLqdqcqF34iknIvHwQvB2uL8vpaZNKbL/A3zqF0UaaCf68
         HtZdghZ37BL/VKTdKokkqYi1qzSHSMgpWIFmffQtqbtJehLoTNS3YPVeeqqdlR9/Z0br
         w6zXXhJYbVyUs9odcyD9Kxw7VRiCJiSO9hyIflcThMf/+UeTTPHwiaOCeuFDBf3lNr+a
         KOG8IxDqlgnpMnySsxdTkUbETK9y/6UEk2Nz94cPeLux6SM/SFUJvxP87NdgVX25DY5C
         6Hcg==
X-Gm-Message-State: AOAM5336N8bxGPOuEb/wmrYdfmcA5zylSK7A2OcWNhnNuTkQPcYL/uWq
        +jkYcHeWO7MBlBWZpn4a6tDL4w==
X-Google-Smtp-Source: ABdhPJynpROcL4L2ur8xqTkdkxNVoIs11LsQxNZpnDaajSSKsg/uqUJt3bEoU8GFkUsuyp9Ai94CRw==
X-Received: by 2002:a5d:47c3:: with SMTP id o3mr3305518wrc.122.1623407007638;
        Fri, 11 Jun 2021 03:23:27 -0700 (PDT)
Received: from srini-hackbox.lan (cpc86377-aztw32-2-0-cust226.18-1.cable.virginm.net. [92.233.226.227])
        by smtp.gmail.com with ESMTPSA id q20sm8317234wrf.45.2021.06.11.03.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 03:23:27 -0700 (PDT)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [RESEND PATCH] nvmem: core: add a missing of_node_put
Date:   Fri, 11 Jun 2021 11:23:21 +0100
Message-Id: <20210611102321.11509-1-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

'for_each_child_of_node' performs an of_node_get on each iteration, so a
return from the middle of the loop requires an of_node_put.

Fixes: e888d445ac33 ("nvmem: resolve cells from DT at registration time")
Cc: <stable@vger.kernel.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
Hi Greg, 

Resending just this one with cc stable as rest of nvmem series are already applied.

thanks,
srini

 drivers/nvmem/core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index b3c28a2d4c10..4868aa876e1b 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -686,15 +686,17 @@ static int nvmem_add_cells_from_of(struct nvmem_device *nvmem)
 			continue;
 		if (len < 2 * sizeof(u32)) {
 			dev_err(dev, "nvmem: invalid reg on %pOF\n", child);
+			of_node_put(child);
 			return -EINVAL;
 		}
 
 		cell = kzalloc(sizeof(*cell), GFP_KERNEL);
-		if (!cell)
+		if (!cell) {
+			of_node_put(child);
 			return -ENOMEM;
+		}
 
 		cell->nvmem = nvmem;
-		cell->np = of_node_get(child);
 		cell->offset = be32_to_cpup(addr++);
 		cell->bytes = be32_to_cpup(addr);
 		cell->name = kasprintf(GFP_KERNEL, "%pOFn", child);
@@ -715,11 +717,12 @@ static int nvmem_add_cells_from_of(struct nvmem_device *nvmem)
 				cell->name, nvmem->stride);
 			/* Cells already added will be freed later. */
 			kfree_const(cell->name);
-			of_node_put(cell->np);
 			kfree(cell);
+			of_node_put(child);
 			return -EINVAL;
 		}
 
+		cell->np = of_node_get(child);
 		nvmem_cell_add(cell);
 	}
 
-- 
2.21.0


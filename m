Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4F810E825
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbfLBKD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:03:58 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42428 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbfLBKD6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:03:58 -0500
Received: by mail-wr1-f68.google.com with SMTP id a15so43402850wrf.9
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=eItUHcPLnmpp23VMH3D0N31hOVNXeHzTJKuy0k/hYsU=;
        b=SOcZYQEb9Klb5wWtzzOsP+JSBh3vl6wZAgH/PS1GQovbhcVeTGlQ+35kWkJfiEySSM
         xAxhUVmCrVDOxRG4zxIBp2PrYqoPlihV63Zs2Ie9YcETRwQ1f650vSJx8+WMi7yPFOIn
         0yv7orzTsMm5LWRYYLiHKq+f6XogQ/+wq5See1boGLhrt8rLBYxwjPMlE0mGI1vsqBTW
         5OP6ioC8vWwIYjdOecA+h6b88YCoGAEKViKfjE0NBkQkXXHQkmR/GdDqu/iatmGnKZNw
         mB7SYE0CV7nE1MaOOER123yDQVfPfrol/6q+lHaaR54D0ne96OyvhjZCXFDNEC2jhpSf
         eLSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eItUHcPLnmpp23VMH3D0N31hOVNXeHzTJKuy0k/hYsU=;
        b=mLNxH4VlbenQK/xFgUEdNlsPCNbqVURMcnsv7z9eHpXKlH2xuRC6Qu+zdaxdwEEnsM
         m31hvyc4NG2mkRFOuZMilzl33C8sInSTX9xLMiXCXOP//tecESsMa7IzHKc5e+lhT51k
         YouClIlMqtyUtMESf21g1hF5P9xP5YqO8Hw2UZX3RipPRYcoinRQ7RzlzPc7iSGZ+DAQ
         7h5fOwSPe4Et5d2bioOSmVPmCiXEDPYtDFupvSZ2ylzPjJhqh9Inaw87rTDKD44m23qQ
         OGcYZDfCUUHdnoWF8x870HALuNDf6pEWSq/t+z0CpVd2HqXfXi0xQ836XKlTWQsccpXw
         SbZA==
X-Gm-Message-State: APjAAAV4lXJbeHrD0F26aqvQvYTXVq3VZ0hpWKNN3liKhjxF/FsAxhRo
        npFEoVnqQvVUIv7mGIvOzkhyvnbA8sg=
X-Google-Smtp-Source: APXvYqw0c4rcT6KMBiM6vL3lWAJU4+aEzKkcb1c/vk/T/BAMrxOrtzaU/XBeu6lQYra/LHwa+c/RHA==
X-Received: by 2002:adf:9c81:: with SMTP id d1mr66930612wre.144.1575281034857;
        Mon, 02 Dec 2019 02:03:54 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id h8sm22975665wrx.63.2019.12.02.02.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:03:54 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 07/14] media: atmel: atmel-isc: fix asd memory allocation
Date:   Mon,  2 Dec 2019 10:03:05 +0000
Message-Id: <20191202100312.1397-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202100312.1397-1-lee.jones@linaro.org>
References: <20191202100312.1397-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit 1e4e25c4959c10728fbfcc6a286f9503d32dfe02 ]

The subsystem will free the asd memory on notifier cleanup, if the asd is
added to the notifier.
However the memory is freed using kfree.
Thus, we cannot allocate the asd using devm_*
This can lead to crashes and problems.
To test this issue, just return an error at probe, but cleanup the
notifier beforehand.

Fixes: 106267444f ("[media] atmel-isc: add the Image Sensor Controller code")

Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/media/platform/atmel/atmel-isc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index d7103c5f92c3..504d1ca0330e 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -1722,8 +1722,11 @@ static int isc_parse_dt(struct device *dev, struct isc_device *isc)
 			break;
 		}
 
-		subdev_entity->asd = devm_kzalloc(dev,
-				     sizeof(*subdev_entity->asd), GFP_KERNEL);
+		/* asd will be freed by the subsystem once it's added to the
+		 * notifier list
+		 */
+		subdev_entity->asd = kzalloc(sizeof(*subdev_entity->asd),
+					     GFP_KERNEL);
 		if (subdev_entity->asd == NULL) {
 			of_node_put(rem);
 			ret = -ENOMEM;
@@ -1859,6 +1862,7 @@ static int atmel_isc_probe(struct platform_device *pdev)
 						   &subdev_entity->notifier);
 		if (ret) {
 			dev_err(dev, "fail to register async notifier\n");
+			kfree(subdev_entity->asd);
 			goto cleanup_subdev;
 		}
 
-- 
2.24.0


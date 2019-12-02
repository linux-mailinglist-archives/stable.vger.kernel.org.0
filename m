Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7617A10E7F1
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 10:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbfLBJuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 04:50:39 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41094 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfLBJui (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 04:50:38 -0500
Received: by mail-wr1-f66.google.com with SMTP id b18so43349132wrj.8
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 01:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=sTCSXd78U2S/J9+STbmGQvoMaUMY3h0oPjBdZMZTRIE=;
        b=R0Ig0HYRN+qNhimffv4Awp+ud4+0Ohj2iBqYbDnJqOmtT2ljqzKm/B9LsnQ98vA9u6
         rVmg+bqhBAJkKw+ahqOP5kYQ9KwD3qQwu71XdMpgTY5x22URu2VR2d3Y3iaXJxlseFzL
         ILxW/lPu1pvJuNVRRSLdIzREHXW4kLvcdfJozxoYftMEHfg1vU8L4nuKhIHqy1bBrkIn
         HvncZSIxxan+mJGwoaevZhr4WlxpkfynzM5bC11/6j0o562acFGR2Y/7P49aTv05oXwu
         1oGlRbNGNH6AXBmFPJcpTN77Kh+1WUkUtAhJiR2THK4DNZT+gXWnJqLXwOeZBfmnee2Z
         y1Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sTCSXd78U2S/J9+STbmGQvoMaUMY3h0oPjBdZMZTRIE=;
        b=LuCKNrpkij3MzXXlZyE9yg3VWQ4MopgOxaKF4ljTp7IdsoxqAdgRbgjjU2qVDMql4D
         JgDzBHS1hdjWZAe29kEmoHFV2f4pnxTuwwsz8WsRd/Nyhx/+ViKr5kGuGFfOcOPiRGE8
         DPCB4vcT49UTCVd6w3FzroG6rqlhnVROxRPkyHl6+eYuAIbDoqg2eIsrw5u5Obo4ocHf
         mwGxNfJ9KPE2ZI7g16GiGJ3fsC0Nzzm8n1A51Ag166ZtQ+IAvi5BAm32nrKxmnELXvkT
         RMttgiAHVW01LQYSQ10mHvRxqcYt+HBiDJxLHC+AzNpc2vnsP6opeaU/JkL+sWMCatF/
         81hw==
X-Gm-Message-State: APjAAAVkLD/79TZnq1Lr+QPFuCxLyxgTX404PHo8IvUDuYmRuBIY1y1y
        03jBn6jpMV1zjCi2J0gyO3K+z4s5xvs=
X-Google-Smtp-Source: APXvYqwezWBq31hjIMSLZAguDvoyMCrf0AaJb2fxDieQgBu+Fjveigsg7GlYJJ9duAD8BlQvrwtjZQ==
X-Received: by 2002:a5d:49c7:: with SMTP id t7mr12719589wrs.369.1575280236523;
        Mon, 02 Dec 2019 01:50:36 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id l3sm4629698wrt.29.2019.12.02.01.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 01:50:36 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 5/6] media: atmel: atmel-isc: fix asd memory allocation
Date:   Mon,  2 Dec 2019 09:50:11 +0000
Message-Id: <20191202095012.559-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202095012.559-1-lee.jones@linaro.org>
References: <20191202095012.559-1-lee.jones@linaro.org>
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
index ccfe13b7d3f8..ecf9fb08f36b 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -1297,8 +1297,11 @@ static int isc_parse_dt(struct device *dev, struct isc_device *isc)
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
@@ -1432,6 +1435,7 @@ static int atmel_isc_probe(struct platform_device *pdev)
 						   &subdev_entity->notifier);
 		if (ret) {
 			dev_err(dev, "fail to register async notifier\n");
+			kfree(subdev_entity->asd);
 			goto cleanup_subdev;
 		}
 
-- 
2.24.0


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC04A4E8631
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 08:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbiC0GKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 02:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234284AbiC0GKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 02:10:11 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45F9336;
        Sat, 26 Mar 2022 23:08:32 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id n7-20020a17090aab8700b001c6aa871860so12514272pjq.2;
        Sat, 26 Mar 2022 23:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=WLGme/rACNlsZ/NoBqpCvphC8ae3fvVeZ1qiIRGm49Q=;
        b=XxWXZt/CIQ5HISAsyoesltjNLHrlcH2NIr1yONMkl0bplVYnpAG5GWej4Clhp3dLO5
         GvKx1+YJuelabHz0EuPlf/SFVYswpHRzDiUU4hyRv+FoH+Qsoz7K/CmNJ4y2mUyobXMO
         i+luyiWxak5Ntcr5wR4x0YJ18XnvdMhBbEEvd/gyVEXV5QkbQwmOjOQzGK2PG+SsRlIE
         92FSexrViYOC1HdAVoLO4Faox6KBxhSafHvgs8xTV+0PgfR9kFl5fkvyjp+NpG0C3Yic
         6O5DsvsST/pHNi2c8POVbXvpSvYd2wvu4fNOd8jWvhGJ0PH61VEUULiCffcvBKkSJoeE
         +A0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WLGme/rACNlsZ/NoBqpCvphC8ae3fvVeZ1qiIRGm49Q=;
        b=RDF5sdVA+vFvnkUPibEAkPy7V1Hjq02JQjCyClBdxrw2yMjV19Jd7wxNdoklnPBGr4
         XWbY/Gb7S/uNaKvg1i1eo4CnN76RHOUefAtam6ZYUsbJghV0UjK7nPDB3uuDR4MSDR0D
         VGrG7TpyWlcNbb02WTQ0Am8Wsg/J4Us6jZTHeTI8Y5xSxNxqf6UnD2BbLECl0Wx8F6rs
         +ZXnEHPwnrLAVvFPq1kIpWbclVhQNlJ1StwhoVgAWDNqrH09Jewk/WyBCBF56617kWV8
         RwbT7LnncKvoHOG9RgwyMMfKS+5Ii8Fqk5532rK/vZAAL8+OLomx2g7v7zQXWh1q1Bxk
         1mvg==
X-Gm-Message-State: AOAM5313MD8K4skBfjTnDIWLYhNxKHlm6S60VFGYjTSbNYJb5qE0Omab
        k4DQmO/A4rX0RZ52VC8NFMSzxfr6UjxTxA==
X-Google-Smtp-Source: ABdhPJzijW7TduNxnjGw5WJJDKE1+upP6F6srZfdjFLh9QanrNnahAQOypcz+SZL3SPFyXcGFOR1GA==
X-Received: by 2002:a17:90b:4b06:b0:1c9:9751:cf9b with SMTP id lx6-20020a17090b4b0600b001c99751cf9bmr1363741pjb.0.1648361312296;
        Sat, 26 Mar 2022 23:08:32 -0700 (PDT)
Received: from localhost.localdomain ([115.220.243.108])
        by smtp.googlemail.com with ESMTPSA id m18-20020a056a00081200b004faeae3a291sm11239661pfk.26.2022.03.26.23.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 23:08:31 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     perex@perex.cz
Cc:     tiwai@suse.com, krzysztof.h1@wp.pl, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] cs423x: cs4236: fix an incorrect NULL check on list iterator
Date:   Sun, 27 Mar 2022 14:08:22 +0800
Message-Id: <20220327060822.4735-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bug is here:
	err = snd_card_cs423x_pnp(dev, card->private_data, pdev, cdev);

The list iterator value 'cdev' will *always* be set and non-NULL
by list_for_each_entry(), so it is incorrect to assume that the
iterator value will be NULL if the list is empty or no element
is found.

To fix the bug, use a new variable 'iter' as the list iterator,
while use the original variable 'cdev' as a dedicated pointer
to point to the found element. And snd_card_cs423x_pnp() itself
has NULL check for cdev.

Cc: stable@vger.kernel.org
Fixes: c2b73d1458014 ("ALSA: cs4236: cs4232 and cs4236 driver merge to solve PnP BIOS detection")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 sound/isa/cs423x/cs4236.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/isa/cs423x/cs4236.c b/sound/isa/cs423x/cs4236.c
index b6bdebd9ef27..10112e1bb25d 100644
--- a/sound/isa/cs423x/cs4236.c
+++ b/sound/isa/cs423x/cs4236.c
@@ -494,7 +494,7 @@ static int snd_cs423x_pnpbios_detect(struct pnp_dev *pdev,
 	static int dev;
 	int err;
 	struct snd_card *card;
-	struct pnp_dev *cdev;
+	struct pnp_dev *cdev, *iter;
 	char cid[PNP_ID_LEN];
 
 	if (pnp_device_is_isapnp(pdev))
@@ -510,9 +510,11 @@ static int snd_cs423x_pnpbios_detect(struct pnp_dev *pdev,
 	strcpy(cid, pdev->id[0].id);
 	cid[5] = '1';
 	cdev = NULL;
-	list_for_each_entry(cdev, &(pdev->protocol->devices), protocol_list) {
-		if (!strcmp(cdev->id[0].id, cid))
+	list_for_each_entry(iter, &(pdev->protocol->devices), protocol_list) {
+		if (!strcmp(iter->id[0].id, cid)) {
+			cdev = iter;
 			break;
+		}
 	}
 	err = snd_cs423x_card_new(&pdev->dev, dev, &card);
 	if (err < 0)
-- 
2.17.1


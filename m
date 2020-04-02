Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97A0719C9A5
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389148AbgDBTNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:33 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42779 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388905AbgDBTNd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:33 -0400
Received: by mail-wr1-f67.google.com with SMTP id h15so5566503wrx.9
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=2MkvQNPZKVczY76MLBPwTTDhOiywokrQfHFs6PMyPNM=;
        b=ftBVqR332alamOZ5Ygg9RY/8GrHtMztd3F9FtFOU+sNADu7JaOdjG8eoayKOdvamrS
         RVYyxIb3FIRHkI0Rc9i2FdCzVWJMEHRmEEXBDKQT36gSdlBrLuJCzmrrzp+o5CRT4Si2
         ALgSAn7TP3mbbZfDqxUD+h+FvfBIridj1f1wcPPpZTP08G+gWBx81f/WrWqzFk/S3nBa
         OWVtruwZ8N5wSUD9MksFPFImy54v+mXg034Yrgp8qoiuUsLjSmxL2wBQf4JZL9uMKfBU
         oP2e+6x7X1p4DZ7bO+AkCevskOEuUB2hkrUzXTtrX7e2AofUxGYMLQ//hfBx2KeA1tsH
         gf2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2MkvQNPZKVczY76MLBPwTTDhOiywokrQfHFs6PMyPNM=;
        b=YeQ7hdnqIRYq5dfX7QDzp435vkOpuGhhADX0ZSqnOU3pF0TBoVW05ST9zvqXIVL93S
         GU10+ScOgZxqp9UDJNo1dKCwi7TgiAsWSfTKaqYwoeIPDVb+KaXmdhwDk5/SN4hsL+Yt
         xUGdMAfkgegH68eIKd/gKIBgKhRKQrSTTeyqerc+vqHTQ/Xn/kVqyOcTbg/T/m1peHne
         j8MhSjjW+Xh+uP3vP6jm7tlLMV15YobPtS/do4BxzXHYiVeGFM/ICYsMhsDEtv1Haals
         JTS70ck0tIsm7KmMW3NltxZaQwu3pR+dk7dZY+3yDwAaSfE3Y+XfZeYf7BFv7i0eFbCW
         hLqA==
X-Gm-Message-State: AGi0Pua3BJPni59b8sYBujMQIE4YEqY7YP5qNwl37wJzlX1PjXUE8I3s
        Cng2Gv49+5tit83mD5ZggJRFqcRgj21Ejg==
X-Google-Smtp-Source: APiQypL3zNt6cMmCh/zgigTRlQg8i24QXorK2ThIMmm+IQbbutTMUWiPclP3GcWzhkt521etvqdkXg==
X-Received: by 2002:adf:f3d2:: with SMTP id g18mr2336956wrp.356.1585854808565;
        Thu, 02 Apr 2020 12:13:28 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:27 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 29/33] of: fix missing kobject init for !SYSFS && OF_DYNAMIC config
Date:   Thu,  2 Apr 2020 20:13:49 +0100
Message-Id: <20200402191353.787836-29-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
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
index 41b254be02954..c0281be8e0611 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -169,9 +169,6 @@ int __of_attach_node_sysfs(struct device_node *np)
 	struct property *pp;
 	int rc;
 
-	if (!IS_ENABLED(CONFIG_SYSFS))
-		return 0;
-
 	if (!of_kset)
 		return 0;
 
-- 
2.25.1


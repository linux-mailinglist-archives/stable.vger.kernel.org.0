Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD3435489A
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 00:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242775AbhDEW0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 18:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233086AbhDEW0G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 18:26:06 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122D9C06174A;
        Mon,  5 Apr 2021 15:26:00 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id g35so4242789pgg.9;
        Mon, 05 Apr 2021 15:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KMtwWkQkvXCG9ApdI46fa9X/Y5SNl/moZ1tKhqcTtCI=;
        b=luWp4ZYaJWIjExW6V5nfUsxeMIFtJ2h95wCvaOpCUnYrxat4soAUDpW+h+/WYydO/F
         5wS/H/Pjm8Y8LFepCf+hnogpLQOCrtxISHZkS8KvjZgUAWPDfFdaC31SLIhioqLfN8gs
         0lO3qy3G5VvW74JRihM9R4dYO350Y+Hl56jhp8t/4i9nf2Xaq/HhJns+QsZI2Ml5hC3Z
         Cl3HrVjemhIytsv0dLIaaJ/JeeZbn5lbUf9FCVE6KGEgZ7WpHmUF+UotbYdhE1sgJO5m
         LqEHUbI73aAupJBp48WoLemUuPlFSV0afJxZkevGCxMecQHV08wvpxBZOOWDXBi53F6u
         EJsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KMtwWkQkvXCG9ApdI46fa9X/Y5SNl/moZ1tKhqcTtCI=;
        b=P7ekDQQHdl3wUytHUhVgieOv1HXh8+Y8Yo52AnyvZHg2eeTWchGrEw1NU7mFj1oDxs
         ZEgSlfqpcSOt2BhctzXQsvSFjymzFPETAbajZn0nR+mEieNkq8OqqQyFTNoW0bbRN+B+
         SObCtni7RmOaJZ9YzhSJH+XFQ1xLUmGiM4a2Bw3TMhy9XQ9HWju/50/43w308+5gOAkM
         ohA0/Q53fHfRewSJ9f96xYYLsyZIIiHSDUQIChSXL0xuklxtMjN3I2v7KZ9gqsLRB9Rl
         /gq5SCANmhUMFjj3p2sd84T7+Zz2giIZDJf5b8te4Ssshlp+Qv1VFQMsqi2pBYz2Sn+7
         Kw1w==
X-Gm-Message-State: AOAM533zGxRTYkwsrN/pd/glzHBOR14HPXddInHtVDCMEYuEKpjZuyBC
        E8ASN2r1jJbO0tUhZWARTavzyBvdp1RiiCdU
X-Google-Smtp-Source: ABdhPJxrG+16+yVU1OTDjqemXx3rOSKG1agMiShN2dHf6cAloz4l15x/3kvXKKfKYrY45Qf2nljHvQ==
X-Received: by 2002:a63:c807:: with SMTP id z7mr24337260pgg.363.1617661559642;
        Mon, 05 Apr 2021 15:25:59 -0700 (PDT)
Received: from ilya-fury.hpicorp.net ([2602:61:7344:f100::b87])
        by smtp.gmail.com with ESMTPSA id 15sm16430919pfx.167.2021.04.05.15.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 15:25:59 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Saravana Kannan <saravanak@google.com>, stable@vger.kernel.org
Subject: [PATCH v2] of: property: fw_devlink: do not link ".*,nr-gpios"
Date:   Mon,  5 Apr 2021 15:25:40 -0700
Message-Id: <20210405222540.18145-1-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405031436.2465475-1-ilya.lipnitskiy@gmail.com>
References: <20210405031436.2465475-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[<vendor>,]nr-gpios property is used by some GPIO drivers[0] to indicate
the number of GPIOs present on a system, not define a GPIO. nr-gpios is
not configured by #gpio-cells and can't be parsed along with other
"*-gpios" properties.

nr-gpios without the "<vendor>," prefix is not allowed by the DT
spec[1], so only add exception for the ",nr-gpios" suffix and let the
error message continue being printed for non-compliant implementations.

[0]: nr-gpios is referenced in Documentation/devicetree/bindings/gpio:
 - gpio-adnp.txt
 - gpio-xgene-sb.txt
 - gpio-xlp.txt
 - snps,dw-apb-gpio.yaml

[1]:
Link: https://github.com/devicetree-org/dt-schema/blob/cb53a16a1eb3e2169ce170c071e47940845ec26e/schemas/gpio/gpio-consumer.yaml#L20

Fixes errors such as:
  OF: /palmbus@300000/gpio@600: could not find phandle

Fixes: 7f00be96f125 ("of: property: Add device link support for interrupt-parent, dmas and -gpio(s)")
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc: Saravana Kannan <saravanak@google.com>
Cc: <stable@vger.kernel.org> # 5.5.x
---
 drivers/of/property.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/of/property.c b/drivers/of/property.c
index 2046ae311322..1793303e84ac 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -1281,7 +1281,16 @@ DEFINE_SIMPLE_PROP(pinctrl7, "pinctrl-7", NULL)
 DEFINE_SIMPLE_PROP(pinctrl8, "pinctrl-8", NULL)
 DEFINE_SUFFIX_PROP(regulators, "-supply", NULL)
 DEFINE_SUFFIX_PROP(gpio, "-gpio", "#gpio-cells")
-DEFINE_SUFFIX_PROP(gpios, "-gpios", "#gpio-cells")
+
+static struct device_node *parse_gpios(struct device_node *np,
+				       const char *prop_name, int index)
+{
+	if (!strcmp_suffix(prop_name, ",nr-gpios"))
+		return NULL;
+
+	return parse_suffix_prop_cells(np, prop_name, index, "-gpios",
+				       "#gpio-cells");
+}
 
 static struct device_node *parse_iommu_maps(struct device_node *np,
 					    const char *prop_name, int index)
-- 
2.31.1


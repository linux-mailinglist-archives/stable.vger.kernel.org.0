Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B2A56347F
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 15:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiGANoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 09:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiGANoU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 09:44:20 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F9422512;
        Fri,  1 Jul 2022 06:44:20 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id lw20so4181796ejb.4;
        Fri, 01 Jul 2022 06:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GjlrXgSVfip4RUERiLeIPiEhdykTYrOkMAgjg1op1mc=;
        b=nlJNyqRjm4HaH7m5sfjgLw/CtWj5kx0oxnzWYDRqoRQtR2Cd7tZoLxi9FWMdVJmXkZ
         aKu387eKzm+9U7hE+FFcMd5dAhDAZNWhDHIhsIUW3rahzykjEBydCNtreZN8ypg4vQus
         kj8GOeiv7qgmgnnHKuwE6riw8VtnXFftb3K44bClPW1qSMDINo5JcxO6ZA1B0Ji4gDaK
         oCEmQDcHia0Pwz8lSGP4CJwkpACb8I0K1cWjeBRvxRtLhm769iXBSbQBmpal6sPqePqJ
         dXU7i6eOvLRhDdW1tsojm/PPG3RxCgBszKjWijcsw+DY5U1b0iNgTFAHDVY0UdK55/UV
         0cOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GjlrXgSVfip4RUERiLeIPiEhdykTYrOkMAgjg1op1mc=;
        b=vOyPxdD9MJZy+9p1MLGBIJVfkmyYQ1Fu23nDb6uiw79RwMQZy/WyWab3ihegUUC0dj
         oHlRRJL7LmoBoLPqmPAHsspPQ+nMvlMPxGxIywot/dRho3OG/9xj6JtStgdjmjVTZ6E/
         rUAovV6j5qEIMlKLovcTf/lzffovkYx7e9Y/z1n/qEQJEO0u5/79K8FGiCGk8WcePDCh
         pfU5Tdgmupbt0i2+/eI72SLA7kZwCL90Vq2QPj+2jyx2qzEeYc3ijyinlSixUN/Cmo79
         ZPZnSR/CPp/222SgkNm8RZ6nWpp5AtZWgs+lM/X1PJO327/NngIGRjTqsV/lG64x7Az4
         dI6Q==
X-Gm-Message-State: AJIora+OjPzVlHFmM4kmtx5CWY4+jcH8uForgH0Wf9EyKZRBH+29u4gJ
        +92N26uB1igX+q1x1zsUZSE=
X-Google-Smtp-Source: AGRyM1v1EvEsJAZzweGXnaZW5CIwk/ZPh7dZYGQ4CVU2YZ3BJ5bo0PShvbLQOmAhS3Q05MEjOAWybg==
X-Received: by 2002:a17:906:29d:b0:6f0:18d8:7be0 with SMTP id 29-20020a170906029d00b006f018d87be0mr13750094ejf.561.1656683058468;
        Fri, 01 Jul 2022 06:44:18 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id g4-20020a170906868400b006fee98045cdsm10698220ejx.10.2022.07.01.06.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 06:44:18 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-pm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH v2] PM / devfreq: exynos-bus: Fix NULL pointer dereference
Date:   Fri,  1 Jul 2022 15:31:26 +0200
Message-Id: <20220701133126.26496-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix exynos-bus NULL pointer dereference by correctly using the local
generated freq_table to output the debug values instead of using the
profile freq_table that is not used in the driver.

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Fixes: b5d281f6c16d ("PM / devfreq: Rework freq_table to be local to devfreq struct")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/devfreq/exynos-bus.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/devfreq/exynos-bus.c b/drivers/devfreq/exynos-bus.c
index b5615e667e31..79725bbb4bb0 100644
--- a/drivers/devfreq/exynos-bus.c
+++ b/drivers/devfreq/exynos-bus.c
@@ -447,9 +447,9 @@ static int exynos_bus_probe(struct platform_device *pdev)
 		}
 	}
 
-	max_state = bus->devfreq->profile->max_state;
-	min_freq = (bus->devfreq->profile->freq_table[0] / 1000);
-	max_freq = (bus->devfreq->profile->freq_table[max_state - 1] / 1000);
+	max_state = bus->devfreq->max_state;
+	min_freq = (bus->devfreq->freq_table[0] / 1000);
+	max_freq = (bus->devfreq->freq_table[max_state - 1] / 1000);
 	pr_info("exynos-bus: new bus device registered: %s (%6ld KHz ~ %6ld KHz)\n",
 			dev_name(dev), min_freq, max_freq);
 
-- 
2.36.1


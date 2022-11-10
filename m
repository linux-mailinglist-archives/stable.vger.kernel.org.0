Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C05F96246BE
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 17:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbiKJQUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 11:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbiKJQUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 11:20:53 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8AD13F64
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 08:20:52 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id ft34so6177980ejc.12
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 08:20:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:message-id:date:from:content-transfer-encoding:mime-version
         :subject:from:to:cc:subject:date:message-id:reply-to;
        bh=DeTQBsnVil4skLVb0JTYA0ze/q8Y7Qzt3eBgeJWs+Xo=;
        b=GKJkmTIUnrs5ihbdB9mi5Xs1cdxoZafh9Hi5mwHvDqnRpzX1Kv7B2F0E7otQXIbQaw
         drCybDDsVpM3uH8w2nuxWkc14OrMf1+ciOQQI0ya/CoWunaxOxkN3hPVHCNtlnue2gFk
         52fMkaORsXWbzseWYaPLOVKIDJcfT2ricES00=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:message-id:date:from:content-transfer-encoding:mime-version
         :subject:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DeTQBsnVil4skLVb0JTYA0ze/q8Y7Qzt3eBgeJWs+Xo=;
        b=zVq6MP67eCBKhAcAthAa4wuFS+vyt7Vb6hfVnXN/I6g1GDNitnopbVsHpG1cUw9uKk
         kWyuDrw3I6ccnJ2ywGm/3jy3XHQsUSXA8gAkFoIHsws4GNZ8TsZI9ZTQoJOjj9SLvSEL
         98pK20eEifev9qw5sOX6RpiQqqfRBAWAHTEmktrxO6PRCcTdtRIXYWFoOA+rQ8Ftf2pA
         MvIbrXllp4ZF2rJm7w4HJeg0XhKmoKyKVBiFW9O3OMXRBuXGurF+DVBZnPIMZmiGJhL0
         JRZBCUXnikh2Dbnf//TG9viHJioAcddAQ5tSlMI3rntENEPrSkvD45LacewijwxQATIy
         7s0Q==
X-Gm-Message-State: ACrzQf3oiIX1/gNZNDu9wBZ7T1anK+Umg3HknhZE7DS4AYXNTVw3OCkz
        bEUWFmqICXa/9g2EaGuIaTMxVQ==
X-Google-Smtp-Source: AMsMyM7Dt/Oikt/kQR0FcIfkSY10NFM7DFTTRHXFPDf41TQumRWAX1p856DgQOmzzDxBxwNbjj+v+A==
X-Received: by 2002:a17:906:8b81:b0:7ad:93d1:5eae with SMTP id nr1-20020a1709068b8100b007ad93d15eaemr62378695ejc.29.1668097251178;
        Thu, 10 Nov 2022 08:20:51 -0800 (PST)
Received: from alco.roam.corp.google.com (80.71.134.83.ipv4.parknet.dk. [80.71.134.83])
        by smtp.gmail.com with ESMTPSA id e8-20020a170906314800b0077b2b0563f4sm7510193eje.173.2022.11.10.08.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 08:20:50 -0800 (PST)
Subject: [PATCH v5 0/1] i2c: Restore power status of device if probe fail or device is removed
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-b4-tracking: H4sIANYkbWMC/3XOzQ6CMAwH8FcxOzuzjQ2YJ9/DeNhHgSXAkk1mDOHdrR4NnJo2/f3blWRIATK5nl
 aSoIQc4oyNOp+IG8zcAw0eeyKYEJwzTYNw9GVCAWpANx0Y3nGrCO5bk4HaZGY3oJiXccThEPIzpvcv
 v3As972owimj4BtmtLZaM39zQ4pTWKZLTD15YFARh1ggZo1SzHbCG+d2cHWIK8S+rRV3Vtq23bssD7 H8vi2lrmUt2qqyf3jbtg/GVtNkYQEAAA==
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Thu, 10 Nov 2022 17:20:38 +0100
Message-Id: <20221109-i2c-waive-v5-0-2839667f8f6a@chromium.org>
To:     Wolfram Sang <wsa@kernel.org>, Tomasz Figa <tfiga@chromium.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc:     Hidenori Kobayashi <hidenorik@google.com>, stable@vger.kernel.org,
        linux-i2c@vger.kernel.org, Ricardo Ribalda <ribalda@chromium.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org
X-Mailer: b4 0.11.0-dev-d93f8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1794; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=4clQAZaLvuRcOY86HZLxZyhWxEsEPqsm3+62UqWakNo=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBjbSTY+Kf+2Fhq4xTRwy1lq5DVpEm/1XKcBs3SBnbD
 PPrVTMaJAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCY20k2AAKCRDRN9E+zzrEiPEZD/
 9qBU465i41cAV/uiiHV6bOJFvKo8YJXGpn6qLRZaJFt+tP6IIh1WXuPblF38hOKMfF0V3FE115nk/1
 1qUdUX3UdHWsM9mtXdvS9uhoJTTJRC2H/0jSsY3etzA9nGlcRL3thGo5RMW4JsA+3QJhhv5xCshMoZ
 A6CAJkGJpKnodStNfMO2/WtpsrIeMDMIq3p1cbCosxgvG+D1+upNle++lncnzl2Li5TNT+Zhtd3lmz
 9iSjuzMNwICb+15q1SIdhaGLEUQIK/0Gjhsewq8KI9uzaCmYQ852WTmnvKCpxbG0DVAe0ieTKOtBd8
 OxD0h5zp2B4w7l/fdG+fHIwH62+2c5vO9mdvBFQNR9uKPDhOJ8zN5alyJ+Gn76cMzXGICbw9HkJ9m2
 Q5Jg6h/8eFj3Fp+1kTZz9nPGi4WjIIS6PP5dWSzkDkxXGaJ+EBo8xeX5DMNo3maBv1xcRzjnxTsXXK
 0MYWyxifouuDaOdabiU+mdmLDGfnZsPi+XjKDgJW3qrEmrM7uYNrF2FIpY6hO+pQrs59uz+PFVHlvS
 Z2yoAxZBjrL0sdahub533nPRvvI/0wXC61UaGwcR9Kj+Rqf3IivTPYE8FzHXXDxKA9nv1+Eu8TlVVq
 Vv7okpeMb4/zPyQUpG/KoixIyKAL/Qqcffj/GauplsZV5BSSH9v+neknhj6g==
X-Developer-Key: i=ribalda@chromium.org; a=openpgp;
 fpr=9EC3BB66E2FC129A6F90B39556A0D81F9F782DA9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We have discovered that some power lines were always on even if the devices
on that power line was not used.

This happens because we failed to probe a device on the i2c bus, and the
ACPI Power Resource were never turned off.

This patch tries to fix this issue.

To: Wolfram Sang <wsa@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Tomasz Figa <tfiga@chromium.org>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Hidenori Kobayashi <hidenorik@google.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
Changes in v5:
- Add Cc: stable
- Add Reviewed-by Sakary (Thanks!)
- Renamed turn-off as power-off, in the name of consistency (Thanks Sergey!)
- Link to v4: https://lore.kernel.org/r/20221109-i2c-waive-v4-0-e4496462833b@chromium.org

Changes in v4:
- Rename full_power to do_power_on
- Link to v3: https://lore.kernel.org/r/20221109-i2c-waive-v3-0-d8651cb4b88d@chromium.org

Changes in v3:
- Introduce full_power variable to make more clear what we are doing.
- Link to v2: https://lore.kernel.org/r/20221109-i2c-waive-v2-0-07550bf2dacc@chromium.org

Changes in v2:
- Cover also device remove
- Link to v1: https://lore.kernel.org/r/20221109-i2c-waive-v1-0-ed70a99b990d@chromium.org

---
Ricardo Ribalda (1):
      i2c: Restore initial power state when we are done.

 drivers/i2c/i2c-core-base.c | 11 +++++++----
 include/linux/i2c.h         |  4 ++++
 2 files changed, 11 insertions(+), 4 deletions(-)
---
base-commit: f141df371335645ce29a87d9683a3f79fba7fd67
change-id: 20221109-i2c-waive-ae97fea1f1b5

Best regards,
-- 
Ricardo Ribalda <ribalda@chromium.org>

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16B3353B0A
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 05:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhDEDPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Apr 2021 23:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbhDEDPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Apr 2021 23:15:00 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06056C061756;
        Sun,  4 Apr 2021 20:14:50 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id cl21-20020a17090af695b02900c61ac0f0e9so7703869pjb.1;
        Sun, 04 Apr 2021 20:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GceNoV8TahQ5tN9ED1/8GY0CKdqmMX+dizORs2wOPsI=;
        b=oonZHvVjrqKGsVfVWgbSh45r1gbAqGTpubcxSoGv0u2cP96yTsOIQhWkqMLQEOVXQr
         O+/mCU4+0I8R5v9ZgUEGMVKhG0hbXLB/pzpACTWW48BxWaLq21bxB9R4wwKHEZV0fC7m
         jKLdmwNFtmtYi/Z00HiWkOnhKFYl9+tmwu0ex+70eij4dIoNhMYoT8nyteiAmYQTcW2y
         /IgjTnOY78+D1foGeDG925vTBhzK+Q2WgvRI06/IvfP/w/qUokr+iZqO8nunN+gajuQL
         84JoEv3DrvM8m0mQLAW29kHisyX41fGeToWyWD4Qkn/yXxoLzpjoF8yOAj8p0QRtGiaG
         +h1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GceNoV8TahQ5tN9ED1/8GY0CKdqmMX+dizORs2wOPsI=;
        b=lnYx5UB/7FRLBBUREaRj2Jo98vXERKFKI2RnseBEPajuVKHE5Fu8azKHd7kMXXbe5O
         jCDtlvQuUSUPyFln/KdJxBNO2hrIa8uKrdB0WvOIZKx4RH0u7XhQhYx+yHmqWQyJ0t8c
         V5sGohaz+b01o4nRWjcwfGtBu+143uNQ+o0M/sJDxz8aZZf6NqYqZWhMQrpHr5PP0wFJ
         QDYUU1CSEK7g2RB7sgmO1cwXmKqy7gkzZbGf7PsbLtxrqnNTcuYHtEAJswbQvI37qsXq
         f9o5BhgeFrD7TW3CAdLlKELBv+dv+qc8m3npcxmYO9y6nlmpy1IgjMiMc6m4KOpX8zzc
         rIiA==
X-Gm-Message-State: AOAM530c7fGr6AEnwk0crzAmsGOk87j4FswgaL8owpyyYavgvCbSGBMc
        Nb1MtgKnvFXY7UbT2nXIsVc=
X-Google-Smtp-Source: ABdhPJx62jtib582/bFqAeaS2CUsNz1xMeq1v3YYPikqmnk+wjAN1aJARvS2nqB0757Y+1j8r+IfHg==
X-Received: by 2002:a17:902:7883:b029:e7:32bd:6b97 with SMTP id q3-20020a1709027883b02900e732bd6b97mr22335934pll.0.1617592490431;
        Sun, 04 Apr 2021 20:14:50 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id ot17sm13835918pjb.50.2021.04.04.20.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 20:14:50 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Saravana Kannan <saravanak@google.com>, stable@vger.kernel.org
Subject: [PATCH] of: property: do not create device links from *nr-gpios
Date:   Sun,  4 Apr 2021 20:14:36 -0700
Message-Id: <20210405031436.2465475-1-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[<vendor>,]nr-gpios property is used by some GPIO drivers[0] to indicate
the number of GPIOs present on a system, not define a GPIO. nr-gpios is
not configured by #gpio-cells and can't be parsed along with other
"*-gpios" properties.

scripts/dtc/checks.c also has a special case for nr-gpio{s}. However,
nr-gpio is not really special, so we only need to fix nr-gpios suffix
here.

[0]: nr-gpios is referenced in Documentation/devicetree/bindings/gpio:
 - gpio-adnp.txt
 - gpio-xgene-sb.txt
 - gpio-xlp.txt
 - snps,dw-apb-gpio.yaml

Fixes errors such as:
  OF: /palmbus@300000/gpio@600: could not find phandle

Call Trace:
  of_phandle_iterator_next+0x8c/0x16c
  __of_parse_phandle_with_args+0x38/0xb8
  of_parse_phandle_with_args+0x28/0x3c
  parse_suffix_prop_cells+0x80/0xac
  parse_gpios+0x20/0x2c
  of_link_to_suppliers+0x18c/0x288
  of_link_to_suppliers+0x1fc/0x288
  device_add+0x4e0/0x734
  of_platform_device_create_pdata+0xb8/0xfc
  of_platform_bus_create+0x170/0x214
  of_platform_populate+0x88/0xf4
  __dt_register_buses+0xbc/0xf0
  plat_of_setup+0x1c/0x34

Fixes: 7f00be96f125 ("of: property: Add device link support for interrupt-parent, dmas and -gpio(s)")
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc: Saravana Kannan <saravanak@google.com>
Cc: <stable@vger.kernel.org> # 5.5.x
---
 drivers/of/property.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/of/property.c b/drivers/of/property.c
index 2bb3158c9e43..24672c295603 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -1271,7 +1271,16 @@ DEFINE_SIMPLE_PROP(pinctrl8, "pinctrl-8", NULL)
 DEFINE_SIMPLE_PROP(remote_endpoint, "remote-endpoint", NULL)
 DEFINE_SUFFIX_PROP(regulators, "-supply", NULL)
 DEFINE_SUFFIX_PROP(gpio, "-gpio", "#gpio-cells")
-DEFINE_SUFFIX_PROP(gpios, "-gpios", "#gpio-cells")
+
+static struct device_node *parse_gpios(struct device_node *np,
+				       const char *prop_name, int index)
+{
+	if (!strcmp_suffix(prop_name, "nr-gpios"))
+		return NULL;
+
+	return parse_suffix_prop_cells(np, prop_name, index, "-gpios",
+				       "#gpio-cells");
+}
 
 static struct device_node *parse_iommu_maps(struct device_node *np,
 					    const char *prop_name, int index)
-- 
2.31.1


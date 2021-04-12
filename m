Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360DA35BE0B
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238636AbhDLI4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:56:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238774AbhDLIyj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:54:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B54FB61353;
        Mon, 12 Apr 2021 08:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217573;
        bh=92ew4FyNwUbIi/0Bcmy1XRRRT1DQHCkyTNN8a4YG2Uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RUvjYrExR1kMBRhOPRu2YFwdwO+QXKolrwVcT+TpFXUA3J5BG4kHdMbTM5A925zwu
         4tSzUFP7tnNLkiuw7QsUzxPPYKE5RaxVLiivNF7H81fbRLALbljPm3m47UHxryH0lY
         vTULaFLYQXlFGOcM6B0VoDVerQVWe3X4qLpKxqW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Saravana Kannan <saravanak@google.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.10 028/188] of: property: fw_devlink: do not link ".*,nr-gpios"
Date:   Mon, 12 Apr 2021 10:39:02 +0200
Message-Id: <20210412084014.583779950@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>

commit d473d32c2fbac2d1d7082c61899cfebd34eb267a upstream.

[<vendor>,]nr-gpios property is used by some GPIO drivers[0] to indicate
the number of GPIOs present on a system, not define a GPIO. nr-gpios is
not configured by #gpio-cells and can't be parsed along with other
"*-gpios" properties.

nr-gpios without the "<vendor>," prefix is not allowed by the DT
spec[1], so only add exception for the ",nr-gpios" suffix and let the
error message continue being printed for non-compliant implementations.

[0] nr-gpios is referenced in Documentation/devicetree/bindings/gpio:
 - gpio-adnp.txt
 - gpio-xgene-sb.txt
 - gpio-xlp.txt
 - snps,dw-apb-gpio.yaml

[1] Link: https://github.com/devicetree-org/dt-schema/blob/cb53a16a1eb3e2169ce170c071e47940845ec26e/schemas/gpio/gpio-consumer.yaml#L20

Fixes errors such as:
  OF: /palmbus@300000/gpio@600: could not find phandle

Fixes: 7f00be96f125 ("of: property: Add device link support for interrupt-parent, dmas and -gpio(s)")
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc: Saravana Kannan <saravanak@google.com>
Cc: stable@vger.kernel.org # v5.5+
Link: https://lore.kernel.org/r/20210405222540.18145-1-ilya.lipnitskiy@gmail.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/property.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -1308,7 +1308,16 @@ DEFINE_SIMPLE_PROP(pinctrl7, "pinctrl-7"
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



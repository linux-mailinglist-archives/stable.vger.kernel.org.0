Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 848262EB93
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbfE3DOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:14:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:32884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729691AbfE3DOD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:14:03 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 801C62449A;
        Thu, 30 May 2019 03:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186042;
        bh=YVSsXPhSV/AB32E936YZFOqFqKBy8o2/bd5r9JlQOZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eZu4CFms2Rlc+mK6RdRFt4tPJvipIn5+IlRyD7QcaixUYE9xyJW69w+1LsTGB5xgR
         DTACyKy1XYphHXsJZHeSwbwREWVeuWQ9fK4jGrbB482Gks+2q7bblVyvlazVb5Nyb+
         CxlHzX79SqaCRxWhzY2sWy7W1iGxV+Cz9PEsBHEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        Patrice Chotard <patrice.chotard@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 133/346] pinctrl: st: fix leaked of_node references
Date:   Wed, 29 May 2019 20:03:26 -0700
Message-Id: <20190530030547.853652402@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 483d70d73beaecab55882fcd2a357af72674e24c ]

The call to of_get_child_by_name returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

Detected by coccinelle with the following warnings:
./drivers/pinctrl/pinctrl-st.c:1188:3-9: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 1175, but without a corresponding object release within this function.
./drivers/pinctrl/pinctrl-st.c:1188:3-9: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 1175, but without a corresponding object release within this function.
./drivers/pinctrl/pinctrl-st.c:1199:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 1175, but without a corresponding object release within this function.
./drivers/pinctrl/pinctrl-st.c:1199:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 1175, but without a corresponding object release within this function.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: Patrice Chotard <patrice.chotard@st.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org (open list)
Reviewed-by: Patrice Chotard <patrice.chotard@st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-st.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index e66af93f2cbf8..195b442a23434 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -1170,7 +1170,7 @@ static int st_pctl_dt_parse_groups(struct device_node *np,
 	struct property *pp;
 	struct st_pinconf *conf;
 	struct device_node *pins;
-	int i = 0, npins = 0, nr_props;
+	int i = 0, npins = 0, nr_props, ret = 0;
 
 	pins = of_get_child_by_name(np, "st,pins");
 	if (!pins)
@@ -1185,7 +1185,8 @@ static int st_pctl_dt_parse_groups(struct device_node *np,
 			npins++;
 		} else {
 			pr_warn("Invalid st,pins in %pOFn node\n", np);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out_put_node;
 		}
 	}
 
@@ -1195,8 +1196,10 @@ static int st_pctl_dt_parse_groups(struct device_node *np,
 	grp->pin_conf = devm_kcalloc(info->dev,
 					npins, sizeof(*conf), GFP_KERNEL);
 
-	if (!grp->pins || !grp->pin_conf)
-		return -ENOMEM;
+	if (!grp->pins || !grp->pin_conf) {
+		ret = -ENOMEM;
+		goto out_put_node;
+	}
 
 	/* <bank offset mux direction rt_type rt_delay rt_clk> */
 	for_each_property_of_node(pins, pp) {
@@ -1229,9 +1232,11 @@ static int st_pctl_dt_parse_groups(struct device_node *np,
 		}
 		i++;
 	}
+
+out_put_node:
 	of_node_put(pins);
 
-	return 0;
+	return ret;
 }
 
 static int st_pctl_parse_functions(struct device_node *np,
-- 
2.20.1




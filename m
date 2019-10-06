Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE505CD737
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729488AbfJFRg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:36:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729639AbfJFRg2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:36:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4055920700;
        Sun,  6 Oct 2019 17:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383386;
        bh=Xhdwc27crQh8QWKhbFFcu+WZDtv79dO+TPMXSEimq/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SPsyPDyToZ4BpL8/IIxhQwxsF5rI0qfSZTygmCjdJh1ecmyT0Tny0dsaJ3VxS/jd+
         RZKohjyZiPjvOOHNM566HyEByvpKFZnCJLL9PKgiCIqiOkDFUoHJ4fmH9jq0qJ3M3N
         PcLsjT8PLKWZVd1EbvP79emtOO6+SF+FaQmRDpc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandre Torgue <alexandre.torgue@st.com>,
        Amelie Delaunay <amelie.delaunay@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 041/137] pinctrl: stmfx: update pinconf settings
Date:   Sun,  6 Oct 2019 19:20:25 +0200
Message-Id: <20191006171212.422419325@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171209.403038733@linuxfoundation.org>
References: <20191006171209.403038733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Torgue <alexandre.torgue@st.com>

[ Upstream commit a502b343ebd0eab38f3cb33fbb84011847cf5aac ]

According to the following tab (coming from STMFX datasheet), updates
have to done in stmfx_pinconf_set function:

-"type" has to be set when "bias" is configured as "pull-up or pull-down"
-PIN_CONFIG_DRIVE_PUSH_PULL should only be used when gpio is configured as
 output. There is so no need to check direction.

DIR | TYPE | PUPD | MFX GPIO configuration
----|------|------|---------------------------------------------------
1   | 1    | 1    | OUTPUT open drain with internal pull-up resistor
----|------|------|---------------------------------------------------
1   | 1    | 0    | OUTPUT open drain with internal pull-down resistor
----|------|------|---------------------------------------------------
1   | 0    | 0/1  | OUTPUT push pull no pull
----|------|------|---------------------------------------------------
0   | 1    | 1    | INPUT with internal pull-up resistor
----|------|------|---------------------------------------------------
0   | 1    | 0    | INPUT with internal pull-down resistor
----|------|------|---------------------------------------------------
0   | 0    | 1    | INPUT floating
----|------|------|---------------------------------------------------
0   | 0    | 0    | analog (GPIO not used, default setting)

Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Amelie Delaunay <amelie.delaunay@st.com>
Link: https://lore.kernel.org/r/1564053416-32192-1-git-send-email-amelie.delaunay@st.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-stmfx.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-stmfx.c b/drivers/pinctrl/pinctrl-stmfx.c
index eba872ce4a7cb..c82ad4b629e3e 100644
--- a/drivers/pinctrl/pinctrl-stmfx.c
+++ b/drivers/pinctrl/pinctrl-stmfx.c
@@ -296,29 +296,29 @@ static int stmfx_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 		switch (param) {
 		case PIN_CONFIG_BIAS_PULL_PIN_DEFAULT:
 		case PIN_CONFIG_BIAS_DISABLE:
+		case PIN_CONFIG_DRIVE_PUSH_PULL:
+			ret = stmfx_pinconf_set_type(pctl, pin, 0);
+			if (ret)
+				return ret;
+			break;
 		case PIN_CONFIG_BIAS_PULL_DOWN:
+			ret = stmfx_pinconf_set_type(pctl, pin, 1);
+			if (ret)
+				return ret;
 			ret = stmfx_pinconf_set_pupd(pctl, pin, 0);
 			if (ret)
 				return ret;
 			break;
 		case PIN_CONFIG_BIAS_PULL_UP:
-			ret = stmfx_pinconf_set_pupd(pctl, pin, 1);
+			ret = stmfx_pinconf_set_type(pctl, pin, 1);
 			if (ret)
 				return ret;
-			break;
-		case PIN_CONFIG_DRIVE_OPEN_DRAIN:
-			if (!dir)
-				ret = stmfx_pinconf_set_type(pctl, pin, 1);
-			else
-				ret = stmfx_pinconf_set_type(pctl, pin, 0);
+			ret = stmfx_pinconf_set_pupd(pctl, pin, 1);
 			if (ret)
 				return ret;
 			break;
-		case PIN_CONFIG_DRIVE_PUSH_PULL:
-			if (!dir)
-				ret = stmfx_pinconf_set_type(pctl, pin, 0);
-			else
-				ret = stmfx_pinconf_set_type(pctl, pin, 1);
+		case PIN_CONFIG_DRIVE_OPEN_DRAIN:
+			ret = stmfx_pinconf_set_type(pctl, pin, 1);
 			if (ret)
 				return ret;
 			break;
-- 
2.20.1




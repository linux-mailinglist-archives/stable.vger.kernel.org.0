Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9715E44B17F
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 17:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240361AbhKIQto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 11:49:44 -0500
Received: from mail-ot1-f50.google.com ([209.85.210.50]:36847 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240354AbhKIQtl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 11:49:41 -0500
Received: by mail-ot1-f50.google.com with SMTP id w6-20020a9d77c6000000b0055e804fa524so3355055otl.3;
        Tue, 09 Nov 2021 08:46:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QCdrW6y17rvAkzqtUwRB26cgRdpTc9nbRuh6smuG2g4=;
        b=h/iKgqB32rzFr7IgFCye1ql4O36+fY6og0lygCiAYTZNs5YEfVEPTEPmvOHICVVQC4
         7WGG0pxv8VIxR712zXkBZgmmAW2oDdACX9vET4Hka6+rgNqB0kSsCwylSAjBfH7OY6HY
         d2EdNIp94bW9q5bujVhVDGTD5OdKvxEdlam9Y8RDKLtMrMmTxPQxSX+EMhwdySCYqxfs
         +tNlAibcwlObBriUU6lN+h13JAb0FDMxVYzdvidfqDWIfiB0FQlxNpsRPAeXGP/tesBM
         rQKeAsqVWR6pLgmLk74CTCITGxaJZTX0/GPmE0SPRMXtSyX9faV444H6mrBi0fsZdB7/
         +g/w==
X-Gm-Message-State: AOAM532oY6c+UvrSZAtFIk2VigqneP6d1fx+AeWsAPiO3eH1FERuoxxZ
        LfO60p458s43Dsc73pjlyftljrB3qQ==
X-Google-Smtp-Source: ABdhPJxSAu+FQ6ljH9p3Bj1Mz+tnr8g+QT2ZzHNPysDfdOzlazvbmApXPmhaR1GAB/4u0MlYuICJmQ==
X-Received: by 2002:a9d:a2b:: with SMTP id 40mr7366147otg.100.1636476414810;
        Tue, 09 Nov 2021 08:46:54 -0800 (PST)
Received: from xps15.herring.priv (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.googlemail.com with ESMTPSA id w22sm7514338otp.50.2021.11.09.08.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 08:46:54 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Guenter Roeck <linux@roeck-us.net>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-clk@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 2/2] clk: versatile: clk-icst: Ensure clock names are unique
Date:   Tue,  9 Nov 2021 10:46:50 -0600
Message-Id: <20211109164650.2233507-3-robh@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211109164650.2233507-1-robh@kernel.org>
References: <20211109164650.2233507-1-robh@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 2d3de197a818 ("ARM: dts: arm: Update ICST clock nodes 'reg' and
node names") moved to using generic node names. That results in trying
to register multiple clocks with the same name. Fix this by including
the unit-address in the clock name.

Fixes: 2d3de197a818 ("ARM: dts: arm: Update ICST clock nodes 'reg' and node names")
Cc: stable@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-clk@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
This should be applied to stable to minimize DT ABI breakage.
---
 drivers/clk/versatile/clk-icst.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/versatile/clk-icst.c b/drivers/clk/versatile/clk-icst.c
index 77fd0ecaf155..d52f976dc875 100644
--- a/drivers/clk/versatile/clk-icst.c
+++ b/drivers/clk/versatile/clk-icst.c
@@ -484,7 +484,7 @@ static void __init of_syscon_icst_setup(struct device_node *np)
 	struct device_node *parent;
 	struct regmap *map;
 	struct clk_icst_desc icst_desc;
-	const char *name = np->name;
+	const char *name;
 	const char *parent_name;
 	struct clk *regclk;
 	enum icst_control_type ctype;
@@ -533,15 +533,17 @@ static void __init of_syscon_icst_setup(struct device_node *np)
 		icst_desc.params = &icst525_apcp_cm_params;
 		ctype = ICST_INTEGRATOR_CP_CM_MEM;
 	} else {
-		pr_err("unknown ICST clock %s\n", name);
+		pr_err("unknown ICST clock %pOF\n", np);
 		return;
 	}
 
 	/* Parent clock name is not the same as node parent */
 	parent_name = of_clk_get_parent_name(np, 0);
+	name = kasprintf(GFP_KERNEL, "%pOFP", np);
 
 	regclk = icst_clk_setup(NULL, &icst_desc, name, parent_name, map, ctype);
 	if (IS_ERR(regclk)) {
+		kfree(name);
 		pr_err("error setting up syscon ICST clock %s\n", name);
 		return;
 	}
-- 
2.32.0


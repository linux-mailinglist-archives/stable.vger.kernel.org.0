Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEB217C04C
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 15:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgCFOeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 09:34:22 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44251 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgCFOeV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 09:34:21 -0500
Received: by mail-lj1-f193.google.com with SMTP id a10so2398599ljp.11
        for <stable@vger.kernel.org>; Fri, 06 Mar 2020 06:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CeXIttqzTsgVAyiXMeHsyc2FwLIo21i2sKBLLvLk0vQ=;
        b=S5OfaMjDJoxNDrPz1fpk0j+ygmqgLsBWWDVw6Akninc5qqKNV4gnnRgLi2Rc92rdGo
         beDl1YQ+teMKGqeJEtXgvIauT9AvIFM+MjwlVtjs14lR6FocpaOuTx4HvapFc+np0GEt
         dB0wvuwNidkvtOzY4ipTD2Uu8n6bYiXMckkHFrCQEdbdOpZeOF1n3EoyGH+DMcBP5rej
         GO07AIcpSp6gTFZmtjQoBrJYMJSdELX+rRyjHCXW0KD2Ys/Z6yrlx41NgrMk+ApZywfY
         QAe6xfICzsVERfpic2vVcZOEH6ncv4Q9odCM9Aaz5vMFYDMIDmYx3awW4RAVSgPMRRwW
         NPww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CeXIttqzTsgVAyiXMeHsyc2FwLIo21i2sKBLLvLk0vQ=;
        b=Pt3/wG9x/Q9RMo//oDpg8janw7J537odAT+63F0IhaUoYWhILzFWRko9pvAOTW07hN
         XP65d9uxBovEwqi4GUlefn20pm+hrClOXdQuJZB8WsfwNpJCEJZGwK91/0lQUv9cIEuR
         L/XjmSnixnhChMcpR7CZX+yZ6PTt7v+WeYNbgzN6O18FnazFr3VBGK99/AldbOPX/xsa
         564o6j9NHj+cDT3awl+ciZBLDRVrm9/XIDVnbgqYQObXrapBq1ajAJFww3VngFt3n/32
         H76E8jlwcjIkpMKdGsPIKJAxD1XZYFIz6755fdcqWrpk4azyZvedRTmZxyVenoda/prm
         Lexw==
X-Gm-Message-State: ANhLgQ1qAPMWslMY7Tpq+fJ1EqZgdMFgekM1CApC2SCGlGCvUTBt+3vQ
        zJcUSMznO6lPYGXEYB+SX+d3CA==
X-Google-Smtp-Source: ADFU+vt9NlqX5VwvH3hqxT/0yOAnpBSxgJG01AyujCyRptVAVxrCEn7YgBz/A3jPs5bnXssdbJBN9w==
X-Received: by 2002:a2e:9bd7:: with SMTP id w23mr2244277ljj.153.1583505259583;
        Fri, 06 Mar 2020 06:34:19 -0800 (PST)
Received: from genomnajs.ideon.se ([85.235.10.227])
        by smtp.gmail.com with ESMTPSA id w20sm17108460lfk.25.2020.03.06.06.34.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 06:34:18 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-gpio@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Brian Masney <masneyb@onstation.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v2] pinctrl: qcom: ssbi-gpio: Fix fwspec parsing bug
Date:   Fri,  6 Mar 2020 15:34:15 +0100
Message-Id: <20200306143416.1476250-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We are parsing SSBI gpios as fourcell fwspecs but they are
twocell. Probably a simple copy-and-paste bug.

Tested on the APQ8060 DragonBoard and after this ethernet
and MMC card detection works again.

Cc: Brian Masney <masneyb@onstation.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: stable@vger.kernel.org
Fixes: ae436fe81053 ("pinctrl: ssbi-gpio: convert to hierarchical IRQ helpers in gpio core")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Renamed function pointer field to .populate_parent_alloc_arg
  as it is named upstream.
---
 drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c b/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
index fba1d41d20ec..338a15d08629 100644
--- a/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
+++ b/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
@@ -794,7 +794,7 @@ static int pm8xxx_gpio_probe(struct platform_device *pdev)
 	girq->fwnode = of_node_to_fwnode(pctrl->dev->of_node);
 	girq->parent_domain = parent_domain;
 	girq->child_to_parent_hwirq = pm8xxx_child_to_parent_hwirq;
-	girq->populate_parent_alloc_arg = gpiochip_populate_parent_fwspec_fourcell;
+	girq->populate_parent_alloc_arg = gpiochip_populate_parent_fwspec_twocell;
 	girq->child_offset_to_irq = pm8xxx_child_offset_to_irq;
 	girq->child_irq_domain_ops.translate = pm8xxx_domain_translate;
 
-- 
2.24.1


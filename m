Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE311717C0
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 13:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbgB0MqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 07:46:17 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:35864 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728964AbgB0MqR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 07:46:17 -0500
Received: by mail-lf1-f67.google.com with SMTP id f24so1994105lfh.3
        for <stable@vger.kernel.org>; Thu, 27 Feb 2020 04:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3+0UYj3qVJZMwBRFalwhwumi1SLOyZkXHX2X4PQigTk=;
        b=mXb6at++ivddD2NTVyokGX6Bv9FhnYBxuwJBu37CLMiC7ZKw+agfQ8IcqYkg5R62dV
         UbBJskVFA9v0xAAj88zbm115M1Ky/Shbongm6s1uqNzblmPlJpA2AlhbNzAonTqF6KVT
         3f/G2VBMbDM89Gh1lBSYuFEgrllGeNDN08WuURX9P9tevKQmiXieDsY0P2yJqyq3PT9i
         oVHssqDaQ1V4wZZAid9+NJ84Jnb46rLodKD+SSpZ/3FX0TCDUBxHuSYZBntM+ZH66VrM
         J7J/NKuN7xia8AKCAQQtvg87aTIL4OKo8vWc6bJ6Ce5c9W/CjOlDCG+LC+WNFAbe2hcJ
         eX7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3+0UYj3qVJZMwBRFalwhwumi1SLOyZkXHX2X4PQigTk=;
        b=ARexR6JfS3RAHbKEVLI4R9dVTJgLcwuGnALXSWu6/vuADG34fHrmHxK+HenHxYBYaa
         0vAl663oMrFgLDU47EvWADyY3W+Y9dN/F2YCgwYVKLJA58cyDg742LMtzlpXUIOz/enS
         bu8brcQVg8l2Z1vDw8Cy+47hvifzNcNyrE7/DJby5o4PZvKJlcteurowMLj7gzA2OMjL
         DlhW7mzahby7zI4CxEVCU5NvEwPHNb+aek0QFzXSSvh2sg8POGObZMLpzmrrBdhrUPEf
         zNY33gc5CQhLBo+XELoHz8E2uroketHCX1+QFimsU27RDSk5CYI9zjJ+hB5DRHunTbPm
         nhhw==
X-Gm-Message-State: ANhLgQ0icCPps6GAzqoCoxjxMw7EVCX+u3XeuWCvhLqllKnddj13zZT3
        WkoLSRzbpUWOEgsoZ15uPrOG1Q==
X-Google-Smtp-Source: ADFU+vsHQVosAGa6s8cq304/BYeC23/PJ+nzRpBSOGRg4zjwsWrSheAAC7nA+O5n//KNTf0/gfXSPw==
X-Received: by 2002:ac2:5299:: with SMTP id q25mr2092593lfm.213.1582807575348;
        Thu, 27 Feb 2020 04:46:15 -0800 (PST)
Received: from localhost.localdomain (h-158-174-22-210.NA.cust.bahnhof.se. [158.174.22.210])
        by smtp.gmail.com with ESMTPSA id l16sm2669334lfh.74.2020.02.27.04.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 04:46:12 -0800 (PST)
From:   Ulf Hansson <ulf.hansson@linaro.org>
To:     Sudeep Holla <sudeep.holla@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        linux-pm@vger.kernel.org
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lina Iyer <ilina@codeaurora.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: [PATCH 1/4] PM / Domains: Allow no domain-idle-states DT property in genpd when parsing
Date:   Thu, 27 Feb 2020 13:45:48 +0100
Message-Id: <20200227124551.31860-2-ulf.hansson@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200227124551.31860-1-ulf.hansson@linaro.org>
References: <20200227124551.31860-1-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 2c361684803e ("PM / Domains: Don't treat zero found compatible idle
states as an error"), moved of_genpd_parse_idle_states() towards allowing
none compatible idle state to be found for the device node, rather than
returning an error code.

However, it didn't consider that the "domain-idle-states" DT property may
be missing as it's optional, which makes of_count_phandle_with_args() to
return -ENOENT. Let's fix this to make the behaviour consistent.

Reported-by: Benjamin Gaignard <benjamin.gaignard@st.com>
Fixes: 2c361684803e ("PM / Domains: Don't treat zero found compatible idle states as an error")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/base/power/domain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index 959d6d5eb000..0a01df608849 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -2653,7 +2653,7 @@ static int genpd_iterate_idle_states(struct device_node *dn,
 
 	ret = of_count_phandle_with_args(dn, "domain-idle-states", NULL);
 	if (ret <= 0)
-		return ret;
+		return ret == -ENOENT ? 0 : ret;
 
 	/* Loop over the phandles until all the requested entry is found */
 	of_for_each_phandle(&it, ret, dn, "domain-idle-states", NULL, 0) {
-- 
2.20.1


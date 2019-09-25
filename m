Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91D7EBDB8C
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 11:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732790AbfIYJz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 05:55:27 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39570 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfIYJz1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Sep 2019 05:55:27 -0400
Received: by mail-pf1-f195.google.com with SMTP id v4so3080465pff.6
        for <stable@vger.kernel.org>; Wed, 25 Sep 2019 02:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DWhbUGv2lQeZO4jYvuR/nIX8VcsQRP/3s99PPL6K370=;
        b=q10EU45NTJwIJeYfgsOBdN94NNFG3fwiOLyu8Ix7i+TuDo3WIftED76Ja2vnuOZ5rh
         qgmTU6GXJaHLYtMrF1wV0dwXj61rzxSLCXubwBC3wO2v+J84vvhJoyfkrzkgkLMBDx0P
         gaNMRxZrXdRvGNO8WCQ2H84Jtw78GxePE1UxWdthzJtNwMbuPhan0oFMKBAbcRLIdqIf
         wrUOFwSm10824LM2VQZACB2CD0ZR3+oy5SoJtq4pHz/2sAg04gbbi7BWmkpa+GVSafvJ
         dAuGXkJHykPpnzfplGIaOccK6F41LMCUwyy1T+tSybzxhFYFPWUk4xVrzityIH3k36ZE
         hRWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DWhbUGv2lQeZO4jYvuR/nIX8VcsQRP/3s99PPL6K370=;
        b=LTA5zynZDdG2mINsZ04aVwtgswAZiYqtD9BKNiHkgLH1j/EA1cDcunYVqn2OWw4l0b
         2T7Lb6PqPIwWeuJkPXSIijEZrD6+pMuW83lgEZb7+aVGiMUx6PhSd8M4E3eQm70YJ/9q
         lzVRSQTN4GUR2UvKi5Whs3vvyBI4iJQ5Yo9IqXfexVnysil141rGFIavhbnVSWITovN9
         0ntcme93pSUGBF6BZ0Kuahdq54DEdnlz9KstBCdFdw7DjvfD1leXUGHeW6LEbo9e9FJL
         mEl0RtxwKu7s6i5B9V6f+h2/WjZDjeeFO9gjjqkibzVufNv8BFTZ01TfmkSUue5pdckl
         t6bw==
X-Gm-Message-State: APjAAAXMi6XSEG1AZInQfT2e6Wh4qwHyM3X5aFCyRDdoDwzcco+gvvBa
        wZpbu5XeK5Oqh2UN1D7CDYzrTQ/jIpPEpA==
X-Google-Smtp-Source: APXvYqwcBxlk43VFAND4HNTUQaO0wlCxMabpoBPf+ntRfhtxngHebErv30Xy5iJzGbAaRXMnyDdICg==
X-Received: by 2002:a62:f249:: with SMTP id y9mr8759936pfl.147.1569405325359;
        Wed, 25 Sep 2019 02:55:25 -0700 (PDT)
Received: from baolinwangubtpc.spreadtrum.com ([117.18.48.82])
        by smtp.gmail.com with ESMTPSA id i7sm2430831pjs.1.2019.09.25.02.55.21
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 25 Sep 2019 02:55:24 -0700 (PDT)
From:   Baolin Wang <baolin.wang@linaro.org>
To:     stable@vger.kernel.org, sre@kernel.org
Cc:     david@lechnology.com, linux-pm@vger.kernel.org, arnd@arndb.de,
        baolin.wang@linaro.org, orsonzhai@gmail.com,
        vincent.guittot@linaro.org, linux-kernel@vger.kernel.org
Subject: [BACKPORT 4.19.y 3/3] power: supply: sysfs: ratelimit property read error message
Date:   Wed, 25 Sep 2019 17:55:03 +0800
Message-Id: <117b7b2d9bed2a288676f5614d8dd8d09746ab93.1569404757.git.baolin.wang@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1569404757.git.baolin.wang@linaro.org>
References: <cover.1569404757.git.baolin.wang@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Lechner <david@lechnology.com>

[Upstream commit 87a2b65fc855e6be50f791c2ebbb492541896827]

This adds rate limiting to the message that is printed when reading a
power supply property via sysfs returns an error. This will prevent
userspace applications from unintentionally dDOSing the system by
continuously reading a property that returns an error.

Signed-off-by: David Lechner <david@lechnology.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 drivers/power/supply/power_supply_sysfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/power_supply_sysfs.c b/drivers/power/supply/power_supply_sysfs.c
index 5a2757a..5358a80 100644
--- a/drivers/power/supply/power_supply_sysfs.c
+++ b/drivers/power/supply/power_supply_sysfs.c
@@ -131,7 +131,8 @@ static ssize_t power_supply_show_property(struct device *dev,
 				dev_dbg(dev, "driver has no data for `%s' property\n",
 					attr->attr.name);
 			else if (ret != -ENODEV && ret != -EAGAIN)
-				dev_err(dev, "driver failed to report `%s' property: %zd\n",
+				dev_err_ratelimited(dev,
+					"driver failed to report `%s' property: %zd\n",
 					attr->attr.name, ret);
 			return ret;
 		}
-- 
1.7.9.5


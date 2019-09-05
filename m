Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD4AA98C1
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 05:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbfIEDJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 23:09:02 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33662 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730628AbfIEDI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 23:08:58 -0400
Received: by mail-pl1-f195.google.com with SMTP id t11so592742plo.0
        for <stable@vger.kernel.org>; Wed, 04 Sep 2019 20:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=D2+Lw+Pa01X7BomivX93hO8QHJLkQUok4YlT1BdSE8Q=;
        b=aPGFjshzn2XCAuii6qIibENbOZhgqdquG5oRwq7Kx0HzuYOTiUtXN7eWd6ZNU43Q4H
         Unn4mfqnnzZqmZgpSI8dC7YRgOMw0XW0Mu0d+FNBXAmxMJvsjKPI6uu+hkvv3ASKufag
         XWVjeE2JPTv95d8nKg7UjUcD2c06y5+OzF/+Dhrj/FaaRWtfZIoZlftN7LxzW9jIxclY
         wPgb3MTUJJAMswWF1k6M0M3fXQD2KoMaVSwRsj65n2TI5lvUHP8qStdM2nZZRzExL4Z1
         tr6rfW1g43jLJh245M6ZjbdKtNwxuQtUgnpBwM4qgFrs/osS2ScNuLzvBh+GNEYaPBCb
         G/0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=D2+Lw+Pa01X7BomivX93hO8QHJLkQUok4YlT1BdSE8Q=;
        b=jumUJmm0CiqDnqwpa8nwCZ6FA/Be4+Wh32Jbp+eHRsZD11AAmoDdQWxsOsMKhgAaWp
         o9fRcZTzeYQo8tbxxthDB2AzCsWjoKNNl/6oOQm2Pdnhsk5LZ9m7viZhgPiP0/WxuYBw
         vX7Pj7aRFD0AIiE/MT4CtuM7LGt4Q6ZW60bmRVsAHOPpB0VpyEN+u3jBdwcpaTsYMfN/
         5IVFgNqBGb3g8gnn3zEjwkS3P5BJtgVDb3ZH4XVoslI7lms0lWnKibgB4TPd1G1g4RXw
         SSZCoXc0RVeltCLiQ9SBNl9lJtOCQCJTH4Vc8R/pPGmCMj7DcSsy4O7yejWCQlWdGii4
         fBTQ==
X-Gm-Message-State: APjAAAVv8QkuF2B7uYUG0LrAUupAg7FMqP0DCnd97a5kR4KJViyO0SYq
        3BaeCVO79Wc0RkxCdB6c1ctDGbnItWW7Qg==
X-Google-Smtp-Source: APXvYqz1OgDllfZx5aE80dHzsymWWEYpyOnhLsxIUHX0jkOSVHwEbHPlJBrog8ScorqS+hDJz5W5Aw==
X-Received: by 2002:a17:902:7b8c:: with SMTP id w12mr971732pll.276.1567652937442;
        Wed, 04 Sep 2019 20:08:57 -0700 (PDT)
Received: from baolinwangubtpc.spreadtrum.com ([117.18.48.82])
        by smtp.gmail.com with ESMTPSA id s5sm474988pfe.52.2019.09.04.20.08.54
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 04 Sep 2019 20:08:56 -0700 (PDT)
From:   Baolin Wang <baolin.wang@linaro.org>
To:     stable@vger.kernel.org, sre@kernel.org
Cc:     david@lechnology.com, linux-pm@vger.kernel.org, arnd@arndb.de,
        baolin.wang@linaro.org, orsonzhai@gmail.com,
        vincent.guittot@linaro.org, linux-kernel@vger.kernel.org
Subject: [BACKPORT 4.14.y v2 4/6] power: supply: sysfs: ratelimit property read error message
Date:   Thu,  5 Sep 2019 11:08:27 +0800
Message-Id: <f00b144ce6707ab64cdf1c61ece385e919630815.1567649729.git.baolin.wang@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1567649728.git.baolin.wang@linaro.org>
References: <cover.1567649728.git.baolin.wang@linaro.org>
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
index eb5dc74..2ccaf4f 100644
--- a/drivers/power/supply/power_supply_sysfs.c
+++ b/drivers/power/supply/power_supply_sysfs.c
@@ -91,7 +91,8 @@ static ssize_t power_supply_show_property(struct device *dev,
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


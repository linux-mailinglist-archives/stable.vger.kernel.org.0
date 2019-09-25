Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81AE2BDBD0
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 12:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfIYKDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 06:03:53 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42035 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387911AbfIYKDw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Sep 2019 06:03:52 -0400
Received: by mail-pg1-f195.google.com with SMTP id z12so2914218pgp.9
        for <stable@vger.kernel.org>; Wed, 25 Sep 2019 03:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=D2+Lw+Pa01X7BomivX93hO8QHJLkQUok4YlT1BdSE8Q=;
        b=E5T74E7aiLNp58UWXnpZyalzu/mEv9i0J0gVytsV9dTDjmkgfai15/LekVtp2q1QcL
         gaUVymGSBo5rrEU8HwK0LQX+zl+RCTe3huCu6qasixs/qsPmjPe0FjMPf+1/ysEXI4gr
         QY0M7E5Xm3nU70nK+lwHwWAw3Cz7idV3KUWPfpiqvoXtfPDSilQp97dXeagEI3L2wun7
         CHBsMtM3phTNDbBI0YHMjhb6eSItTo2M8qOB910EXVdoDmfkiqKoeggt1ynccRLa9e4o
         VRAYo4oTP1CPOM3JmlA6MHB5owQWFCmvxN45t3Ys8AAd9TFxvLW5ATyKJk3K9NvvFbhH
         DBTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=D2+Lw+Pa01X7BomivX93hO8QHJLkQUok4YlT1BdSE8Q=;
        b=bH7+yY7akNM2MKhlOitGsAFj8hXge20PzTSg0gST5prpAAYYg0h1oqrLA/MuTsm9Q6
         TF+mNc0poidKHZ2EulS8cwS+s3qYwdkj9uTwwi0hri5grIkvDmC5dtDDzsUrEc8dTX4v
         W4FK3PCnui5G6ehPucz5MrCsf87CddMl3MNkD9hThcHSqL9Z37CHF+cpUXmjZatZGZeA
         /3KARVdycbRNE2ZTxeCx8ro+WqC5HQNDANEXgaVH2BlAqVeSliMRNNEPOy01cENhb3Pe
         ZD+/LXU5QAUX8DZa/c8+vyr67OH9X8zs9iKFW+5VuOOini4L9l9tqaSXfXCheQsXrQIH
         PS6w==
X-Gm-Message-State: APjAAAXqsxenu0yt09KrGo4gN0+T1xiBZE1NIpFRb3MR7M3+yRaJ613m
        QSAGweCktvEC6PBCf+FT7pnhKpWTfenjWg==
X-Google-Smtp-Source: APXvYqyK1/XMgIGTBB477BhqN6s74xUQ051y3HOsz4kjV9sUQYEjuuOo+dD5rVKeMURqOO2+apKG7Q==
X-Received: by 2002:a17:90a:bf0e:: with SMTP id c14mr5285165pjs.69.1569405831188;
        Wed, 25 Sep 2019 03:03:51 -0700 (PDT)
Received: from baolinwangubtpc.spreadtrum.com ([117.18.48.82])
        by smtp.gmail.com with ESMTPSA id j25sm4753752pfi.113.2019.09.25.03.03.47
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 25 Sep 2019 03:03:50 -0700 (PDT)
From:   Baolin Wang <baolin.wang@linaro.org>
To:     stable@vger.kernel.org, sre@kernel.org
Cc:     david@lechnology.com, linux-pm@vger.kernel.org, arnd@arndb.de,
        baolin.wang@linaro.org, orsonzhai@gmail.com,
        vincent.guittot@linaro.org, linux-kernel@vger.kernel.org
Subject: [BACKPORT 4.14.y v3 3/3] power: supply: sysfs: ratelimit property read error message
Date:   Wed, 25 Sep 2019 18:03:35 +0800
Message-Id: <c136c30f8b113ba9b0359f57d2a109766c1d7a70.1569405445.git.baolin.wang@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1569405445.git.baolin.wang@linaro.org>
References: <cover.1569405445.git.baolin.wang@linaro.org>
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


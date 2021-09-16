Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1192640E048
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239674AbhIPQUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:20:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241055AbhIPQTO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:19:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B4776128B;
        Thu, 16 Sep 2021 16:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808783;
        bh=aTU+1b4wazC1TIH6SB1kj9KOELqj54l04zV4kpkgSrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V0qhDPLFBVbHlYESP9UAro7Hii0cORrNJ8QOPLIA8VrheKsnDiadqFtktF+4P6tJB
         K/yb7Di8jPfdVBMbc/NYiU/5rnNV4N6Vk89K/Ff7yZSn338WbWFTcmGiKpgMG64axN
         S7hnI+yBLq3LURN8Al95Ag611+adCM+SdRm0gcqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rajendra Nayak <rnayak@codeaurora.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 221/306] opp: Dont print an error if required-opps is missing
Date:   Thu, 16 Sep 2021 17:59:26 +0200
Message-Id: <20210916155801.589977756@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rajendra Nayak <rnayak@codeaurora.org>

[ Upstream commit 020d86fc0df8b865f6dc168d88a7c2dccabd0a9e ]

The 'required-opps' property is considered optional, hence remove
the pr_err() in of_parse_required_opp() when we find the property is
missing.
While at it, also fix the return value of
of_get_required_opp_performance_state() when of_parse_required_opp()
fails, return a -ENODEV instead of the -EINVAL.

Signed-off-by: Rajendra Nayak <rnayak@codeaurora.org>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/of.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/opp/of.c b/drivers/opp/of.c
index d92a1bfe1690..f83f4f6d7034 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -95,15 +95,7 @@ static struct dev_pm_opp *_find_opp_of_np(struct opp_table *opp_table,
 static struct device_node *of_parse_required_opp(struct device_node *np,
 						 int index)
 {
-	struct device_node *required_np;
-
-	required_np = of_parse_phandle(np, "required-opps", index);
-	if (unlikely(!required_np)) {
-		pr_err("%s: Unable to parse required-opps: %pOF, index: %d\n",
-		       __func__, np, index);
-	}
-
-	return required_np;
+	return of_parse_phandle(np, "required-opps", index);
 }
 
 /* The caller must call dev_pm_opp_put_opp_table() after the table is used */
@@ -1193,7 +1185,7 @@ int of_get_required_opp_performance_state(struct device_node *np, int index)
 
 	required_np = of_parse_required_opp(np, index);
 	if (!required_np)
-		return -EINVAL;
+		return -ENODEV;
 
 	opp_table = _find_table_of_opp_np(required_np);
 	if (IS_ERR(opp_table)) {
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0FE106EC9
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfKVLLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:11:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730195AbfKVK7w (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:59:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3CA220706;
        Fri, 22 Nov 2019 10:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420392;
        bh=0+tj+ChrT6Rg6cUA04EqBppN5Cmg4xlFOYO8ZyoCzEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ht4d1YExvPlc3338FQDu2/ZBMfW5mRydT3xsPW4o4pj7qS+6DkcS0eT0hqeL1T18p
         BVB2fwaO7Npz/IP39LBWvx2rj/YFaEDlWBZNQwim8J8lLoblAZIL2dSIR5h1GFQfwp
         RSejNR8gfkCQxytNIPfZS0WC/ajYJ78+chZ/YuEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 092/220] OPP: Return error on error from dev_pm_opp_get_opp_count()
Date:   Fri, 22 Nov 2019 11:27:37 +0100
Message-Id: <20191122100919.284328583@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 09f662f95306f3e3d47ab6842bc4b0bb868a80ad ]

Return error number instead of 0 on failures.

Fixes: a1e8c13600bf ("PM / OPP: "opp-hz" is optional for power domains")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index f3433bf47b100..1e80f9ec1aa6a 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -313,7 +313,7 @@ int dev_pm_opp_get_opp_count(struct device *dev)
 		count = PTR_ERR(opp_table);
 		dev_dbg(dev, "%s: OPP table not found (%d)\n",
 			__func__, count);
-		return 0;
+		return count;
 	}
 
 	count = _get_opp_count(opp_table);
-- 
2.20.1




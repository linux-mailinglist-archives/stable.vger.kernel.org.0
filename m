Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78AE4451F1F
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355627AbhKPAig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344409AbhKOTYj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 857C663488;
        Mon, 15 Nov 2021 18:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002638;
        bh=2tx8THRSRrbuqceFMjrGJWX0CpBqc6Ory7Tl0ZKBAyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kq5gqxccFW63YE737KAmXua5kT98VWYJcqzcfJxDcayceMifWQjuaOf/qbeMzoSCT
         dRvZkzagkvJurWX325RHhJLZ5z+u5AjkjX7du65KFXVXMSKeX1QSiUwK8+xcSSV9V2
         BsKvWUbfYW5xP0vBZG0WrBTtk9iQoRbU62bAKOAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 643/917] soc: qcom: rpmhpd: Make power_on actually enable the domain
Date:   Mon, 15 Nov 2021 18:02:18 +0100
Message-Id: <20211115165450.653032908@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit e3e56c050ab6e3f1bd811f0787f50709017543e4 ]

The general expectation is that powering on a power-domain should make
the power domain deliver some power, and if a specific performance state
is needed further requests has to be made.

But in contrast with other power-domain implementations (e.g. rpmpd) the
RPMh does not have an interface to enable the power, so the driver has
to vote for a particular corner (performance level) in rpmh_power_on().

But the corner is never initialized, so a typical request to simply
enable the power domain would not actually turn on the hardware. Further
more, when no more clients vote for a performance state (i.e. the
aggregated vote is 0) the power domain would be turned off.

Fix both of these issues by always voting for a corner with non-zero
value, when the power domain is enabled.

The tracking of the lowest non-zero corner is performed to handle the
corner case if there's ever a domain with a non-zero lowest corner, in
which case both rpmh_power_on() and rpmh_rpmhpd_set_performance_state()
would be allowed to use this lowest corner.

Fixes: 279b7e8a62cc ("soc: qcom: rpmhpd: Add RPMh power domain driver")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20211005033732.2284447-1-bjorn.andersson@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/rpmhpd.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/qcom/rpmhpd.c b/drivers/soc/qcom/rpmhpd.c
index fa209b479ab35..a46735cec3f0f 100644
--- a/drivers/soc/qcom/rpmhpd.c
+++ b/drivers/soc/qcom/rpmhpd.c
@@ -30,6 +30,7 @@
  * @active_only:	True if it represents an Active only peer
  * @corner:		current corner
  * @active_corner:	current active corner
+ * @enable_corner:	lowest non-zero corner
  * @level:		An array of level (vlvl) to corner (hlvl) mappings
  *			derived from cmd-db
  * @level_count:	Number of levels supported by the power domain. max
@@ -47,6 +48,7 @@ struct rpmhpd {
 	const bool	active_only;
 	unsigned int	corner;
 	unsigned int	active_corner;
+	unsigned int	enable_corner;
 	u32		level[RPMH_ARC_MAX_LEVELS];
 	size_t		level_count;
 	bool		enabled;
@@ -385,13 +387,13 @@ static int rpmhpd_aggregate_corner(struct rpmhpd *pd, unsigned int corner)
 static int rpmhpd_power_on(struct generic_pm_domain *domain)
 {
 	struct rpmhpd *pd = domain_to_rpmhpd(domain);
-	int ret = 0;
+	unsigned int corner;
+	int ret;
 
 	mutex_lock(&rpmhpd_lock);
 
-	if (pd->corner)
-		ret = rpmhpd_aggregate_corner(pd, pd->corner);
-
+	corner = max(pd->corner, pd->enable_corner);
+	ret = rpmhpd_aggregate_corner(pd, corner);
 	if (!ret)
 		pd->enabled = true;
 
@@ -436,6 +438,10 @@ static int rpmhpd_set_performance_state(struct generic_pm_domain *domain,
 		i--;
 
 	if (pd->enabled) {
+		/* Ensure that the domain isn't turn off */
+		if (i < pd->enable_corner)
+			i = pd->enable_corner;
+
 		ret = rpmhpd_aggregate_corner(pd, i);
 		if (ret)
 			goto out;
@@ -472,6 +478,10 @@ static int rpmhpd_update_level_mapping(struct rpmhpd *rpmhpd)
 	for (i = 0; i < rpmhpd->level_count; i++) {
 		rpmhpd->level[i] = buf[i];
 
+		/* Remember the first corner with non-zero level */
+		if (!rpmhpd->level[rpmhpd->enable_corner] && rpmhpd->level[i])
+			rpmhpd->enable_corner = i;
+
 		/*
 		 * The AUX data may be zero padded.  These 0 valued entries at
 		 * the end of the map must be ignored.
-- 
2.33.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0BE3C4D9E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242411AbhGLHNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:13:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238026AbhGLHLl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:11:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06D9E6108B;
        Mon, 12 Jul 2021 07:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073733;
        bh=CX6JOYgwpzBOcibnmxjTZabMLkdrNt4ga5d351AtVfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aeQbFZK/Xvx3oJMTSN3UJnNDtWWhXFS7ZyyoSzzB6Jdznw1FT3p4/rJkiInKxjuHK
         FgjHz+lNiAIZuuffxPQ3Q+jTpibQ/g4wg50Ky+ZASVd9xstUKEWoaeh2RE4NqyvotM
         +iBcJVojAcfHOBJetOVbcK2MpI7N4EvRPHgSzSGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 340/700] PM / devfreq: passive: Fix get_target_freq when not using required-opp
Date:   Mon, 12 Jul 2021 08:07:03 +0200
Message-Id: <20210712061012.481169146@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chanwoo Choi <cw00.choi@samsung.com>

[ Upstream commit 8c37d01e1a86073d15ea7084390fba58d9a1665f ]

The 86ad9a24f21e ("PM / devfreq: Add required OPPs support to passive governor")
supported the required-opp property for using devfreq passive governor.
But, 86ad9a24f21e has caused the problem on use-case when required-opp
is not used such as exynos-bus.c devfreq driver. So that fix the
get_target_freq of passive governor for supporting the case of when
required-opp is not used.

Fixes: 86ad9a24f21e ("PM / devfreq: Add required OPPs support to passive governor")
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/governor_passive.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/devfreq/governor_passive.c b/drivers/devfreq/governor_passive.c
index b094132bd20b..fc09324a03e0 100644
--- a/drivers/devfreq/governor_passive.c
+++ b/drivers/devfreq/governor_passive.c
@@ -65,7 +65,7 @@ static int devfreq_passive_get_target_freq(struct devfreq *devfreq,
 		dev_pm_opp_put(p_opp);
 
 		if (IS_ERR(opp))
-			return PTR_ERR(opp);
+			goto no_required_opp;
 
 		*freq = dev_pm_opp_get_freq(opp);
 		dev_pm_opp_put(opp);
@@ -73,6 +73,7 @@ static int devfreq_passive_get_target_freq(struct devfreq *devfreq,
 		return 0;
 	}
 
+no_required_opp:
 	/*
 	 * Get the OPP table's index of decided frequency by governor
 	 * of parent device.
-- 
2.30.2




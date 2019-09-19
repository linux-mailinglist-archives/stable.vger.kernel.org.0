Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACC4FB86B0
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392088AbfISWPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:15:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393851AbfISWPK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:15:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F51921928;
        Thu, 19 Sep 2019 22:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931309;
        bh=K93ZfifvKFmK/rsmxc+R5+nB6ROmf3mlE/wOO2Vb1Ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EBm+AfMLGl7cw4Mb8h5eYh2VN3Q1FRK2dMoFFDX7pwzZIbGMY4TeHtoWSCXSf0FlY
         SrDhv2Bs+3LU2QoLX4Ap2HPaSIZi1uySI3v00No8N8hQTSSlpncwFxYcBIqv22DHao
         wGDx/Wkxc3OYHkJCX4NoDTJaqTf9mVH5u0Hp/v1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Todd Seidelmann <tseidelmann@linode.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 47/79] netfilter: xt_physdev: Fix spurious error message in physdev_mt_check
Date:   Fri, 20 Sep 2019 00:03:32 +0200
Message-Id: <20190919214811.720966781@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214807.612593061@linuxfoundation.org>
References: <20190919214807.612593061@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Todd Seidelmann <tseidelmann@linode.com>

[ Upstream commit 3cf2f450fff304be9cf4868bf0df17f253bc5b1c ]

Simplify the check in physdev_mt_check() to emit an error message
only when passed an invalid chain (ie, NF_INET_LOCAL_OUT).
This avoids cluttering up the log with errors against valid rules.

For large/heavily modified rulesets, current behavior can quickly
overwhelm the ring buffer, because this function gets called on
every change, regardless of the rule that was changed.

Signed-off-by: Todd Seidelmann <tseidelmann@linode.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_physdev.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index 05f00fb20b047..cd15ea79e3e2a 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -104,11 +104,9 @@ static int physdev_mt_check(const struct xt_mtchk_param *par)
 	if (info->bitmask & (XT_PHYSDEV_OP_OUT | XT_PHYSDEV_OP_ISOUT) &&
 	    (!(info->bitmask & XT_PHYSDEV_OP_BRIDGED) ||
 	     info->invert & XT_PHYSDEV_OP_BRIDGED) &&
-	    par->hook_mask & ((1 << NF_INET_LOCAL_OUT) |
-	    (1 << NF_INET_FORWARD) | (1 << NF_INET_POST_ROUTING))) {
+	    par->hook_mask & (1 << NF_INET_LOCAL_OUT)) {
 		pr_info_ratelimited("--physdev-out and --physdev-is-out only supported in the FORWARD and POSTROUTING chains with bridged traffic\n");
-		if (par->hook_mask & (1 << NF_INET_LOCAL_OUT))
-			return -EINVAL;
+		return -EINVAL;
 	}
 
 	if (!brnf_probed) {
-- 
2.20.1




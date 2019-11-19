Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1EB11017DF
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbfKSGEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 01:04:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:60646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729826AbfKSFih (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:38:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DEBF20862;
        Tue, 19 Nov 2019 05:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141915;
        bh=QBninmn1N0bnodZPUNG5LFWIH1SXzGqrLbKpZ9NwMJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1W96JjidyfI7Y/3AKYfkMJw2WK5wYL4/BWd5OR9+Nw3BOtXnejqF6NNSqMZHgPfu
         T1pw7rqPNPSfpZu+YNLq7TKUyZ9quVWwIQKrp4zJudpMnZN8s/9/0QNJU2PBetNSCK
         q3vx/CptVOt0/h2n1pKA+SUB/8/Sg88tcrufBir8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 325/422] mlxsw: Make MLXSW_SP1_FWREV_MINOR a hard requirement
Date:   Tue, 19 Nov 2019 06:18:42 +0100
Message-Id: <20191119051420.076010542@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

[ Upstream commit 12ba7e1045521ec9f251c93ae0a6735cc3f42337 ]

Up until now, mlxsw tolerated firmware versions that weren't exactly
matching the required version, if the branch number matched. That
allowed the users to test various firmware versions as long as they were
on the right branch.

On the other hand, it made it impossible for mlxsw to put a hard lower
bound on a version that fixes all problems known to date. If a user had
a somewhat older FW version installed, mlxsw would start up just fine,
possibly performing non-optimally as it would use features that trigger
problematic behavior.

Therefore tweak the check to accept any FW version that is:

- on the same branch as the preferred version, and
- the same as or newer than the preferred version.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 1c170a0fd2cc9..e498ee95bacab 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -336,7 +336,10 @@ static int mlxsw_sp_fw_rev_validate(struct mlxsw_sp *mlxsw_sp)
 		return -EINVAL;
 	}
 	if (MLXSW_SP_FWREV_MINOR_TO_BRANCH(rev->minor) ==
-	    MLXSW_SP_FWREV_MINOR_TO_BRANCH(req_rev->minor))
+	    MLXSW_SP_FWREV_MINOR_TO_BRANCH(req_rev->minor) &&
+	    (rev->minor > req_rev->minor ||
+	     (rev->minor == req_rev->minor &&
+	      rev->subminor >= req_rev->subminor)))
 		return 0;
 
 	dev_info(mlxsw_sp->bus_info->dev, "The firmware version %d.%d.%d is incompatible with the driver\n",
-- 
2.20.1




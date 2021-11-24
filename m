Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5976245C558
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347652AbhKXN4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:56:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352075AbhKXNyq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:54:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 718D061A51;
        Wed, 24 Nov 2021 13:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759162;
        bh=xXegRvPQDgj3JG9BA/uoacZeQuIHIWmQcmXqKxY+Msk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZFnckFf0ZtNg2giGLzoWvcG+Cl2fO1OqkLcs2f/9EjKwDSklE1tjeyfa/BtmM/UKG
         g1NlhfDD+qbmJQtIIQRH+5MkpjKevYTwOTIldfbRoCisyohLz4BuhwgjN5FBLcRCRT
         Fn1jTX85jG9GMrvcEjMhVPbDl+2cbQ0MXLjcpVPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 151/279] net/mlx5: E-Switch, return error if encap isnt supported
Date:   Wed, 24 Nov 2021 12:57:18 +0100
Message-Id: <20211124115723.982875846@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

[ Upstream commit c4c3176739dfa6efcc5b1d1de4b3fd2b51b048c7 ]

On regular ConnectX HCAs getting encap mode isn't supported when the
E-Switch is in NONE mode. Current code would return no error code when
trying to get encap mode in such case which is wrong.

Fix by returning error value to indicate failure to caller in such case.

Fixes: 8e0aa4bc959c ("net/mlx5: E-switch, Protect eswitch mode changes")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 08534d562d5a9..0c79e11339362 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3581,7 +3581,7 @@ int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
 	*encap = esw->offloads.encap;
 unlock:
 	up_write(&esw->mode_lock);
-	return 0;
+	return err;
 }
 
 static bool
-- 
2.33.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C511D0D79
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387936AbgEMJxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:53:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387926AbgEMJxR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:53:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B25A723127;
        Wed, 13 May 2020 09:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363597;
        bh=IflCjPG2xi5TTNJDFZpm013QD6WriFjIurebSx5OlPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGk+qwp9eRbERVfZMuc4fCWLkAhrbuQ5LB0vFW4uWbpl0trYmPK8wVMEHHRV5XYQQ
         syEEpz/glAvij97WC2j5vk8wxlNsjYMHU5hIAz1KrbPpEHBqeiMow6RaTIQwT6E2Np
         HMryQ8ov1F5NJRN9OF2+rONHPd5EhvQZKJQPrbaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.6 048/118] net/mlx5: Fix command entry leak in Internal Error State
Date:   Wed, 13 May 2020 11:44:27 +0200
Message-Id: <20200513094421.411784983@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

[ Upstream commit cece6f432cca9f18900463ed01b97a152a03600a ]

Processing commands by cmd_work_handler() while already in Internal
Error State will result in entry leak, since the handler process force
completion without doorbell. Forced completion doesn't release the entry
and event completion will never arrive, so entry should be released.

Fixes: 73dd3a4839c1 ("net/mlx5: Avoid using pending command interface slots")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -922,6 +922,10 @@ static void cmd_work_handler(struct work
 		MLX5_SET(mbox_out, ent->out, syndrome, drv_synd);
 
 		mlx5_cmd_comp_handler(dev, 1UL << ent->idx, true);
+		/* no doorbell, no need to keep the entry */
+		free_ent(cmd, ent->idx);
+		if (ent->callback)
+			free_cmd(ent);
 		return;
 	}
 



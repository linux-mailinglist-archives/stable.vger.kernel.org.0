Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0E1110B8B8
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbfK0UqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:46:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:57596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729820AbfK0UqE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:46:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6A1F21835;
        Wed, 27 Nov 2019 20:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887564;
        bh=sF0MbDNgGvZVLd10BjgaxgtQZf6HRf/9lU77UlNzvtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBb6L9pvVfLIR84kYSu6ve9kg4W2RacEmT++tjClvV2c60gHuUxCh0j/K5dctIEAJ
         ebPcuCmYToG52FnGO9nUX9oUgjqeNCbwnsrNUqCTnFgHvT7AMJiSrVOv9COckjgSAH
         wn12uP1+ve50TaPnLEjNebkjGEaOsMBLB4qZK4Tg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luigi Rizzo <lrizzo@google.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH 4.14 001/211] net/mlx4_en: fix mlx4 ethtool -N insertion
Date:   Wed, 27 Nov 2019 21:28:54 +0100
Message-Id: <20191127203049.588851589@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luigi Rizzo <lrizzo@google.com>

[ Upstream commit 34e59836565e36fade1464e054a3551c1a0364be ]

ethtool expects ETHTOOL_GRXCLSRLALL to set ethtool_rxnfc->data with the
total number of entries in the rx classifier table.  Surprisingly, mlx4
is missing this part (in principle ethtool could still move forward and
try the insert).

Tested: compiled and run command:
	phh13:~# ethtool -N eth1 flow-type udp4  queue 4
	Added rule with ID 255

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -1722,6 +1722,7 @@ static int mlx4_en_get_rxnfc(struct net_
 		err = mlx4_en_get_flow(dev, cmd, cmd->fs.location);
 		break;
 	case ETHTOOL_GRXCLSRLALL:
+		cmd->data = MAX_NUM_OF_FS_RULES;
 		while ((!err || err == -ENOENT) && priority < cmd->rule_cnt) {
 			err = mlx4_en_get_flow(dev, cmd, i);
 			if (!err)



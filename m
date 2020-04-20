Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033791B0C24
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 15:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgDTMkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:40:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727016AbgDTMkP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:40:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B69C421473;
        Mon, 20 Apr 2020 12:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386415;
        bh=bbRjPx1l8zYLS8ZjOXl1hmhn4EhtfYc4TTol1ueqNpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z2m4WsBuBnxnEK8XADSzYCbAYtMbqotjlJraOdziy+e4Zs9tHlucqVYBD232m1s0j
         9f/aeskEn2GQ34ojCzRHGWV7fdxX0QAC68ud8juYXv2CoLeQcH2q6gS2vciFP27Xdr
         kELwWknlkEAKfPtlHzoCb85L4sJQGTNh22K2Db/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.5 14/65] net/mlx5e: Add missing release firmware call
Date:   Mon, 20 Apr 2020 14:38:18 +0200
Message-Id: <20200420121509.302720548@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121505.909671922@linuxfoundation.org>
References: <20200420121505.909671922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

[ Upstream commit d19987ccf57501894fdd8fadc2e55e4a3dd57239 ]

Once driver finishes flashing the firmware image, it should release it.

Fixes: 9c8bca2637b8 ("mlx5: Move firmware flash implementation to devlink")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -23,7 +23,10 @@ static int mlx5_devlink_flash_update(str
 	if (err)
 		return err;
 
-	return mlx5_firmware_flash(dev, fw, extack);
+	err = mlx5_firmware_flash(dev, fw, extack);
+	release_firmware(fw);
+
+	return err;
 }
 
 static u8 mlx5_fw_ver_major(u32 version)



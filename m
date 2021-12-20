Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590B647AF85
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239838AbhLTPOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238294AbhLTPMV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:12:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607AFC08EB4D;
        Mon, 20 Dec 2021 06:56:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00088611D8;
        Mon, 20 Dec 2021 14:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36D9C36AE7;
        Mon, 20 Dec 2021 14:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012209;
        bh=Q8uh3qh1vkEPHVDxw/wIY4+l6Kisd1nOUIUC9SIrK30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hZqZtrUhdNXWLVpNDywmOHL/4WHYi7CO9Wd2ar8ALVa8puUCXjyKs29zP8NN1xtQP
         2k4Dq7DKdHEbR4qxXHiBdksJuccNg+hYGVnXOsCJm1qYXsJZ3M3aq/uetKk2Y43blr
         yHUFeJWq5w6Jow5GtkVVt2xj9Gw4zVnb83JGxWLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        kernel test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/177] sfc_ef100: potential dereference of null pointer
Date:   Mon, 20 Dec 2021 15:34:12 +0100
Message-Id: <20211220143043.529990307@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 407ecd1bd726f240123f704620d46e285ff30dd9 ]

The return value of kmalloc() needs to be checked.
To avoid use in efx_nic_update_stats() in case of the failure of alloc.

Fixes: b593b6f1b492 ("sfc_ef100: statistics gathering")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 518268ce20644..d35cafd422b1c 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -609,6 +609,9 @@ static size_t ef100_update_stats(struct efx_nic *efx,
 	ef100_common_stat_mask(mask);
 	ef100_ethtool_stat_mask(mask);
 
+	if (!mc_stats)
+		return 0;
+
 	efx_nic_copy_stats(efx, mc_stats);
 	efx_nic_update_stats(ef100_stat_desc, EF100_STAT_COUNT, mask,
 			     stats, mc_stats, false);
-- 
2.33.0




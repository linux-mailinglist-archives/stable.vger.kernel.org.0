Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B705634C7D2
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbhC2IST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:18:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233213AbhC2IRI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:17:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBA6D619D7;
        Mon, 29 Mar 2021 08:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005802;
        bh=Qf6WRzLXOfkPVr6+tyAWYIuSf30ymOOqJmelHgbPUp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o8EwzPzxWyppwLDAlbiYwvU8qtkrZH+Jl2HpegBMMCxOp1N46vmxBvV6YN7lGYO3H
         1tNZuSqks+G9f34V39HxcDQtLnU0ZzpGHy/O1Ov7XipSH6cL/ONja4bboXyuFrb+wV
         2J76L8fBy4sQYNUDbHm2h5ZJ/f0jYjrPt8sKUgqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/221] ixgbe: Fix memleak in ixgbe_configure_clsu32
Date:   Mon, 29 Mar 2021 09:55:42 +0200
Message-Id: <20210329075629.560476143@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 7a766381634da19fc837619b0a34590498d9d29a ]

When ixgbe_fdir_write_perfect_filter_82599() fails,
input allocated by kzalloc() has not been freed,
which leads to memleak.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index f3f449f53920..278fc866fad4 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -9582,8 +9582,10 @@ static int ixgbe_configure_clsu32(struct ixgbe_adapter *adapter,
 	ixgbe_atr_compute_perfect_hash_82599(&input->filter, mask);
 	err = ixgbe_fdir_write_perfect_filter_82599(hw, &input->filter,
 						    input->sw_idx, queue);
-	if (!err)
-		ixgbe_update_ethtool_fdir_entry(adapter, input, input->sw_idx);
+	if (err)
+		goto err_out_w_lock;
+
+	ixgbe_update_ethtool_fdir_entry(adapter, input, input->sw_idx);
 	spin_unlock(&adapter->fdir_perfect_lock);
 
 	if ((uhtid != 0x800) && (adapter->jump_tables[uhtid]))
-- 
2.30.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C3834C73A
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbhC2INV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:13:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232837AbhC2IMS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:12:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BC6D61477;
        Mon, 29 Mar 2021 08:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005538;
        bh=ryleGtj8EIXRDb+NrHQj52DR2z0e0CXCODhsYyXnwFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uUnFJIsST3Atv5j9+A5k/kQrjPEfuICV0Wh+4D8aPuz1xJDMB4HtdiPPTgDyKQA5p
         aZ9OKuCCHI2Hl6xHxfcnKeB49TmFQBw4yrhQij9Awzj06c6kT36IBsrl36hQXfuJ59
         P0xx1ujdi8v7FdqQa4QCU+inIeuAmiEThMzVkuIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 008/111] ixgbe: Fix memleak in ixgbe_configure_clsu32
Date:   Mon, 29 Mar 2021 09:57:16 +0200
Message-Id: <20210329075615.481712482@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
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
index f60554064403..1b8e70585c44 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -9595,8 +9595,10 @@ static int ixgbe_configure_clsu32(struct ixgbe_adapter *adapter,
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




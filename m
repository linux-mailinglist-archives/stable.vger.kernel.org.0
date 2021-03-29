Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A48934C5C7
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbhC2ICy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:02:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231739AbhC2ICU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:02:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D220D61969;
        Mon, 29 Mar 2021 08:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617004940;
        bh=Lw244POhdlwttd+pyLgsWKoLcDose81w/p0dOZupmnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=llJW9BKwVTnY3aVZELgjo364QngCdHJmhEUPUOvL/Pvhpc9Qih6HWzGIRaEpNujeG
         ERUvckcAZ8cm4XRor+Hj3yLSQk/kB23RttFobTXLXFwpfpekzvanZu32mDgGFDceRX
         PvdaugbrYGDrXsRd/5DnjKBvJ3KxnF3aBJhVCT/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 05/53] ixgbe: Fix memleak in ixgbe_configure_clsu32
Date:   Mon, 29 Mar 2021 09:57:40 +0200
Message-Id: <20210329075607.734238239@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075607.561619583@linuxfoundation.org>
References: <20210329075607.561619583@linuxfoundation.org>
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
index 36d73bf32f4f..8e2aaf774693 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -8677,8 +8677,10 @@ static int ixgbe_configure_clsu32(struct ixgbe_adapter *adapter,
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




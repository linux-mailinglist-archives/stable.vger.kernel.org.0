Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318FA47AD80
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237549AbhLTOwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:52:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42058 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238437AbhLTOub (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:50:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92525611A4;
        Mon, 20 Dec 2021 14:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B8CC36AE7;
        Mon, 20 Dec 2021 14:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011831;
        bh=uY5ypyLGENVFu/AfdQ5m9JGp5nazfWqo3Onu1CXI8PI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fnYheI0fk6g/JBQedTw3vxEMuQo3wLTa8ZNB7lCLk5j+pDTrrglT01Vfa7MkAwodj
         zUSuMy5swKeBmzevLQCXoZwLhE642wLDmpPx12pxLoyoVRRTaGPBVjH9N3ttQ80dkr
         PHgeO9L+Ozqf6jzVLUY6wD12UmRVO++ZQyD1VYJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        kernel test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 57/99] sfc_ef100: potential dereference of null pointer
Date:   Mon, 20 Dec 2021 15:34:30 +0100
Message-Id: <20211220143031.308507794@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
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
index 3148fe7703564..cb6897c2193c2 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -597,6 +597,9 @@ static size_t ef100_update_stats(struct efx_nic *efx,
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13743E7E49
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbhHJRcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:32:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230295AbhHJRcQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:32:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFDEE61052;
        Tue, 10 Aug 2021 17:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616714;
        bh=FYT/3Ix4m4ywqlYlcQHDsUk7ihSW3PR4wiskT1f4rP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3CAhA/2olhPnDT8H6Ynn83XSwJ7SvrzYiVyim/uy3VmYkHhN4Juc5Xoy1fcqeNim
         XETzFVlTFG/4/JSGylQfPHbK/O8aWI1wK0kYs9rs8EkeiK3kWmoZXxLaT0RnV1qK32
         6BTIOg8s3A5EytqaNLXeEwya8lUvthFHp2s+gk2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 15/54] bnx2x: fix an error code in bnx2x_nic_load()
Date:   Tue, 10 Aug 2021 19:30:09 +0200
Message-Id: <20210810172944.686394419@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
References: <20210810172944.179901509@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit fb653827c758725b149b5c924a5eb50ab4812750 ]

Set the error code if bnx2x_alloc_fw_stats_mem() fails.  The current
code returns success.

Fixes: ad5afc89365e ("bnx2x: Separate VF and PF logic")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index cf01e73d1bcc..2610acf9ac36 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -2668,7 +2668,8 @@ int bnx2x_nic_load(struct bnx2x *bp, int load_mode)
 	}
 
 	/* Allocated memory for FW statistics  */
-	if (bnx2x_alloc_fw_stats_mem(bp))
+	rc = bnx2x_alloc_fw_stats_mem(bp);
+	if (rc)
 		LOAD_ERROR_EXIT(bp, load_error0);
 
 	/* request pf to initialize status blocks */
-- 
2.30.2




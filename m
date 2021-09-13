Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE044092FA
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244081AbhIMOQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:16:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344781AbhIMOOl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:14:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E386461407;
        Mon, 13 Sep 2021 13:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540617;
        bh=4tF9IjJY9YncUcD7vJWy/zhfzoF/ywSY1A/tB1XiNLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jt1Jl9/DBbCt8/rUJRn0N8EpuOUiDK4D1FkX4qLG94MAcxNNj5JAoqKDVvO8ociiw
         C4GTqTIPOqeRmqI6ISZw3Wgh+HTBwM98XfqjGTv3s4uSAQbazCmGRh9ffLyeuonPMZ
         XQR2hOsr7yaIPLplyCnyDjOCNqytYJwnEhqAqpsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 233/300] octeontx2-pf: cn10k: Fix error return code in otx2_set_flowkey_cfg()
Date:   Mon, 13 Sep 2021 15:14:54 +0200
Message-Id: <20210913131117.232313829@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 5e8243e66b4d80eeaf9ed8cb0235ff133630a014 ]

If otx2_mbox_get_rsp() fails, otx2_set_flowkey_cfg() need return an
error code.

Fixes: e7938365459f ("octeontx2-pf: Fix algorithm index in MCAM rules with RSS action")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 25f84ad50dba..e0d1af9e7770 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -286,8 +286,10 @@ int otx2_set_flowkey_cfg(struct otx2_nic *pfvf)
 
 	rsp = (struct nix_rss_flowkey_cfg_rsp *)
 			otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
-	if (IS_ERR(rsp))
+	if (IS_ERR(rsp)) {
+		err = PTR_ERR(rsp);
 		goto fail;
+	}
 
 	pfvf->hw.flowkey_alg_idx = rsp->alg_idx;
 fail:
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7948940957E
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347724AbhIMOmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:42:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346992AbhIMOkK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:40:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0813C6124F;
        Mon, 13 Sep 2021 13:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541341;
        bh=ZuOlyXCbnPphzapEKkJdCeBERI2GBkkUVQ3dxg0NZlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=va3TTilfdS7UGHidaR2tj35JIqzKzSNq3C7jf24TQKzbxn22syVisJjo45MijeH8R
         pNP2Neepsr45P2vUlcSgBpY3vLlkvcu9HEAXab7pxEyxySDYYlmzd9a0uOnzCZb6kn
         DAQ6T7q08/Bf5pZKZf/CQfsms6yj7QBCbiIlDEGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 259/334] octeontx2-pf: cn10k: Fix error return code in otx2_set_flowkey_cfg()
Date:   Mon, 13 Sep 2021 15:15:13 +0200
Message-Id: <20210913131122.163396352@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
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
index a6210b020a57..94dfd64f526f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -289,8 +289,10 @@ int otx2_set_flowkey_cfg(struct otx2_nic *pfvf)
 
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




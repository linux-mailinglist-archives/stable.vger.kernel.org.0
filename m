Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA43499383
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385768AbiAXUeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:34:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51850 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382738AbiAXU0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:26:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36531614E2;
        Mon, 24 Jan 2022 20:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7B7C340E5;
        Mon, 24 Jan 2022 20:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055975;
        bh=dK3hIHSJOFGdVBAyhBXTzS2yjHybOl79EpD320zhCR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gN1njHKjjVITb6ykXkYIxLhz8yvJRNYipZy7PvH6DxBePxCj4V6HGnmxjQx+5W5CK
         3P0e0druT/5H06sOzgagriqspbedyaZ9gX8EKJuNPU6Bt6mhmw6/b8dpvPyIAb1j0v
         3wD/2bHc280HTBHMgvFXmcjW5aA+vL0XlvczUiiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 295/846] crypto: octeontx2 - prevent underflow in get_cores_bmap()
Date:   Mon, 24 Jan 2022 19:36:52 +0100
Message-Id: <20220124184111.092181928@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 10371b6212bb682f13247733d6b76b91b2b80f9a ]

If we're going to cap "eng_grp->g->engs_num" upper bounds then we should
cap the lower bounds as well.

Fixes: 43ac0b824f1c ("crypto: octeontx2 - load microcode and create engine groups")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index dff34b3ec09e1..7c1b92aaab398 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -29,7 +29,8 @@ static struct otx2_cpt_bitmap get_cores_bmap(struct device *dev,
 	bool found = false;
 	int i;
 
-	if (eng_grp->g->engs_num > OTX2_CPT_MAX_ENGINES) {
+	if (eng_grp->g->engs_num < 0 ||
+	    eng_grp->g->engs_num > OTX2_CPT_MAX_ENGINES) {
 		dev_err(dev, "unsupported number of engines %d on octeontx2\n",
 			eng_grp->g->engs_num);
 		return bmap;
-- 
2.34.1




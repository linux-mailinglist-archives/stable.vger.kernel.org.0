Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D1827C577
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729919AbgI2Lfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:35:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729873AbgI2Lfg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:35:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1287723D69;
        Tue, 29 Sep 2020 11:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379023;
        bh=VFwynM5GW10yk4he07IQYihMCJ85BKpVtOum0pONdGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QY96MkAEnKldgXX+NEiL9CBvK9XSXUIdcYY4BIagqZDVFQ0iY+ycCjd1JIwDz4Pym
         nVKJXO9YD8c/sOuV+sbjgzlbzUojU5nBqVDEqwUuW1qanABg9grhRNcRLK8tR9SEQX
         1SQrBSZSQexaUCuCkwjJjkJ56hsnwAtRJrSFUoGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 225/245] net: qed: RDMA personality shouldnt fail VF load
Date:   Tue, 29 Sep 2020 13:01:16 +0200
Message-Id: <20200929105957.935021852@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

[ Upstream commit ce1cf9e5025f4e2d2198728391f1847b3e168bc6 ]

Fix the assert during VF driver installation when the personality is iWARP

Fixes: 1fe614d10f45 ("qed: Relax VF firmware requirements")
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_sriov.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index 71a7af134dd8e..886c7aae662fa 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -96,6 +96,7 @@ static int qed_sp_vf_start(struct qed_hwfn *p_hwfn, struct qed_vf_info *p_vf)
 		p_ramrod->personality = PERSONALITY_ETH;
 		break;
 	case QED_PCI_ETH_ROCE:
+	case QED_PCI_ETH_IWARP:
 		p_ramrod->personality = PERSONALITY_RDMA_AND_ETH;
 		break;
 	default:
-- 
2.25.1




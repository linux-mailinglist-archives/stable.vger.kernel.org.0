Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C476F2C0AFB
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731336AbgKWMeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:34:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:45860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731326AbgKWMeN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:34:13 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 586902065E;
        Mon, 23 Nov 2020 12:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134852;
        bh=nkMEbw7y4uctaWp/3Yr/LsCUmBn1Twxw2ozfR+zNMnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B+iSASYg5fW3nP6FQP1ncNsoS6+rZHCicPLP2N0L5gw/IYXqW53wbzNs212WipmLN
         0yE+JhEkEA6ExH1CJSpNzQq35/ZRLMfzfJjtPProne1rcM97qfpfBkFLB0sbvcdEga
         o+Gihzx/W11rkivAi29uC6UhS/DU3lSJQb4U7QZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 014/158] net: ethernet: ti: cpsw: fix error return code in cpsw_probe()
Date:   Mon, 23 Nov 2020 13:20:42 +0100
Message-Id: <20201123121820.626225773@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 35f735c665114840dcd3142f41148d07870f51f7 ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 83a8471ba255 ("net: ethernet: ti: cpsw: refactor probe to group common hw initialization")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/r/1605250173-18438-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/cpsw.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -2876,6 +2876,7 @@ static int cpsw_probe(struct platform_de
 				       CPSW_MAX_QUEUES, CPSW_MAX_QUEUES);
 	if (!ndev) {
 		dev_err(dev, "error allocating net_device\n");
+		ret = -ENOMEM;
 		goto clean_cpts;
 	}
 



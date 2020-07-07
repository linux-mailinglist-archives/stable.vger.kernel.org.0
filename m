Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120BC2171CA
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729882AbgGGPZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:25:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728903AbgGGPZu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:25:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67F752082E;
        Tue,  7 Jul 2020 15:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135549;
        bh=yarrN/SMtJ/H7bc1F42VTZOXDsUTCBQx14FHEqb7RuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jpzd38OmCDYL2qwoIGEP6AzcltkZuDyuOG9VY4DkgAmv4YHomvjs7GjbZDaRhboWS
         U+1/6+Ytns6r1cspxSCZN+gbgQp4Ri/ce1Itcc4ynJ7I5gOVereq2ZAVY9/vCv9Jcd
         hlhI6WqzDc0YsH+du2gpg4jal80iFxcU1bTEVA4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 058/112] cxgb4: use unaligned conversion for fetching timestamp
Date:   Tue,  7 Jul 2020 17:17:03 +0200
Message-Id: <20200707145803.761321697@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

[ Upstream commit 589b1c9c166dce120e27b32a83a78f55464a7ef9 ]

Use get_unaligned_be64() to fetch the timestamp needed for ns_to_ktime()
conversion.

Fixes following sparse warning:
sge.c:3282:43: warning: cast to restricted __be64

Fixes: a456950445a0 ("cxgb4: time stamping interface for PTP")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index db8106d9d6edf..28ce9856a0784 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -3300,7 +3300,7 @@ static noinline int t4_systim_to_hwstamp(struct adapter *adapter,
 
 	hwtstamps = skb_hwtstamps(skb);
 	memset(hwtstamps, 0, sizeof(*hwtstamps));
-	hwtstamps->hwtstamp = ns_to_ktime(be64_to_cpu(*((u64 *)data)));
+	hwtstamps->hwtstamp = ns_to_ktime(get_unaligned_be64(data));
 
 	return RX_PTP_PKT_SUC;
 }
-- 
2.25.1




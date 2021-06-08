Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20ABF3A0097
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbhFHSpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:45:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235154AbhFHSmp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:42:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC24D6143D;
        Tue,  8 Jun 2021 18:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177345;
        bh=cDRWFGrKZm0fAudf32Vf/v0rwtFWN/Dhdz+A9IEsK9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xu516bteEokzS+FRyT7VjmNdsHwUB+GuobCei8bkj6oNeGlcJsHhMFsnbz+V3OpCA
         E5GuUinoZSrsL6DinE/cUShHDxQg+0FLUbZV4rssRSyJensFDv3hskoFw/V5Nxqmtc
         IFkxuQHwreuBSVlpTC3/kPIY3efv+e7fgLqgJVbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 19/78] netfilter: nfnetlink_cthelper: hit EBUSY on updates if size mismatches
Date:   Tue,  8 Jun 2021 20:26:48 +0200
Message-Id: <20210608175935.915079075@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 8971ee8b087750a23f3cd4dc55bff2d0303fd267 ]

The private helper data size cannot be updated. However, updates that
contain NFCTH_PRIV_DATA_LEN might bogusly hit EBUSY even if the size is
the same.

Fixes: 12f7a505331e ("netfilter: add user-space connection tracking helper infrastructure")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_cthelper.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 81406b93f126..3d5fc07b2530 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -380,10 +380,14 @@ static int
 nfnl_cthelper_update(const struct nlattr * const tb[],
 		     struct nf_conntrack_helper *helper)
 {
+	u32 size;
 	int ret;
 
-	if (tb[NFCTH_PRIV_DATA_LEN])
-		return -EBUSY;
+	if (tb[NFCTH_PRIV_DATA_LEN]) {
+		size = ntohl(nla_get_be32(tb[NFCTH_PRIV_DATA_LEN]));
+		if (size != helper->data_len)
+			return -EBUSY;
+	}
 
 	if (tb[NFCTH_POLICY]) {
 		ret = nfnl_cthelper_update_policy(helper, tb[NFCTH_POLICY]);
-- 
2.30.2




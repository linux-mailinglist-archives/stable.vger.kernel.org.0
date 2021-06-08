Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E9739FF36
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbhFHSbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:31:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234153AbhFHSbO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:31:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 049C9613B9;
        Tue,  8 Jun 2021 18:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623176945;
        bh=OkZwXrHpxEFAEoYWsY/fBqlUlzOVkf3DGeAuhfwiJ0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=efZ41uaVB9PnsUZ6J+RtrHfAodXYmTe/FzHuhTf/3a/O+0hCUTyO8gKSsKeNasLpg
         FoaipKNCNb9vRTXOwX5iB97etSjTJF1Bu/vJ8zN++5y59Z8RDieD6wzd4moZ2M5FMq
         pYp1S+fU6wFYvzOagmsXKUjBZRYk3NrSLUTHcndY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 06/23] netfilter: nfnetlink_cthelper: hit EBUSY on updates if size mismatches
Date:   Tue,  8 Jun 2021 20:26:58 +0200
Message-Id: <20210608175926.752384937@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175926.524658689@linuxfoundation.org>
References: <20210608175926.524658689@linuxfoundation.org>
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
index 8c1733869343..63a9d5fd00c0 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -355,10 +355,14 @@ static int
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




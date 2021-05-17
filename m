Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE3D3836EB
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244850AbhEQPhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:37:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243219AbhEQPf1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:35:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7D1061CE6;
        Mon, 17 May 2021 14:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262387;
        bh=bHYA8Dfl/fBT+THpRKXg/JP2T5wRvL428Kuetier2Xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vhWuHMr7R/zZ0322CcCc/qRcgvOznpyxNCDexG7EAy8m5BCiXutv1c5oOHS60Pzvr
         iEPdEpw1FLN9kQSaqYxLg7B17R+tavamJ2Etjb3AWkifgLXFAGIa/TqS3FOpQ4pTJy
         lwxeGKAGa+UTZ4/AGMWzKwphC6FHU22AcHpEo/wU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 177/289] netfilter: nftables: Fix a memleak from userdata error path in new objects
Date:   Mon, 17 May 2021 16:01:42 +0200
Message-Id: <20210517140311.075308368@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 85dfd816fabfc16e71786eda0a33a7046688b5b0 ]

Release object name if userdata allocation fails.

Fixes: b131c96496b3 ("netfilter: nf_tables: add userdata support for nft_object")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2e76935db2c8..7bf7bfa0c7d9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6015,9 +6015,9 @@ err_obj_ht:
 	INIT_LIST_HEAD(&obj->list);
 	return err;
 err_trans:
-	kfree(obj->key.name);
-err_userdata:
 	kfree(obj->udata);
+err_userdata:
+	kfree(obj->key.name);
 err_strdup:
 	if (obj->ops->destroy)
 		obj->ops->destroy(&ctx, obj);
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6B53835C1
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243856AbhEQPYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:24:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244667AbhEQPVd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:21:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F44E61C8F;
        Mon, 17 May 2021 14:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262076;
        bh=03/YOv9J5byMtt2hkcBcjvHCBH+98XjqMkGWEYun9hY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j1iZpBtyYIW3orx6IMs0UHpYvDbeaJGyXExPZhUOp46YJMBmr6ofRX73HQ3QSWfCs
         90X+v7tAdMpRTLR939grRtYoCwyZn23275w9HOSsaH77E/PiZbA443g3ReTvdsGqpn
         6WzTGSoa1rHHtLDwCb+KjDamsN6Ull+cDS1xgGI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 212/329] netfilter: nftables: Fix a memleak from userdata error path in new objects
Date:   Mon, 17 May 2021 16:02:03 +0200
Message-Id: <20210517140309.308817583@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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
index d6ec76a0fe62..1380369d5787 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6213,9 +6213,9 @@ err_obj_ht:
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




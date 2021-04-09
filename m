Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8010C359AAF
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233906AbhDIKBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:01:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233914AbhDIJ7W (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 05:59:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4D2A61244;
        Fri,  9 Apr 2021 09:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962323;
        bh=REayMs6WJ5N/ERNHaorOq4Ew83BdhU5cdTTENSt2JzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AXZf2v/Tw0H6iB6lQ1zo6mY6uIkCC+ezBNu7xgRb2+qmS2QlFrLG7e3KxeYFVjikg
         M/RXKtJpk/vxuEsG9A/HTlU182A6r3ZO+crGNJ6ZjQ0Rk6DrfB3FkSoR/2CeASFrJD
         MMtZcERnlpEffvOhZs97o0ftJGvdgpjBxrGTBADg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 15/41] netfilter: nftables: skip hook overlap logic if flowtable is stale
Date:   Fri,  9 Apr 2021 11:53:37 +0200
Message-Id: <20210409095305.331391616@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095304.818847860@linuxfoundation.org>
References: <20210409095304.818847860@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 86fe2c19eec4728fd9a42ba18f3b47f0d5f9fd7c ]

If the flowtable has been previously removed in this batch, skip the
hook overlap checks. This fixes spurious EEXIST errors when removing and
adding the flowtable in the same batch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 978a968d7aed..2e76935db2c8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6573,6 +6573,9 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 
 	list_for_each_entry(hook, hook_list, list) {
 		list_for_each_entry(ft, &table->flowtables, list) {
+			if (!nft_is_active_next(net, ft))
+				continue;
+
 			list_for_each_entry(hook2, &ft->hook_list, list) {
 				if (hook->ops.dev == hook2->ops.dev &&
 				    hook->ops.pf == hook2->ops.pf) {
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404A9321617
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhBVMRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:17:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:45308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230361AbhBVMPO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:15:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E127B64E24;
        Mon, 22 Feb 2021 12:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996034;
        bh=rhhSYTr05rJBZkXnPWzZ+gcp6JeK+a0E1wjwmfDmpnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mVhjU/GGDemD/y/XPjD5wWsI4IvxmgdDyCd2+P1jzDmK96A/lTTysm1J2K4MnIrRc
         j6WM9IXa1LPsgCdZ02uwl8CpougNv72/YtXDpAyUQkiWA94KcrtvGxu7ImfK6PgztV
         kcs5gj+gPwVhZh37Rop/DJQO92c65lE3iQ15BS/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 12/29] net: sched: incorrect Kconfig dependencies on Netfilter modules
Date:   Mon, 22 Feb 2021 13:13:06 +0100
Message-Id: <20210222121021.933444392@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.444399883@linuxfoundation.org>
References: <20210222121019.444399883@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 102e2c07239c07144d9c7338ec09b9d47f2e5f79 ]

- NET_ACT_CONNMARK and NET_ACT_CTINFO only require conntrack support.
- NET_ACT_IPT only requires NETFILTER_XTABLES symbols, not
  IP_NF_IPTABLES. After this patch, NET_ACT_IPT becomes consistent
  with NET_EMATCH_IPT. NET_ACT_IPT dependency on IP_NF_IPTABLES predates
  Linux-2.6.12-rc2 (initial git repository build).

Fixes: 22a5dc0e5e3e ("net: sched: Introduce connmark action")
Fixes: 24ec483cec98 ("net: sched: Introduce act_ctinfo action")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Link: https://lore.kernel.org/r/20201208204707.11268-1-pablo@netfilter.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index a3b37d88800eb..d762e89ab74f7 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -813,7 +813,7 @@ config NET_ACT_SAMPLE
 
 config NET_ACT_IPT
 	tristate "IPtables targets"
-	depends on NET_CLS_ACT && NETFILTER && IP_NF_IPTABLES
+	depends on NET_CLS_ACT && NETFILTER && NETFILTER_XTABLES
 	help
 	  Say Y here to be able to invoke iptables targets after successful
 	  classification.
@@ -912,7 +912,7 @@ config NET_ACT_BPF
 
 config NET_ACT_CONNMARK
 	tristate "Netfilter Connection Mark Retriever"
-	depends on NET_CLS_ACT && NETFILTER && IP_NF_IPTABLES
+	depends on NET_CLS_ACT && NETFILTER
 	depends on NF_CONNTRACK && NF_CONNTRACK_MARK
 	help
 	  Say Y here to allow retrieving of conn mark
@@ -924,7 +924,7 @@ config NET_ACT_CONNMARK
 
 config NET_ACT_CTINFO
 	tristate "Netfilter Connection Mark Actions"
-	depends on NET_CLS_ACT && NETFILTER && IP_NF_IPTABLES
+	depends on NET_CLS_ACT && NETFILTER
 	depends on NF_CONNTRACK && NF_CONNTRACK_MARK
 	help
 	  Say Y here to allow transfer of a connmark stored information.
-- 
2.27.0




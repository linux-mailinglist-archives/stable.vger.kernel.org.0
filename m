Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C2220E53B
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391274AbgF2Vei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:34:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728590AbgF2Skz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:40:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C6CC24153;
        Mon, 29 Jun 2020 15:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443940;
        bh=VdCvBULUEvQmmVuxWkyEmYYD54v+XsoI/gX+pxPXyWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+KQgbsPuzQISCC7NrWIO4OlmihMUcmtDdofhxjRlyNnA6xSzrO1MXiKLidPexuPA
         cazQHdq01jEx2X7saREXxACXD/9tsUjEk0gNzJ/SnaB6/cxL57AyvZEQKM66NOZprP
         Y1ww5UW+BkyZnh0o7omNBDVy5Fcw7SvEN1AdBMzg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 041/265] mptcp: drop sndr_key in mptcp_syn_options
Date:   Mon, 29 Jun 2020 11:14:34 -0400
Message-Id: <20200629151818.2493727-42-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

[ Upstream commit b562f58bbc12444219b74a5d6524977a3d87a022 ]

In RFC 8684, we don't need to send sndr_key in SYN package anymore, so drop
it.

Fixes: cc7972ea1932 ("mptcp: parse and emit MP_CAPABLE option according to v1 spec")
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 1c20dd14b2aa2..2430bbfa34059 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -336,9 +336,7 @@ bool mptcp_syn_options(struct sock *sk, const struct sk_buff *skb,
 	 */
 	subflow->snd_isn = TCP_SKB_CB(skb)->end_seq;
 	if (subflow->request_mptcp) {
-		pr_debug("local_key=%llu", subflow->local_key);
 		opts->suboptions = OPTION_MPTCP_MPC_SYN;
-		opts->sndr_key = subflow->local_key;
 		*size = TCPOLEN_MPTCP_MPC_SYN;
 		return true;
 	} else if (subflow->request_join) {
-- 
2.25.1


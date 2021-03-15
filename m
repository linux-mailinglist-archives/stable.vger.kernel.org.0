Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4775C33B84D
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbhCOOCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231678AbhCOOAE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65AA464F3C;
        Mon, 15 Mar 2021 13:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816785;
        bh=oBaedW3ZVe/rOPk/x+o8rsGxTTvVfmgAc0nw/CuGuZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ubnHyNR6qqmqfn6tBOSblPAXsDBNOv1WNHr0zdRgWSqlNXZK6/JTfRzhgHWvJl/9
         Wh3rPYQm6V3uwWekPaSUfjtF+lIAUbmFgFvAPZRBbSGAzEKFCVuclzxB+pfiNbEGxE
         8H1IBStNNFR+tJ8K+FL6CLcvwT20eawN1/g7hsKE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Paasch <cpaasch@apple.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 123/306] mptcp: reset last_snd on subflow close
Date:   Mon, 15 Mar 2021 14:53:06 +0100
Message-Id: <20210315135511.830130427@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Florian Westphal <fw@strlen.de>

[ Upstream commit e0be4931f3fee2e04dec4013ea4f27ec2db8556f ]

Send logic caches last active subflow in the msk, so it needs to be
cleared when the cached subflow is closed.

Fixes: d5f49190def61c ("mptcp: allow picking different xmit subflows")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/155
Reported-by: Christoph Paasch <cpaasch@apple.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 3cc7be259396..de89824a2a36 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2110,6 +2110,8 @@ static struct sock *mptcp_subflow_get_retrans(const struct mptcp_sock *msk)
 void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		       struct mptcp_subflow_context *subflow)
 {
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
 	list_del(&subflow->node);
 
 	lock_sock_nested(ssk, SINGLE_DEPTH_NESTING);
@@ -2138,6 +2140,9 @@ void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 	release_sock(ssk);
 
 	sock_put(ssk);
+
+	if (ssk == msk->last_snd)
+		msk->last_snd = NULL;
 }
 
 static unsigned int mptcp_sync_mss(struct sock *sk, u32 pmtu)
-- 
2.30.1




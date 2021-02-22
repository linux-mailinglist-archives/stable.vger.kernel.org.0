Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477713215FF
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbhBVMPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:15:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:44936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230334AbhBVMPL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:15:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED43264F10;
        Mon, 22 Feb 2021 12:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996063;
        bh=3kSREwTnBCR5ivjM0Wwb+NnC86pufTtuP3hHwsGQP8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H3kyQ6yM21yWyWuBwFTyw/1uPTqIcfkQedAtapFkSTQtmn9+ckiB3S4j1GTwxoCpc
         ifn+ToqKxP9NAzLKm7O13/4vmun8XwzRyyy3dQ4927QqVgmrNyw8Osep3w2Zk39sYS
         mtLr4CyI5xoc+0uxTULL9z4uvOp5YrAtVesprvUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 08/29] mptcp: skip to next candidate if subflow has unacked data
Date:   Mon, 22 Feb 2021 13:13:02 +0100
Message-Id: <20210222121021.519452639@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 860975c6f80adae9d2c7654bde04a99dd28bc94f ]

In case a subflow path is blocked, MPTCP-level retransmit may not take
place anymore because such subflow is likely to have unacked data left
in its write queue.

Ignore subflows that have experienced loss and test next candidate.

Fixes: 3b1d6210a95773691 ("mptcp: implement and use MPTCP-level retransmission")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 967ce9ccfc0da..f56b2e331bb6b 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1648,8 +1648,11 @@ static struct sock *mptcp_subflow_get_retrans(const struct mptcp_sock *msk)
 			continue;
 
 		/* still data outstanding at TCP level?  Don't retransmit. */
-		if (!tcp_write_queue_empty(ssk))
+		if (!tcp_write_queue_empty(ssk)) {
+			if (inet_csk(ssk)->icsk_ca_state >= TCP_CA_Loss)
+				continue;
 			return NULL;
+		}
 
 		if (subflow->backup) {
 			if (!backup)
-- 
2.27.0




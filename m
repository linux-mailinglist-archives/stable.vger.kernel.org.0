Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC513D61A2
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233703AbhGZPc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232674AbhGZPae (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:30:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 799B86056B;
        Mon, 26 Jul 2021 16:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315863;
        bh=2p94NubKZmHIQ9OVh6YvzN6MTXQURl7Oq16jgQa2W4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s81PEqu2Y3f6t6E0Af90hKYuj7GCquuLLnZEa45T6mfw4gtCMt7QQ2BglzW4/UWAU
         6p5EH1dbDPt9hVa3EFDdT9mVMRdBbNG0fT/uPmoKggwi3HmGvhYBt48ekU42OKA3i6
         Lv7Of/osOdYHpZdtbiXEmEBU60uACtdWiwjBF7UY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 096/223] sctp: trim optlen when its a huge value in sctp_setsockopt
Date:   Mon, 26 Jul 2021 17:38:08 +0200
Message-Id: <20210726153849.396302871@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 2f3fdd8d4805015fa964807e1c7f3d88f31bd389 ]

After commit ca84bd058dae ("sctp: copy the optval from user space in
sctp_setsockopt"), it does memory allocation in sctp_setsockopt with
the optlen, and it would fail the allocation and return error if the
optlen from user space is a huge value.

This breaks some sockopts, like SCTP_HMAC_IDENT, SCTP_RESET_STREAMS and
SCTP_AUTH_KEY, as when processing these sockopts before, optlen would
be trimmed to a biggest value it needs when optlen is a huge value,
instead of failing the allocation and returning error.

This patch is to fix the allocation failure when it's a huge optlen from
user space by trimming it to the biggest size sctp sockopt may need when
necessary, and this biggest size is from sctp_setsockopt_reset_streams()
for SCTP_RESET_STREAMS, which is bigger than those for SCTP_HMAC_IDENT
and SCTP_AUTH_KEY.

Fixes: ca84bd058dae ("sctp: copy the optval from user space in sctp_setsockopt")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/socket.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index a79d193ff872..dbd074f4d450 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4521,6 +4521,10 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	}
 
 	if (optlen > 0) {
+		/* Trim it to the biggest size sctp sockopt may need if necessary */
+		optlen = min_t(unsigned int, optlen,
+			       PAGE_ALIGN(USHRT_MAX +
+					  sizeof(__u16) * sizeof(struct sctp_reset_streams)));
 		kopt = memdup_sockptr(optval, optlen);
 		if (IS_ERR(kopt))
 			return PTR_ERR(kopt);
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A0F3D60DB
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236905AbhGZPZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:25:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237699AbhGZPX7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:23:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B40BC60F38;
        Mon, 26 Jul 2021 16:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315468;
        bh=YivcaPsQI6HankPicUPjChr6cFmEqlsylh88FIfEJFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AWUdhyn6I701Yqex0tVCkgFm/Ifl39sm7+QLJeqmR42zGnWp/rmf2wkFoQSOpkfN3
         5z8ChJmHIA3fYZQOCBuWYiuq169t2vi7HXp/Kmvlfaugx3hE+5WuNyKme0lH96lov1
         g8zqMRaUQuXhwbyfLhmTISiI9mVobSw2TqvTQA6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/167] sctp: trim optlen when its a huge value in sctp_setsockopt
Date:   Mon, 26 Jul 2021 17:38:26 +0200
Message-Id: <20210726153841.842563570@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
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
index 3ac6b21ecf2c..e872bc50bbe6 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4471,6 +4471,10 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
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




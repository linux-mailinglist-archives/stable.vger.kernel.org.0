Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04AA0499B1A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574530AbiAXVto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456759AbiAXVj5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:39:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F926C07E303;
        Mon, 24 Jan 2022 12:27:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D49C61383;
        Mon, 24 Jan 2022 20:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB9CC340E5;
        Mon, 24 Jan 2022 20:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056040;
        bh=O2Ysi3QOPVS30w94JiKKVKbDFHliCexu7E4GF6K1WiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jrX0rqVRKUrGy2pCj6AGFzcKGvCjjXPWaI1dK+PzCrk6+pQ/ZSRA9ohCUGzfVjdMl
         z0h+6tnH6QXsFIma8orthHClO25b1UhiNr8Q5PI59AzRHju8aObQ54Ge7DlNnSwOkL
         LC6l/tcA0ioEo3+y1r91uzEMJTGtKUtlB5dIZPyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Geliang Tang <geliang.tang@suse.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 350/846] mptcp: fix a DSS option writing error
Date:   Mon, 24 Jan 2022 19:37:47 +0100
Message-Id: <20220124184113.027769675@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

[ Upstream commit 110b6d1fe98fd7af9893992459b651594d789293 ]

'ptr += 1;' was omitted in the original code.

If the DSS is the last option -- which is what we have most of the
time -- that's not an issue. But it is if we need to send something else
after like a RM_ADDR or an MP_PRIO.

Fixes: 1bff1e43a30e ("mptcp: optimize out option generation")
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index f69a1cadb13fc..e515ba9ccb5d8 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1321,6 +1321,7 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 				put_unaligned_be32(mpext->data_len << 16 |
 						   TCPOPT_NOP << 8 | TCPOPT_NOP, ptr);
 			}
+			ptr += 1;
 		}
 	} else if ((OPTION_MPTCP_MPC_SYN | OPTION_MPTCP_MPC_SYNACK |
 		    OPTION_MPTCP_MPC_ACK) & opts->suboptions) {
-- 
2.34.1




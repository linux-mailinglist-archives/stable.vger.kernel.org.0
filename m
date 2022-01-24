Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE8349A06A
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1843913AbiAXXG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:06:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1842496AbiAXXB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:01:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4305FC0F0559;
        Mon, 24 Jan 2022 13:14:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C75036141C;
        Mon, 24 Jan 2022 21:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF29C340E5;
        Mon, 24 Jan 2022 21:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058841;
        bh=ZoNkKVhcKuiwDIg6kQ1SLQk1hXz5ho2UjRj/10QBW00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UqD5U5SF5HCnr1yPnLOfJlqwiIc3fgeNJEWktTmpZDmOk8OdwL+DD7+PNEdK54avi
         sr7Fx5qWjndk712ufLY4NJ14KzN7O06SEKbJfKYjT8PApvuukcecAYv3tz+AImaH/v
         8T6f14t0UDSZX4uL3zrCapxPT7RDHoX+0ypL+sho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Geliang Tang <geliang.tang@suse.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0420/1039] mptcp: fix a DSS option writing error
Date:   Mon, 24 Jan 2022 19:36:49 +0100
Message-Id: <20220124184139.422102200@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 96c6efdd48bcc..6661b1d6520f1 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1319,6 +1319,7 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 				put_unaligned_be32(mpext->data_len << 16 |
 						   TCPOPT_NOP << 8 | TCPOPT_NOP, ptr);
 			}
+			ptr += 1;
 		}
 	} else if (OPTIONS_MPTCP_MPC & opts->suboptions) {
 		u8 len, flag = MPTCP_CAP_HMAC_SHA256;
-- 
2.34.1




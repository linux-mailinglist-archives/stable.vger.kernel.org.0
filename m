Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D25C4A42D6
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349579AbiAaLO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:14:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46080 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376288AbiAaLMY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:12:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B91960E76;
        Mon, 31 Jan 2022 11:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A69C340EE;
        Mon, 31 Jan 2022 11:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627543;
        bh=kF8zBOnPG19rVxt1/WRDHi/NZ4XcLWzX6Qw/i0Lye+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cGSZxiorZQn3A0P1j6jERULXBbcFH92ATdVlsl6snhACi/xtZWpySnyy1UfInvV9t
         e6pwY9sZGNYNzcInvtOnnc2DULWFjo/C2Rt61JfhoN5EDv+In4D+xhpSs2/9quDbQF
         YGqdpiDBcfnXjGZRGfhOMQHjTHAAm8rQYvG6TWG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Geliang Tang <geliang.tang@suse.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 118/171] mptcp: fix removing ids bitmap setting
Date:   Mon, 31 Jan 2022 11:56:23 +0100
Message-Id: <20220131105234.037190388@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

[ Upstream commit a4c0214fbee97c46e3f41fee37931d66c0fc3cb1 ]

In mptcp_pm_nl_rm_addr_or_subflow(), the bit of rm_list->ids[i] in the
id_avail_bitmap should be set, not rm_list->ids[1]. This patch fixed it.

Fixes: 86e39e04482b ("mptcp: keep track of local endpoint still available for each msk")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 7f11eb3e35137..84e6b55375e1d 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -781,7 +781,7 @@ static void mptcp_pm_nl_rm_addr_or_subflow(struct mptcp_sock *msk,
 			msk->pm.subflows--;
 			__MPTCP_INC_STATS(sock_net(sk), rm_type);
 		}
-		__set_bit(rm_list->ids[1], msk->pm.id_avail_bitmap);
+		__set_bit(rm_list->ids[i], msk->pm.id_avail_bitmap);
 		if (!removed)
 			continue;
 
-- 
2.34.1




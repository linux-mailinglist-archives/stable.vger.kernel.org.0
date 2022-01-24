Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F332F49938D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385884AbiAXUem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:34:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33540 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383516AbiAXU1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:27:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2831B811FB;
        Mon, 24 Jan 2022 20:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9770C340E5;
        Mon, 24 Jan 2022 20:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056037;
        bh=hk/eP+4vdEUObKkcLaViDp0mx6G5Xhs2R8ms/YVjohw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/Rm6Ai2tD7Z5g8uttA4Wtr952JiYenWDtgDmvU4iesIwNrX5wo4eV8zLAmWGWaVN
         FAjmlYcQojlq6OtOjxkiaAZeCAtRcgiSriTPhzPyXsU1OoAByklzZdFrQilCa3sSDZ
         Ecf+7Ige6kSuZ7xrcD2Y8PafQ3TGxB6z5nNcs7dM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Geliang Tang <geliang.tang@suse.com>
Subject: [PATCH 5.15 349/846] mptcp: fix opt size when sending DSS + MP_FAIL
Date:   Mon, 24 Jan 2022 19:37:46 +0100
Message-Id: <20220124184112.995825032@linuxfoundation.org>
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

From: Matthieu Baerts <matthieu.baerts@tessares.net>

[ Upstream commit 04fac2cae9422a3401c172571afbcfdd58fa5c7e ]

When these two options had to be sent -- which is not common -- the DSS
size was not being taken into account in the remaining size.

Additionally in this situation, the reported size was only the one of
the MP_FAIL which can cause issue if at the end, we need to write more
in the TCP options than previously said.

Here we use a dedicated variable for MP_FAIL size to keep the
WARN_ON_ONCE() just after.

Fixes: c25aeb4e0953 ("mptcp: MP_FAIL suboption sending")
Acked-and-tested-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 0966855a7c251..f69a1cadb13fc 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -823,10 +823,13 @@ bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 	if (mptcp_established_options_mp(sk, skb, snd_data_fin, &opt_size, remaining, opts))
 		ret = true;
 	else if (mptcp_established_options_dss(sk, skb, snd_data_fin, &opt_size, remaining, opts)) {
+		unsigned int mp_fail_size;
+
 		ret = true;
-		if (mptcp_established_options_mp_fail(sk, &opt_size, remaining, opts)) {
-			*size += opt_size;
-			remaining -= opt_size;
+		if (mptcp_established_options_mp_fail(sk, &mp_fail_size,
+						      remaining - opt_size, opts)) {
+			*size += opt_size + mp_fail_size;
+			remaining -= opt_size - mp_fail_size;
 			return true;
 		}
 	}
-- 
2.34.1




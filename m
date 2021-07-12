Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700D43C5444
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348250AbhGLH5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:57:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347802AbhGLHxv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:53:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B81D561221;
        Mon, 12 Jul 2021 07:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076263;
        bh=E/26E4Xx5Ka6U8+AwjqgekxQQ5GZ7ET6+IFZaskNq6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wQRzs3ql5wcemeLkawQiGExsucPP3ZRFS7gRzBT12sFwjczifR8sf8AASEptY2CHI
         2KhhEC1nF8DaKrRaUpGVZv1ZKqZ4WHE3zoKsN/4jCU9Z6G2FVmfAI9eKFixFklCncj
         AtBc+CanXEyiSgxd18I3CXD0/nCUdH90Z5hMoPFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 525/800] mptcp: fix 32 bit DSN expansion
Date:   Mon, 12 Jul 2021 08:09:08 +0200
Message-Id: <20210712061023.119091696@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 5957a8901db44c03540505ccedd95031c21ef2f2 ]

The current implementation of 32 bit DSN expansion is buggy.
After the previous patch, we can simply reuse the newly
introduced helper to do the expansion safely.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/120
Fixes: 648ef4b88673 ("mptcp: Implement MPTCP receive path")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/subflow.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 3a396451d628..f5bb3a0e9975 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -775,15 +775,6 @@ enum mapping_status {
 	MAPPING_DUMMY
 };
 
-static u64 expand_seq(u64 old_seq, u16 old_data_len, u64 seq)
-{
-	if ((u32)seq == (u32)old_seq)
-		return old_seq;
-
-	/* Assume map covers data not mapped yet. */
-	return seq | ((old_seq + old_data_len + 1) & GENMASK_ULL(63, 32));
-}
-
 static void dbg_bad_map(struct mptcp_subflow_context *subflow, u32 ssn)
 {
 	pr_debug("Bad mapping: ssn=%d map_seq=%d map_data_len=%d",
@@ -907,13 +898,7 @@ static enum mapping_status get_mapping_status(struct sock *ssk,
 		data_len--;
 	}
 
-	if (!mpext->dsn64) {
-		map_seq = expand_seq(subflow->map_seq, subflow->map_data_len,
-				     mpext->data_seq);
-		pr_debug("expanded seq=%llu", subflow->map_seq);
-	} else {
-		map_seq = mpext->data_seq;
-	}
+	map_seq = mptcp_expand_seq(READ_ONCE(msk->ack_seq), mpext->data_seq, mpext->dsn64);
 	WRITE_ONCE(mptcp_sk(subflow->conn)->use_64bit_ack, !!mpext->dsn64);
 
 	if (subflow->map_valid) {
-- 
2.30.2




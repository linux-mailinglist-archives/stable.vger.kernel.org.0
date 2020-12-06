Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D402D0473
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbgLFLpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:45:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:46162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725804AbgLFLpq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:45:46 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 14/46] mptcp: fix NULL ptr dereference on bad MPJ
Date:   Sun,  6 Dec 2020 12:17:22 +0100
Message-Id: <20201206111557.147478069@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111556.455533723@linuxfoundation.org>
References: <20201206111556.455533723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit d3ab78858f1451351221061a1c365495df196500 ]

If an msk listener receives an MPJ carrying an invalid token, it
will zero the request socket msk entry. That should later
cause fallback and subflow reset - as per RFC - at
subflow_syn_recv_sock() time due to failing hmac validation.

Since commit 4cf8b7e48a09 ("subflow: introduce and use
mptcp_can_accept_new_subflow()"), we unconditionally dereference
- in mptcp_can_accept_new_subflow - the subflow request msk
before performing hmac validation. In the above scenario we
hit a NULL ptr dereference.

Address the issue doing the hmac validation earlier.

Fixes: 4cf8b7e48a09 ("subflow: introduce and use mptcp_can_accept_new_subflow()")
Tested-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Link: https://lore.kernel.org/r/03b2cfa3ac80d8fc18272edc6442a9ddf0b1e34e.1606400227.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -542,9 +542,8 @@ create_msk:
 			fallback = true;
 	} else if (subflow_req->mp_join) {
 		mptcp_get_options(skb, &mp_opt);
-		if (!mp_opt.mp_join ||
-		    !mptcp_can_accept_new_subflow(subflow_req->msk) ||
-		    !subflow_hmac_valid(req, &mp_opt)) {
+		if (!mp_opt.mp_join || !subflow_hmac_valid(req, &mp_opt) ||
+		    !mptcp_can_accept_new_subflow(subflow_req->msk)) {
 			SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKMAC);
 			fallback = true;
 		}



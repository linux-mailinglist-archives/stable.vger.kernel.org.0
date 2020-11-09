Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2DB22ABB3A
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387611AbgKINZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:25:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:44490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387580AbgKINRT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:17:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A6AB2083B;
        Mon,  9 Nov 2020 13:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927838;
        bh=MVatacAilhO+2Bntap7TE5nHbElPRtVz6s8j24F9vdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mqmzzfXs+RFcGwV3AK90EL30x4tWpuJmAQXDSbCucN+zbd3sN6HJqwoAVSxOtWxJP
         VSUw3efw0PDd/kZWaU9KqIQ1lmHJduXRS2FE1ojciyGNmSvr6Rqf/zdvfNLG7xqZaQ
         fTTkCaH73plw1lboyuj7bpU8Rfypj18dPUgnWLrE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 039/133] mptcp: token: fix unititialized variable
Date:   Mon,  9 Nov 2020 13:55:01 +0100
Message-Id: <20201109125032.591316307@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit e16b874ee87aa70cd0a7145346ff5f41349b514c ]

gcc complains about use of uninitialized 'num'. Fix it by doing the first
assignment of 'num' when the variable is declared.

Fixes: 96d890daad05 ("mptcp: add msk interations helper")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/49e20da5d467a73414d4294a8bd35e2cb1befd49.1604308087.git.dcaratti@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/token.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -291,7 +291,7 @@ struct mptcp_sock *mptcp_token_iter_next
 {
 	struct mptcp_sock *ret = NULL;
 	struct hlist_nulls_node *pos;
-	int slot, num;
+	int slot, num = 0;
 
 	for (slot = *s_slot; slot <= token_mask; *s_num = 0, slot++) {
 		struct token_bucket *bucket = &token_hash[slot];



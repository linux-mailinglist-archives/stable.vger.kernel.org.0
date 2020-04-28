Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37671BCBCD
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 21:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbgD1S7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729189AbgD1S2Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:28:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DE5220BED;
        Tue, 28 Apr 2020 18:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098504;
        bh=cAsobCg9jwmouMkaU0/F+93bEXvxaMeqh2tFcVn6pKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k9mrJk6pGq7IPz6VeCI/Rt+kH858nHTOHnP5H93rbMf+NlvmMlkLer9U5IDas3HAE
         NjbiQ+hAE1IyrRZz6PrW7sk83jAWJ0JS0JaA0fy4mJblKhl54fRQdExlFJdf3R/AxR
         v3RuVaF+Gx2XOuzv9QcR4HZq7pSRdxcpd+tMMThM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 062/167] tipc: Fix potential tipc_aead refcnt leak in tipc_crypto_rcv
Date:   Tue, 28 Apr 2020 20:23:58 +0200
Message-Id: <20200428182232.791482602@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit 441870ee4240cf67b5d3ab8e16216a9ff42eb5d6 ]

tipc_crypto_rcv() invokes tipc_aead_get(), which returns a reference of
the tipc_aead object to "aead" with increased refcnt.

When tipc_crypto_rcv() returns, the original local reference of "aead"
becomes invalid, so the refcount should be decreased to keep refcount
balanced.

The issue happens in one error path of tipc_crypto_rcv(). When TIPC
message decryption status is EINPROGRESS or EBUSY, the function forgets
to decrease the refcnt increased by tipc_aead_get() and causes a refcnt
leak.

Fix this issue by calling tipc_aead_put() on the error path when TIPC
message decryption status is EINPROGRESS or EBUSY.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/crypto.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -1712,6 +1712,7 @@ exit:
 	case -EBUSY:
 		this_cpu_inc(stats->stat[STAT_ASYNC]);
 		*skb = NULL;
+		tipc_aead_put(aead);
 		return rc;
 	default:
 		this_cpu_inc(stats->stat[STAT_NOK]);



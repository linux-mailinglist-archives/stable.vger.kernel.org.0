Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7325469DD3
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359507AbhLFPdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:33:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34442 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348184AbhLFP2h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:28:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA020B8101B;
        Mon,  6 Dec 2021 15:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2664EC34901;
        Mon,  6 Dec 2021 15:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804305;
        bh=T0E7NFSIo4RFxI1+ieCaKPXXg6lhANU2MhXPz9uiX2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ekrv9QFdIHezLFjxE8gOU2E0/i0gW1PgZZaLLn9ayP+yrWYUXnf+QxRwzl/SY70Ro
         z/QDAbdOWucS4lTR69PNBj1avHoCxSWISLQBcSC7WEfyY3MMRh4/aexrhG9iT1scAq
         aA9OO49k6JLv199xSfeTVCkoIBAdS1Mdk5tdkaag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 098/207] wireguard: ratelimiter: use kvcalloc() instead of kvzalloc()
Date:   Mon,  6 Dec 2021 15:55:52 +0100
Message-Id: <20211206145613.630872008@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavoars@kernel.org>

commit 4e3fd721710553832460c179c2ee5ce67ef7f1e0 upstream.

Use 2-factor argument form kvcalloc() instead of kvzalloc().

Link: https://github.com/KSPP/linux/issues/162
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
[Jason: Gustavo's link above is for KSPP, but this isn't actually a
 security fix, as table_size is bounded to 8192 anyway, and gcc realizes
 this, so the codegen comes out to be about the same.]
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireguard/ratelimiter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireguard/ratelimiter.c
+++ b/drivers/net/wireguard/ratelimiter.c
@@ -176,12 +176,12 @@ int wg_ratelimiter_init(void)
 			(1U << 14) / sizeof(struct hlist_head)));
 	max_entries = table_size * 8;
 
-	table_v4 = kvzalloc(table_size * sizeof(*table_v4), GFP_KERNEL);
+	table_v4 = kvcalloc(table_size, sizeof(*table_v4), GFP_KERNEL);
 	if (unlikely(!table_v4))
 		goto err_kmemcache;
 
 #if IS_ENABLED(CONFIG_IPV6)
-	table_v6 = kvzalloc(table_size * sizeof(*table_v6), GFP_KERNEL);
+	table_v6 = kvcalloc(table_size, sizeof(*table_v6), GFP_KERNEL);
 	if (unlikely(!table_v6)) {
 		kvfree(table_v4);
 		goto err_kmemcache;



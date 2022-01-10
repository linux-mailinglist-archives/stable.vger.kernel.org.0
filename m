Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E27648911D
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239502AbiAJH3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:29:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37184 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239497AbiAJH1W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:27:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15B5F611B9;
        Mon, 10 Jan 2022 07:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1622C36AE9;
        Mon, 10 Jan 2022 07:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799641;
        bh=oW7SX6sqfjaQ3jE8DPtXe+hyra05TsoG2/m6gHOLZjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iP1j7RxoIX74QFZJjDHLzTifF3Sc6PL2jk65+Q9CZqVhGSjTK+G8DkBd01fZx2bR9
         UJ+z188vqBThYXUWZqbY87iOUnSlhkIhvMXd4XZQbU+wWlLYBH5CQNJHx6+jhc+06O
         zkdcNr1Sy0gDCBC6r5vm703qFs2Up5VqhsYI6lpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, yangxingwu <xingwu.yang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 20/21] net: udp: fix alignment problem in udp4_seq_show()
Date:   Mon, 10 Jan 2022 08:23:21 +0100
Message-Id: <20220110071814.615293887@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071813.967414697@linuxfoundation.org>
References: <20220110071813.967414697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yangxingwu <xingwu.yang@gmail.com>

[ Upstream commit 6c25449e1a32c594d743df8e8258e8ef870b6a77 ]

$ cat /pro/net/udp

before:

  sl  local_address rem_address   st tx_queue rx_queue tr tm->when
26050: 0100007F:0035 00000000:0000 07 00000000:00000000 00:00000000
26320: 0100007F:0143 00000000:0000 07 00000000:00000000 00:00000000
27135: 00000000:8472 00000000:0000 07 00000000:00000000 00:00000000

after:

   sl  local_address rem_address   st tx_queue rx_queue tr tm->when
26050: 0100007F:0035 00000000:0000 07 00000000:00000000 00:00000000
26320: 0100007F:0143 00000000:0000 07 00000000:00000000 00:00000000
27135: 00000000:8472 00000000:0000 07 00000000:00000000 00:00000000

Signed-off-by: yangxingwu <xingwu.yang@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index fce32f3e42b54..b7acb6afdbce6 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2845,7 +2845,7 @@ int udp4_seq_show(struct seq_file *seq, void *v)
 {
 	seq_setwidth(seq, 127);
 	if (v == SEQ_START_TOKEN)
-		seq_puts(seq, "  sl  local_address rem_address   st tx_queue "
+		seq_puts(seq, "   sl  local_address rem_address   st tx_queue "
 			   "rx_queue tr tm->when retrnsmt   uid  timeout "
 			   "inode ref pointer drops");
 	else {
-- 
2.34.1




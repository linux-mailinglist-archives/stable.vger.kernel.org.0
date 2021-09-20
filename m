Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B76411B8B
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244299AbhITRAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:00:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344054AbhITQ5x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:57:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02FFA61213;
        Mon, 20 Sep 2021 16:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156704;
        bh=561kO8v0wGDDZNoQK6dWoOnmZd0EodYRbwi5YlUICfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=igGRlqFZ2WtvUKiFzGABHMOBwBQyhJfsPUUU5F/M6eFsTzs3T4ZQOad/DqVKG/h4j
         ln4rdT897KOUMNccEUeoiFcqfriFR8I2x6my5O85V2M3ya6m2piiRRhjxatDpr4vAh
         2C1l/bfNYgCV3GJoiLGxONss4hCwZllE0qIwiMh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 048/175] m68k: emu: Fix invalid free in nfeth_cleanup()
Date:   Mon, 20 Sep 2021 18:41:37 +0200
Message-Id: <20210920163919.626930980@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 761608f5cf70e8876c2f0e39ca54b516bdcb7c12 ]

In the for loop all nfeth_dev array members should be freed, not only
the first one.  Freeing only the first array member can cause
double-free bugs and memory leaks.

Fixes: 9cd7b148312f ("m68k/atari: ARAnyM - Add support for network access")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Link: https://lore.kernel.org/r/20210705204727.10743-1-paskripkin@gmail.com
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/emu/nfeth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/emu/nfeth.c b/arch/m68k/emu/nfeth.c
index a0985fd088d1..7d695fc7a2d0 100644
--- a/arch/m68k/emu/nfeth.c
+++ b/arch/m68k/emu/nfeth.c
@@ -260,8 +260,8 @@ static void __exit nfeth_cleanup(void)
 
 	for (i = 0; i < MAX_UNIT; i++) {
 		if (nfeth_dev[i]) {
-			unregister_netdev(nfeth_dev[0]);
-			free_netdev(nfeth_dev[0]);
+			unregister_netdev(nfeth_dev[i]);
+			free_netdev(nfeth_dev[i]);
 		}
 	}
 	free_irq(nfEtherIRQ, nfeth_interrupt);
-- 
2.30.2




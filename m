Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08034411D05
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345986AbhITRPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:15:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347365AbhITRNs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:13:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 002CB619F5;
        Mon, 20 Sep 2021 16:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157081;
        bh=l7385ZFdomGiFMyukTPaBhMpcELxzfHOSJdQJlm8wPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J0Epk1RRHLZUb4Ir1gWnsZusnpto7DRaCs7som+n0FNDr6jITqNI2NEZHsj8bzahx
         R+86GgSa1xqb2ajXOmB8N7TS12c5HEfEdSUGnR4RZ7qo5Rm1FLPA38JRTx5D7WT/2V
         LIKg+yAhCGgI45sa2MET7PtZpWKBh3Olpzb6l7AU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 045/217] m68k: emu: Fix invalid free in nfeth_cleanup()
Date:   Mon, 20 Sep 2021 18:41:06 +0200
Message-Id: <20210920163926.151994668@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
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
index e45ce4243aaa..76262dc40e79 100644
--- a/arch/m68k/emu/nfeth.c
+++ b/arch/m68k/emu/nfeth.c
@@ -258,8 +258,8 @@ static void __exit nfeth_cleanup(void)
 
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




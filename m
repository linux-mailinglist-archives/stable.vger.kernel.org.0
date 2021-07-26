Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CC63D5F5D
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236857AbhGZPRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:17:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236865AbhGZPPm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7C1C60FEE;
        Mon, 26 Jul 2021 15:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314834;
        bh=kiCwj/eaP/By5s5uuKuSufARKwNtWr/QwUGAT1BSjy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DeFZqRmwsccgGmoZ/lhqef2YCPify6eFn6UscTvEoWQDwpMpkCxyfxBqhhCzmLMH9
         qWiiZGamaQoUmkGwmhlyt4bnI0Lv+UOfOJpabkIUZC6EZTwgmUAN908GmLNgHT9Dg2
         Rb84+ih54NNmjfWgpjHbhgRMzDVyo9X1DoCSvc8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 073/120] s390/bpf: Perform r1 range checking before accessing jit->seen_reg[r1]
Date:   Mon, 26 Jul 2021 17:38:45 +0200
Message-Id: <20210726153834.728280682@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 91091656252f5d6d8c476e0c92776ce9fae7b445 ]

Currently array jit->seen_reg[r1] is being accessed before the range
checking of index r1. The range changing on r1 should be performed
first since it will avoid any potential out-of-range accesses on the
array seen_reg[] and also it is more optimal to perform checks on r1
before fetching data from the array. Fix this by swapping the order
of the checks before the array access.

Fixes: 054623105728 ("s390/bpf: Add s390x eBPF JIT compiler backend")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Ilya Leoshkevich <iii@linux.ibm.com>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Link: https://lore.kernel.org/bpf/20210715125712.24690-1-colin.king@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 2617e426c792..e42354b15e0b 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -113,7 +113,7 @@ static inline void reg_set_seen(struct bpf_jit *jit, u32 b1)
 {
 	u32 r1 = reg2hex[b1];
 
-	if (!jit->seen_reg[r1] && r1 >= 6 && r1 <= 15)
+	if (r1 >= 6 && r1 <= 15 && !jit->seen_reg[r1])
 		jit->seen_reg[r1] = 1;
 }
 
-- 
2.30.2




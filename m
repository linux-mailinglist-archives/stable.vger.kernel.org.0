Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903643D5DBE
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235777AbhGZPD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:03:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235772AbhGZPD3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:03:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7FB660F37;
        Mon, 26 Jul 2021 15:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314237;
        bh=y9nNAFeu4EWk29ChBJOUf/hJlssjVcanevK4L0Mz1+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lgVrluoTepqV5hifpUkcjFs9kYzfrONordRojZTX6tquBCFh+fDksPHmN82bAXaMd
         Y8dt5HH5im3bI1tODZoDmrvhmE8bxUveCaGDQIPVUj7ZDHTm4t9Xj/RU96J3tmqsnO
         lWP7ISA1WC/SRrI1ugMzrTUvrQtlGFNSo0AwHAJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 35/60] s390/bpf: Perform r1 range checking before accessing jit->seen_reg[r1]
Date:   Mon, 26 Jul 2021 17:38:49 +0200
Message-Id: <20210726153825.972077832@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153824.868160836@linuxfoundation.org>
References: <20210726153824.868160836@linuxfoundation.org>
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
index 9b15a1dc6628..ed58ebab96cd 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -116,7 +116,7 @@ static inline void reg_set_seen(struct bpf_jit *jit, u32 b1)
 {
 	u32 r1 = reg2hex[b1];
 
-	if (!jit->seen_reg[r1] && r1 >= 6 && r1 <= 15)
+	if (r1 >= 6 && r1 <= 15 && !jit->seen_reg[r1])
 		jit->seen_reg[r1] = 1;
 }
 
-- 
2.30.2




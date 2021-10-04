Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A0D420FEC
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237807AbhJDNjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:39:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237873AbhJDNhE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:37:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AD256120F;
        Mon,  4 Oct 2021 13:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353402;
        bh=a6ZFMMWe7gwV5i/FMaeYi4FvW1cQbUUCRxS8J9SJy34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HVV2FczhEg1G3qh+y3+v7CJHyhCiXbQyW+yPcRvl6FW7Q9Vux9C0/hRQhntJWYOYA
         YfGz7PRhZV2EjJuRT1n52WS+RErQS+SuEi9IB1ackZ3Wu/Yp+1DchMWz9moUcRjd8E
         GM6frytai0Z6CdLNZ2KCb60Q+8tUz9VdbA8ZH8GE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 114/172] bpf: Exempt CAP_BPF from checks against bpf_jit_limit
Date:   Mon,  4 Oct 2021 14:52:44 +0200
Message-Id: <20211004125048.661492042@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenz Bauer <lmb@cloudflare.com>

[ Upstream commit 8a98ae12fbefdb583a7696de719a1d57e5e940a2 ]

When introducing CAP_BPF, bpf_jit_charge_modmem() was not changed to treat
programs with CAP_BPF as privileged for the purpose of JIT memory allocation.
This means that a program without CAP_BPF can block a program with CAP_BPF
from loading a program.

Fix this by checking bpf_capable() in bpf_jit_charge_modmem().

Fixes: 2c78ee898d8f ("bpf: Implement CAP_BPF")
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20210922111153.19843-1-lmb@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 0a28a8095d3e..c019611fbc8f 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -827,7 +827,7 @@ int bpf_jit_charge_modmem(u32 pages)
 {
 	if (atomic_long_add_return(pages, &bpf_jit_current) >
 	    (bpf_jit_limit >> PAGE_SHIFT)) {
-		if (!capable(CAP_SYS_ADMIN)) {
+		if (!bpf_capable()) {
 			atomic_long_sub(pages, &bpf_jit_current);
 			return -EPERM;
 		}
-- 
2.33.0




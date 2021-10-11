Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F3D428FA1
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238061AbhJKOAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:00:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238486AbhJKN6o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:58:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73FF46108F;
        Mon, 11 Oct 2021 13:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960524;
        bh=99MS2tfrh/YSqqQcksI2D7npQ3n1kaiMY9/XiGxorng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iOuR3oEh2QcR7xugs3gp+gRBZenqOC6Fwx+AyAQwfr1jlZGPL/MVl2ITZinkxzgqN
         TFq+q9Imxuc7y2riM97DTPXcIKox3VePsJjedb8f4ahabNC0dHvfcR/TjZzF1an4AT
         exxdCZcIW+jPsOz7blXgkTDUupmUUgyhvive/C3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 71/83] bpf, s390: Fix potential memory leak about jit_data
Date:   Mon, 11 Oct 2021 15:46:31 +0200
Message-Id: <20211011134510.830016431@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 686cb8b9f6b46787f035afe8fbd132a74e6b1bdd ]

Make sure to free jit_data through kfree() in the error path.

Fixes: 1c8f9b91c456 ("bpf: s390: add JIT support for multi-function programs")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 8d9047d2d1e1..cd0cbdafedbd 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -1775,7 +1775,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 	jit.addrs = kvcalloc(fp->len + 1, sizeof(*jit.addrs), GFP_KERNEL);
 	if (jit.addrs == NULL) {
 		fp = orig_fp;
-		goto out;
+		goto free_addrs;
 	}
 	/*
 	 * Three initial passes:
-- 
2.33.0




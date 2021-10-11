Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85AD3428EED
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237527AbhJKNxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:53:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237546AbhJKNv4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:51:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AD37610C7;
        Mon, 11 Oct 2021 13:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960196;
        bh=SA5zmA6InVNzguv6c0s+gu7/z8QIRs9ky1BnBicRA48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AGhG8sjOvtjzuCu2OoKpJsvW7kjVCJAjvjqt+07w4Z9e1iBR3KVDDTO3Gr3W0buIv
         943hchGILvD/P32FBET+HTONmPQrc9IwzhfLSiRzfpBYvvI/4jV/1YfoRVoFwA5fPT
         6Js97wFpR1gigc4QL+OZ3jK/swpWYQaRo4GkAAAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 47/52] bpf, s390: Fix potential memory leak about jit_data
Date:   Mon, 11 Oct 2021 15:46:16 +0200
Message-Id: <20211011134505.342187054@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134503.715740503@linuxfoundation.org>
References: <20211011134503.715740503@linuxfoundation.org>
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
index 2d2996627629..f63e4cb6c9b3 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -1385,7 +1385,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
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




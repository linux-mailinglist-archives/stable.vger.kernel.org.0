Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 584512F2B1
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730640AbfE3EYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:24:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730024AbfE3DOv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:14:51 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25AC92458A;
        Thu, 30 May 2019 03:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186091;
        bh=iz/wcUtn3HwNE5WJyUgZwR7jVEuVPxyiJJgdZNhCOAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vts2BPJ8XUtmNJoTzmIqCqyijEBdCM/YeITKDKzaPCdj5vdMAtNtWyrh6/prSblKV
         8cw1hkhThMOCeOCi0/dy5009f0Pv8412+yWmb7ADYifPl8hp1J7rzYnnoMLtWeILca
         ZDwHeHQW6yRU7MLfu7OUjHZ/uhcnvPntagQ6YZWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 222/346] selftests/bpf: ksym_search wont check symbols exists
Date:   Wed, 29 May 2019 20:04:55 -0700
Message-Id: <20190530030552.324126239@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0979ff7992fb6f4eb837995b12f4071dcafebd2d ]

Currently, ksym_search located at trace_helpers won't check symbols are
existing or not.

In ksym_search, when symbol is not found, it will return &syms[0](_stext).
But when the kernel symbols are not loaded, it will return NULL, which is
not a desired action.

This commit will add verification logic whether symbols are loaded prior
to the symbol search.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/trace_helpers.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/bpf/trace_helpers.c b/tools/testing/selftests/bpf/trace_helpers.c
index 4cdb63bf0521d..9a9fc6c9b70b5 100644
--- a/tools/testing/selftests/bpf/trace_helpers.c
+++ b/tools/testing/selftests/bpf/trace_helpers.c
@@ -52,6 +52,10 @@ struct ksym *ksym_search(long key)
 	int start = 0, end = sym_cnt;
 	int result;
 
+	/* kallsyms not loaded. return NULL */
+	if (sym_cnt <= 0)
+		return NULL;
+
 	while (start < end) {
 		size_t mid = start + (end - start) / 2;
 
-- 
2.20.1




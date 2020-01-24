Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5BA4147A72
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730614AbgAXJdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:33:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:60188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730652AbgAXJdn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:33:43 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60BEF214DB;
        Fri, 24 Jan 2020 09:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858422;
        bh=9wS7KhT7C1kZdFrhvuZqSsUzl4Qrz0XEJzPEAAHIGcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XGtei1Jwly9LHyT29ojaKH31R5ViLEPiSOvYiIICB0fyGGMKEYlD7OQVeooLDA37u
         RoReaOxuJuJrP3P3SPx4tP73qgxxgbhYTVp+G+918vLSSFduGk9Dm5yIBhrsjcyfQc
         jkd7yOzZdfBTlwU1YABsTya6PRkfgAQA1xsFQ2Vo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.4 006/102] libbpf: Make btf__resolve_size logic always check size error condition
Date:   Fri, 24 Jan 2020 10:30:07 +0100
Message-Id: <20200124092807.027215215@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

commit 994021a7e08477f7e51285920aac99fc967fae8a upstream.

Perform size check always in btf__resolve_size. Makes the logic a bit more
robust against corrupted BTF and silences LGTM/Coverity complaining about
always true (size < 0) check.

Fixes: 69eaab04c675 ("btf: extract BTF type size calculation")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20191107020855.3834758-5-andriin@fb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/lib/bpf/btf.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -269,10 +269,9 @@ __s64 btf__resolve_size(const struct btf
 		t = btf__type_by_id(btf, type_id);
 	}
 
+done:
 	if (size < 0)
 		return -EINVAL;
-
-done:
 	if (nelems && size > UINT32_MAX / nelems)
 		return -E2BIG;
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E24ED106E59
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730961AbfKVLEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:04:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:59710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731579AbfKVLEh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:04:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 812BC20840;
        Fri, 22 Nov 2019 11:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420677;
        bh=2mZNh7vjMLJ8VzjcNt4mAP3gxaWYiCtdp11s1HXRELc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z4KbDFC6YuuIS9TPRRYYPTcvf7ChlrkfW3D0MG4tm0WzhwnJeTURykEmD8Vf2xIRw
         DHJ6VS8P3N+YRXGTR7YVhYeFoXTIDCdKrpjRrhtl9hfv3YJSBrtxOPVv5gqQ6vB+xP
         15dydPuzbxKfZihscMfMsHm8LrGct2CDrBtFHL1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wang6495@umn.edu>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 188/220] bpf: btf: Fix a missing check bug
Date:   Fri, 22 Nov 2019 11:29:13 +0100
Message-Id: <20191122100927.690308335@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wang6495@umn.edu>

[ Upstream commit 8af03d1ae2e154a8be3631e8694b87007e1bdbc2 ]

In btf_parse_hdr(), the length of the btf data header is firstly copied
from the user space to 'hdr_len' and checked to see whether it is larger
than 'btf_data_size'. If yes, an error code EINVAL is returned. Otherwise,
the whole header is copied again from the user space to 'btf->hdr'.
However, after the second copy, there is no check between
'btf->hdr->hdr_len' and 'hdr_len' to confirm that the two copies get the
same value. Given that the btf data is in the user space, a malicious user
can race to change the data between the two copies. By doing so, the user
can provide malicious data to the kernel and cause undefined behavior.

This patch adds a necessary check after the second copy, to make sure
'btf->hdr->hdr_len' has the same value as 'hdr_len'. Otherwise, an error
code EINVAL will be returned.

Signed-off-by: Wenwen Wang <wang6495@umn.edu>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 138f0302692ec..378cef70341c4 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -2114,6 +2114,9 @@ static int btf_parse_hdr(struct btf_verifier_env *env, void __user *btf_data,
 
 	hdr = &btf->hdr;
 
+	if (hdr->hdr_len != hdr_len)
+		return -EINVAL;
+
 	btf_verifier_log_hdr(env, btf_data_size);
 
 	if (hdr->magic != BTF_MAGIC) {
-- 
2.20.1




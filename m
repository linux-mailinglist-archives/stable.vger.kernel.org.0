Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43F98147A6F
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729715AbgAXJdh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:33:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:60038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729045AbgAXJdg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:33:36 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1CE32077C;
        Fri, 24 Jan 2020 09:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858414;
        bh=XMMTOnTR4fkuOQfvrA6iNoVa2kpTSOO505e7+9tIZgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZpDqbSvXU6yqlIZGk+/HfBaBFPts30FC6j1C4LTP7tBnbK6AvVHEHRJz9aQ1S5n4
         JvaatSeIfvH1A6vSjLnvieqKIEd/T8NtcJ0cNiovAI0U6Iic+KKM2iR6T1Kg9bKEfW
         C6sc5rskvFPTW4p662dZUdG9HyJrEzzZLNCoPyfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.4 004/102] libbpf: Fix potential overflow issue
Date:   Fri, 24 Jan 2020 10:30:05 +0100
Message-Id: <20200124092806.729162357@linuxfoundation.org>
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

commit 4ee1135615713387b869dfd099ffdf8656be6784 upstream.

Fix a potential overflow issue found by LGTM analysis, based on Github libbpf
source code.

Fixes: 3d65014146c6 ("bpf: libbpf: Add btf_line_info support to libbpf")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20191107020855.3834758-3-andriin@fb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/lib/bpf/bpf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -189,7 +189,7 @@ static void *
 alloc_zero_tailing_info(const void *orecord, __u32 cnt,
 			__u32 actual_rec_size, __u32 expected_rec_size)
 {
-	__u64 info_len = actual_rec_size * cnt;
+	__u64 info_len = (__u64)actual_rec_size * cnt;
 	void *info, *nrecord;
 	int i;
 



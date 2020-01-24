Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8933E147A78
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbgAXJdk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:33:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:60118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730614AbgAXJdk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:33:40 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB355208C4;
        Fri, 24 Jan 2020 09:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858418;
        bh=IHpNLx7UxbCo5eGTPqgf2++daoQ54Lz2HSOKWAGn7Cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HXwuvio766Bt4m4EFCQPacAj7z7ZYI/PS0hb3+pXhhKr3PRLZ09UiEX4VQm8CUYwX
         XP8NTH+VklvLhjL7t8xu9uUPXG+du9dw8fbSREu2o6qByyIRWUUpjV+63V4P8Psuwa
         CnCYuONDlyjStOzwzzl1rQa3ucNK5N8Zb5VtlmsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.4 005/102] libbpf: Fix another potential overflow issue in bpf_prog_linfo
Date:   Fri, 24 Jan 2020 10:30:06 +0100
Message-Id: <20200124092806.874169156@linuxfoundation.org>
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

commit dd3ab126379ec040b3edab8559f9c72de6ef9d29 upstream.

Fix few issues found by Coverity and LGTM.

Fixes: b053b439b72a ("bpf: libbpf: bpftool: Print bpf_line_info during prog dump")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20191107020855.3834758-4-andriin@fb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/lib/bpf/bpf_prog_linfo.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/tools/lib/bpf/bpf_prog_linfo.c
+++ b/tools/lib/bpf/bpf_prog_linfo.c
@@ -101,6 +101,7 @@ struct bpf_prog_linfo *bpf_prog_linfo__n
 {
 	struct bpf_prog_linfo *prog_linfo;
 	__u32 nr_linfo, nr_jited_func;
+	__u64 data_sz;
 
 	nr_linfo = info->nr_line_info;
 
@@ -122,11 +123,11 @@ struct bpf_prog_linfo *bpf_prog_linfo__n
 	/* Copy xlated line_info */
 	prog_linfo->nr_linfo = nr_linfo;
 	prog_linfo->rec_size = info->line_info_rec_size;
-	prog_linfo->raw_linfo = malloc(nr_linfo * prog_linfo->rec_size);
+	data_sz = (__u64)nr_linfo * prog_linfo->rec_size;
+	prog_linfo->raw_linfo = malloc(data_sz);
 	if (!prog_linfo->raw_linfo)
 		goto err_free;
-	memcpy(prog_linfo->raw_linfo, (void *)(long)info->line_info,
-	       nr_linfo * prog_linfo->rec_size);
+	memcpy(prog_linfo->raw_linfo, (void *)(long)info->line_info, data_sz);
 
 	nr_jited_func = info->nr_jited_ksyms;
 	if (!nr_jited_func ||
@@ -142,13 +143,12 @@ struct bpf_prog_linfo *bpf_prog_linfo__n
 	/* Copy jited_line_info */
 	prog_linfo->nr_jited_func = nr_jited_func;
 	prog_linfo->jited_rec_size = info->jited_line_info_rec_size;
-	prog_linfo->raw_jited_linfo = malloc(nr_linfo *
-					     prog_linfo->jited_rec_size);
+	data_sz = (__u64)nr_linfo * prog_linfo->jited_rec_size;
+	prog_linfo->raw_jited_linfo = malloc(data_sz);
 	if (!prog_linfo->raw_jited_linfo)
 		goto err_free;
 	memcpy(prog_linfo->raw_jited_linfo,
-	       (void *)(long)info->jited_line_info,
-	       nr_linfo * prog_linfo->jited_rec_size);
+	       (void *)(long)info->jited_line_info, data_sz);
 
 	/* Number of jited_line_info per jited func */
 	prog_linfo->nr_jited_linfo_per_func = malloc(nr_jited_func *



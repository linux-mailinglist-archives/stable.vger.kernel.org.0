Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C14B51F31F
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbfEOLGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:06:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728008AbfEOLGk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:06:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D37FB2173C;
        Wed, 15 May 2019 11:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918399;
        bh=OhOw0vL38yXmaU2eKj8DUsYjAkBuuhupC6ayetxH300=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q/HcehkXA9xXxLGj1YdA3tK+Npxk8Q0sAKfWeDLvERf+T8NkOn+1oNduLVSGWPREX
         CQbmWCAS0A4Dczz3Y+u6WwpilmUUWCOOPBHHvTjHd1/CtBdAPP1unM8+4yg3zXkj0O
         pMHyAFTFzrJ3eWVW6a1ztDztVy18qGZap6Hqsc5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Zubin Mithra <zsm@chromium.org>
Subject: [PATCH 4.4 073/266] bpf: reject wrong sized filters earlier
Date:   Wed, 15 May 2019 12:53:00 +0200
Message-Id: <20190515090724.904798248@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit f7bd9e36ee4a4ce38e1cddd7effe6c0d9943285b upstream.

Add a bpf_check_basics_ok() and reject filters that are of invalid
size much earlier, so we don't do any useless work such as invoking
bpf_prog_alloc(). Currently, rejection happens in bpf_check_classic()
only, but it's really unnecessarily late and they should be rejected
at earliest point. While at it, also clean up one bpf_prog_size() to
make it consistent with the remaining invocations.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Zubin Mithra <zsm@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/filter.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -742,6 +742,17 @@ static bool chk_code_allowed(u16 code_to
 	return codes[code_to_probe];
 }
 
+static bool bpf_check_basics_ok(const struct sock_filter *filter,
+				unsigned int flen)
+{
+	if (filter == NULL)
+		return false;
+	if (flen == 0 || flen > BPF_MAXINSNS)
+		return false;
+
+	return true;
+}
+
 /**
  *	bpf_check_classic - verify socket filter code
  *	@filter: filter to verify
@@ -762,9 +773,6 @@ static int bpf_check_classic(const struc
 	bool anc_found;
 	int pc;
 
-	if (flen == 0 || flen > BPF_MAXINSNS)
-		return -EINVAL;
-
 	/* Check the filter code now */
 	for (pc = 0; pc < flen; pc++) {
 		const struct sock_filter *ftest = &filter[pc];
@@ -1057,7 +1065,7 @@ int bpf_prog_create(struct bpf_prog **pf
 	struct bpf_prog *fp;
 
 	/* Make sure new filter is there and in the right amounts. */
-	if (fprog->filter == NULL)
+	if (!bpf_check_basics_ok(fprog->filter, fprog->len))
 		return -EINVAL;
 
 	fp = bpf_prog_alloc(bpf_prog_size(fprog->len), 0);
@@ -1104,7 +1112,7 @@ int bpf_prog_create_from_user(struct bpf
 	int err;
 
 	/* Make sure new filter is there and in the right amounts. */
-	if (fprog->filter == NULL)
+	if (!bpf_check_basics_ok(fprog->filter, fprog->len))
 		return -EINVAL;
 
 	fp = bpf_prog_alloc(bpf_prog_size(fprog->len), 0);
@@ -1184,7 +1192,6 @@ int __sk_attach_filter(struct sock_fprog
 		       bool locked)
 {
 	unsigned int fsize = bpf_classic_proglen(fprog);
-	unsigned int bpf_fsize = bpf_prog_size(fprog->len);
 	struct bpf_prog *prog;
 	int err;
 
@@ -1192,10 +1199,10 @@ int __sk_attach_filter(struct sock_fprog
 		return -EPERM;
 
 	/* Make sure new filter is there and in the right amounts. */
-	if (fprog->filter == NULL)
+	if (!bpf_check_basics_ok(fprog->filter, fprog->len))
 		return -EINVAL;
 
-	prog = bpf_prog_alloc(bpf_fsize, 0);
+	prog = bpf_prog_alloc(bpf_prog_size(fprog->len), 0);
 	if (!prog)
 		return -ENOMEM;
 



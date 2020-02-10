Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41A97157781
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730245AbgBJNBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:01:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:42010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729843AbgBJMkz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:55 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E77820661;
        Mon, 10 Feb 2020 12:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338455;
        bh=C1+/RlnZs2Nk2K1ETRDZAwhJ4JS4GCmzt4qAEf3KLtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohnt3e5ABLf30wvrLoJL1BFAWAze1vKU2lFy/88DN9Y8mTvb4dQv99Z3mcPjBex/Y
         NaeMQgQNzfwqZ/CtfA1TjY6/or39rsR4MFUEvXYYvZCqYV1bD6VBTglODhHFOkNnlj
         OdmnimwRA+dV+Vat8ek2QfCxp0HHclbCxd2JePeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, William Smith <williampsmith@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH 5.5 165/367] libbpf: Fix realloc usage in bpf_core_find_cands
Date:   Mon, 10 Feb 2020 04:31:18 -0800
Message-Id: <20200210122440.102702050@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

commit 35b9211c0a2427e8f39e534f442f43804fc8d5ca upstream.

Fix bug requesting invalid size of reallocated array when constructing CO-RE
relocation candidate list. This can cause problems if there are many potential
candidates and a very fine-grained memory allocator bucket sizes are used.

Fixes: ddc7c3042614 ("libbpf: implement BPF CO-RE offset relocation algorithm")
Reported-by: William Smith <williampsmith@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20200124201847.212528-1-andriin@fb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/lib/bpf/libbpf.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2744,7 +2744,9 @@ static struct ids_vec *bpf_core_find_can
 		if (strncmp(local_name, targ_name, local_essent_len) == 0) {
 			pr_debug("[%d] %s: found candidate [%d] %s\n",
 				 local_type_id, local_name, i, targ_name);
-			new_ids = realloc(cand_ids->data, cand_ids->len + 1);
+			new_ids = reallocarray(cand_ids->data,
+					       cand_ids->len + 1,
+					       sizeof(*cand_ids->data));
 			if (!new_ids) {
 				err = -ENOMEM;
 				goto err_out;



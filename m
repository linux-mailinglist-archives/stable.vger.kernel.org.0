Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85EB235BDF3
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238197AbhDLI4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:56:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238399AbhDLIx7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:53:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C0266128C;
        Mon, 12 Apr 2021 08:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217523;
        bh=H2kzuYv/RNMpKBK7LVkPYibt8z4fbr0XGHGoAsO/Ofs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9uS8MK9tEC0ci6+tc99HEq0leL6SEJYkpAV2dV5efFwrdPqErmX6ETPqm4uIAx09
         QQtluj4HE3N4xkKCvk1K1GPd1AcVYWAZYQS9rlHxREh1QETjkcLe4FiFPKU/IYXUIo
         TmmvJo2AgYHHpVsZ1Jj93LprsODv5Kf5ZysHYgwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH 5.10 045/188] bpf: Enforce that struct_ops programs be GPL-only
Date:   Mon, 12 Apr 2021 10:39:19 +0200
Message-Id: <20210412084015.145725629@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

commit 12aa8a9467b354ef893ce0fc5719a4de4949a9fb upstream.

With the introduction of the struct_ops program type, it became possible to
implement kernel functionality in BPF, making it viable to use BPF in place
of a regular kernel module for these particular operations.

Thus far, the only user of this mechanism is for implementing TCP
congestion control algorithms. These are clearly marked as GPL-only when
implemented as modules (as seen by the use of EXPORT_SYMBOL_GPL for
tcp_register_congestion_control()), so it seems like an oversight that this
was not carried over to BPF implementations. Since this is the only user
of the struct_ops mechanism, just enforcing GPL-only for the struct_ops
program type seems like the simplest way to fix this.

Fixes: 0baf26b0fcd7 ("bpf: tcp: Support tcp_congestion_ops in bpf")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20210326100314.121853-1-toke@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11429,6 +11429,11 @@ static int check_struct_ops_btf_id(struc
 	u32 btf_id, member_idx;
 	const char *mname;
 
+	if (!prog->gpl_compatible) {
+		verbose(env, "struct ops programs must have a GPL compatible license\n");
+		return -EINVAL;
+	}
+
 	btf_id = prog->aux->attach_btf_id;
 	st_ops = bpf_struct_ops_find(btf_id);
 	if (!st_ops) {



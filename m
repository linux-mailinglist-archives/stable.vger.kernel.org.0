Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A2A304A9D
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbhAZFBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:01:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:38384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731133AbhAYSvK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:51:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC3B122482;
        Mon, 25 Jan 2021 18:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600627;
        bh=qLzMQBm6bQTPstl2WAIk2UdxfUT2I/uhyf0Jt14785E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jNXh+s6toPVJ5zek7ThYGYIUB+UAr/BUf4JdJoEugM8sWAs4FhTOJOgsZIYg61fZv
         LuCj6utsP6JflAHefDwUIpRO9kK8by0qTmHVJcw/ArnMMsE/Sji1JQlMbMyK9VTFEX
         2Z4WfC3ivF9VSsf4/7c3p0fzmX6YZ1aY9GAjAkJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/199] bpf: Prevent double bpf_prog_put call from bpf_tracing_prog_attach
Date:   Mon, 25 Jan 2021 19:38:29 +0100
Message-Id: <20210125183219.944312648@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 5541075a348b6ca6ac668653f7d2c423ae8e00b6 ]

The bpf_tracing_prog_attach error path calls bpf_prog_put
on prog, which causes refcount underflow when it's called
from link_create function.

  link_create
    prog = bpf_prog_get              <-- get
    ...
    tracing_bpf_link_attach(prog..
      bpf_tracing_prog_attach(prog..
        out_put_prog:
          bpf_prog_put(prog);        <-- put

    if (ret < 0)
      bpf_prog_put(prog);            <-- put

Removing bpf_prog_put call from bpf_tracing_prog_attach
and making sure its callers call it instead.

Fixes: 4a1e7c0c63e0 ("bpf: Support attaching freplace programs to multiple attach points")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210111191650.1241578-1-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 8f50c9c19f1b0..9433ab9995cd7 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2717,7 +2717,6 @@ out_unlock:
 out_put_prog:
 	if (tgt_prog_fd && tgt_prog)
 		bpf_prog_put(tgt_prog);
-	bpf_prog_put(prog);
 	return err;
 }
 
@@ -2830,7 +2829,10 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 			tp_name = prog->aux->attach_func_name;
 			break;
 		}
-		return bpf_tracing_prog_attach(prog, 0, 0);
+		err = bpf_tracing_prog_attach(prog, 0, 0);
+		if (err >= 0)
+			return err;
+		goto out_put_prog;
 	case BPF_PROG_TYPE_RAW_TRACEPOINT:
 	case BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE:
 		if (strncpy_from_user(buf,
-- 
2.27.0




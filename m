Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C12300B6D
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 19:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729504AbhAVSWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:22:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:38994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728583AbhAVOXQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:23:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2037223A7A;
        Fri, 22 Jan 2021 14:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325046;
        bh=vN3jV6eWtMx4XExwl7nIVv/YMc1xOgfY/VweDoxuuxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mldD8uyl9+Fc5IQw92/h5i0oc5B0zO9VneCexhGBgywxsi5ROx2WcBwHZrgdsnUf7
         +VbGXJGJv8otcNdIELOTb8zQm0j9dWsYt+ffDsBWvq+aRJPBJKVaqrR0Do/P4M3H6H
         +x43rc2jRLPJf4EwFz1pJibYdQXfYHuMhob2tUqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH 5.4 29/33] net, sctp, filter: remap copy_from_user failure error
Date:   Fri, 22 Jan 2021 15:12:45 +0100
Message-Id: <20210122135734.750091426@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135733.565501039@linuxfoundation.org>
References: <20210122135733.565501039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ no upstream commit ]

Fix a potential kernel address leakage for the prerequisite where there is
a BPF program attached to the cgroup/setsockopt hook. The latter can only
be attached under root, however, if the attached program returns 1 to then
run the related kernel handler, an unprivileged program could probe for
kernel addresses that way. The reason this is possible is that we're under
set_fs(KERNEL_DS) when running the kernel setsockopt handler. Aside from
old cBPF there is also SCTP's struct sctp_getaddrs_old which contains
pointers in the uapi struct that further need copy_from_user() inside the
handler. In the normal case this would just return -EFAULT, but under a
temporary KERNEL_DS setting the memory would be copied and we'd end up at
a different error code, that is, -EINVAL, for both cases given subsequent
validations fail, which then allows the app to distinguish and make use of
this fact for probing the address space. In case of later kernel versions
this issue won't work anymore thanks to Christoph Hellwig's work that got
rid of the various temporary set_fs() address space overrides altogether.
One potential option for 5.4 as the only affected stable kernel with the
least complexity would be to remap those affected -EFAULT copy_from_user()
error codes with -EINVAL such that they cannot be probed anymore. Risk of
breakage should be rather low for this particular error case.

Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
Reported-by: Ryota Shiga (Flatt Security)
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Stanislav Fomichev <sdf@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/filter.c |    2 +-
 net/sctp/socket.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1475,7 +1475,7 @@ struct bpf_prog *__get_filter(struct soc
 
 	if (copy_from_user(prog->insns, fprog->filter, fsize)) {
 		__bpf_prog_free(prog);
-		return ERR_PTR(-EFAULT);
+		return ERR_PTR(-EINVAL);
 	}
 
 	prog->len = fprog->len;
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1319,7 +1319,7 @@ static int __sctp_setsockopt_connectx(st
 
 	kaddrs = memdup_user(addrs, addrs_size);
 	if (IS_ERR(kaddrs))
-		return PTR_ERR(kaddrs);
+		return PTR_ERR(kaddrs) == -EFAULT ? -EINVAL : PTR_ERR(kaddrs);
 
 	/* Allow security module to validate connectx addresses. */
 	err = security_sctp_bind_connect(sk, SCTP_SOCKOPT_CONNECTX,



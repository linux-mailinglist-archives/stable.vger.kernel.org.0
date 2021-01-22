Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88813300634
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbhAVOyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:54:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:40014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728637AbhAVOXv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:23:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 752DB23A69;
        Fri, 22 Jan 2021 14:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325121;
        bh=QlWNqe83q5yf7zHje8VlVcXxc+H+hS9UUvG/UYN90mA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kAVrYlyZ/vC60Xo5+VoT37eM4CunKyumIM9/2j7sUqidOMKXA1/QsiZK+Q0CaUMBw
         yjUM0MgDgN/9ivEzoOm2KfBgJvmBNgF+O07s5Pp2Yr3sVQwoWX6fOSHLYEKO5FuiZP
         En0RkCFEyHb6kHTvZILAkfHEaWizImBBMZcimPy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.10 08/43] bpf: Dont leak memory in bpf getsockopt when optlen == 0
Date:   Fri, 22 Jan 2021 15:12:24 +0100
Message-Id: <20210122135735.992134571@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanislav Fomichev <sdf@google.com>

commit 4be34f3d0731b38a1b24566b37fbb39500aaf3a2 upstream.

optlen == 0 indicates that the kernel should ignore BPF buffer
and use the original one from the user. We, however, forget
to free the temporary buffer that we've allocated for BPF.

Fixes: d8fe449a9c51 ("bpf: Don't return EINVAL from {get,set}sockopt when optlen > PAGE_SIZE")
Reported-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20210112162829.775079-1-sdf@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/cgroup.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1391,12 +1391,13 @@ int __cgroup_bpf_run_filter_setsockopt(s
 		if (ctx.optlen != 0) {
 			*optlen = ctx.optlen;
 			*kernel_optval = ctx.optval;
+			/* export and don't free sockopt buf */
+			return 0;
 		}
 	}
 
 out:
-	if (ret)
-		sockopt_free_buf(&ctx);
+	sockopt_free_buf(&ctx);
 	return ret;
 }
 



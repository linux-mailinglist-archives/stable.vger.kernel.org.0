Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 645BC12EF26
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730685AbgABWeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:34:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:40482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730570AbgABWdP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:33:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 875D320866;
        Thu,  2 Jan 2020 22:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004395;
        bh=XyKOjQslPdTHlWPxGpQ+P5WzATKnm4hOAEZiiYEXo9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dZ9Q0/kKWjRwrI3JxSaBwrOXVr6guagX4sNRczXfqvlHZ77Tn4r/w0U5LZYDiEufy
         NIBYrZX1dFWcPfOG5uzk+MsEb098DPMweiv9a351K1YectG5wWFicj4LcDfvOtRhRq
         Kg/4YNvZoFdah9+1BkxAxqRx6fz/GYqJLQJm271U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@dlink.ru>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 153/171] net, sysctl: Fix compiler warning when only cBPF is present
Date:   Thu,  2 Jan 2020 23:08:04 +0100
Message-Id: <20200102220608.082896518@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@dlink.ru>

[ Upstream commit 1148f9adbe71415836a18a36c1b4ece999ab0973 ]

proc_dointvec_minmax_bpf_restricted() has been firstly introduced
in commit 2e4a30983b0f ("bpf: restrict access to core bpf sysctls")
under CONFIG_HAVE_EBPF_JIT. Then, this ifdef has been removed in
ede95a63b5e8 ("bpf: add bpf_jit_limit knob to restrict unpriv
allocations"), because a new sysctl, bpf_jit_limit, made use of it.
Finally, this parameter has become long instead of integer with
fdadd04931c2 ("bpf: fix bpf_jit_limit knob for PAGE_SIZE >= 64K")
and thus, a new proc_dolongvec_minmax_bpf_restricted() has been
added.

With this last change, we got back to that
proc_dointvec_minmax_bpf_restricted() is used only under
CONFIG_HAVE_EBPF_JIT, but the corresponding ifdef has not been
brought back.

So, in configurations like CONFIG_BPF_JIT=y && CONFIG_HAVE_EBPF_JIT=n
since v4.20 we have:

  CC      net/core/sysctl_net_core.o
net/core/sysctl_net_core.c:292:1: warning: ‘proc_dointvec_minmax_bpf_restricted’ defined but not used [-Wunused-function]
  292 | proc_dointvec_minmax_bpf_restricted(struct ctl_table *table, int write,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Suppress this by guarding it with CONFIG_HAVE_EBPF_JIT again.

Fixes: fdadd04931c2 ("bpf: fix bpf_jit_limit knob for PAGE_SIZE >= 64K")
Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20191218091821.7080-1-alobakin@dlink.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sysctl_net_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index a6fc82704f0c..b4318c1b5b96 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -255,6 +255,7 @@ static int proc_dointvec_minmax_bpf_enable(struct ctl_table *table, int write,
 	return ret;
 }
 
+# ifdef CONFIG_HAVE_EBPF_JIT
 static int
 proc_dointvec_minmax_bpf_restricted(struct ctl_table *table, int write,
 				    void __user *buffer, size_t *lenp,
@@ -265,6 +266,7 @@ proc_dointvec_minmax_bpf_restricted(struct ctl_table *table, int write,
 
 	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 }
+# endif /* CONFIG_HAVE_EBPF_JIT */
 
 static int
 proc_dolongvec_minmax_bpf_restricted(struct ctl_table *table, int write,
-- 
2.20.1




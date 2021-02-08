Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9BB63137B7
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbhBHP3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:29:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:35838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233740AbhBHPZd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:25:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59D5364F17;
        Mon,  8 Feb 2021 15:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797318;
        bh=ELAml083cyW8aO8DbweNgWdGcfj93nsKC4DYHD+NvnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HdCUbjiqFkLCw4QUhL7sDjIZfmIQ4kIZLIMO0Efy6TwSmScRTVRlLwmkJGLufUdig
         y7SlyojHGATmkcBXNR/ybM5y0+WztocL7iz8fqjiyjPXVL82VJTTjy0kaq4WFwgB6l
         By0xmSLmFeD5wfN4fidvqkfYASZItON21nUosKBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Loris Reiff <loris.reiff@liblor.ch>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/120] bpf, cgroup: Fix optlen WARN_ON_ONCE toctou
Date:   Mon,  8 Feb 2021 16:00:13 +0100
Message-Id: <20210208145819.440605452@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loris Reiff <loris.reiff@liblor.ch>

[ Upstream commit bb8b81e396f7afbe7c50d789e2107512274d2a35 ]

A toctou issue in `__cgroup_bpf_run_filter_getsockopt` can trigger a
WARN_ON_ONCE in a check of `copy_from_user`.

`*optlen` is checked to be non-negative in the individual getsockopt
functions beforehand. Changing `*optlen` in a race to a negative value
will result in a `copy_from_user(ctx.optval, optval, ctx.optlen)` with
`ctx.optlen` being a negative integer.

Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
Signed-off-by: Loris Reiff <loris.reiff@liblor.ch>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/bpf/20210122164232.61770-1-loris.reiff@liblor.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cgroup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 96555a8a2c545..6ec8f02f463b6 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1442,6 +1442,11 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 			goto out;
 		}
 
+		if (ctx.optlen < 0) {
+			ret = -EFAULT;
+			goto out;
+		}
+
 		if (copy_from_user(ctx.optval, optval,
 				   min(ctx.optlen, max_optlen)) != 0) {
 			ret = -EFAULT;
-- 
2.27.0




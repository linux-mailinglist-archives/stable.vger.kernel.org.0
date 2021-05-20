Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A8438A4A9
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235055AbhETKHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:07:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232048AbhETKFb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:05:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6953861939;
        Thu, 20 May 2021 09:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503676;
        bh=yRRgUS3ItAIl0mq5NIQKEK4SulKoRVO5gWBFjXPDg9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oi1pICufpfJWjFNJCA8V4hylsgjL5gCZ5hed829N4/zCXK8RBQPUt9p/FGa2kxN0k
         XfoDWa3cvZz+bT0NKj1npcTKW9Yzb/NdVJvh3MiMx3PlHgo+EJ0u+2L92Jzk9kriA/
         JDz/NlXRd2yKgHwmOtiWhWJDFz8BVwgqrh7VqboU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathon Reinhart <jonathon.reinhart@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 295/425] net: Only allow init netns to set default tcp cong to a restricted algo
Date:   Thu, 20 May 2021 11:21:04 +0200
Message-Id: <20210520092141.145797375@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathon Reinhart <jonathon.reinhart@gmail.com>

commit 8d432592f30fcc34ef5a10aac4887b4897884493 upstream.

tcp_set_default_congestion_control() is netns-safe in that it writes
to &net->ipv4.tcp_congestion_control, but it also sets
ca->flags |= TCP_CONG_NON_RESTRICTED which is not namespaced.
This has the unintended side-effect of changing the global
net.ipv4.tcp_allowed_congestion_control sysctl, despite the fact that it
is read-only: 97684f0970f6 ("net: Make tcp_allowed_congestion_control
readonly in non-init netns")

Resolve this netns "leak" by only allowing the init netns to set the
default algorithm to one that is restricted. This restriction could be
removed if tcp_allowed_congestion_control were namespace-ified in the
future.

This bug was uncovered with
https://github.com/JonathonReinhart/linux-netns-sysctl-verify

Fixes: 6670e1524477 ("tcp: Namespace-ify sysctl_tcp_default_congestion_control")
Signed-off-by: Jonathon Reinhart <jonathon.reinhart@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_cong.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -228,6 +228,10 @@ int tcp_set_default_congestion_control(s
 		ret = -ENOENT;
 	} else if (!try_module_get(ca->owner)) {
 		ret = -EBUSY;
+	} else if (!net_eq(net, &init_net) &&
+			!(ca->flags & TCP_CONG_NON_RESTRICTED)) {
+		/* Only init netns can set default to a restricted algorithm */
+		ret = -EPERM;
 	} else {
 		prev = xchg(&net->ipv4.tcp_congestion_control, ca);
 		if (prev)



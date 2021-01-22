Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5BAF300FD0
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 23:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730408AbhAVT4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 14:56:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:34410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728255AbhAVOKZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:10:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8C2523A68;
        Fri, 22 Jan 2021 14:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324555;
        bh=SB8J9olcChwxi0/uJFauBUyLvKbKCQcEBb/seqsizw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ct3VXwxELCHnUQQmzRhj/s1wpaNmUGc2pY6rcwoskuFoxyTZRIsyRqxhnun+FJLh6
         LjNdYk6oRRsdKYVCG1+Or6M0q5WHYDIm/ByiceEN4rGpmWRZqO9dUphUV530Oi8gem
         k+hPZkbg28OgaLY63/eOtYO/Qh7VogXSzJOHqKuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Nixdorf <j.nixdorf@avm.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.4 18/31] net: sunrpc: interpret the return value of kstrtou32 correctly
Date:   Fri, 22 Jan 2021 15:08:32 +0100
Message-Id: <20210122135732.605503847@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135731.873346566@linuxfoundation.org>
References: <20210122135731.873346566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: j.nixdorf@avm.de <j.nixdorf@avm.de>

commit 86b53fbf08f48d353a86a06aef537e78e82ba721 upstream.

A return value of 0 means success. This is documented in lib/kstrtox.c.

This was found by trying to mount an NFS share from a link-local IPv6
address with the interface specified by its index:

  mount("[fe80::1%1]:/srv/nfs", "/mnt", "nfs", 0, "nolock,addr=fe80::1%1")

Before this commit this failed with EINVAL and also caused the following
message in dmesg:

  [...] NFS: bad IP address specified: addr=fe80::1%1

The syscall using the same address based on the interface name instead
of its index succeeds.

Credits for this patch go to my colleague Christian Speich, who traced
the origin of this bug to this line of code.

Signed-off-by: Johannes Nixdorf <j.nixdorf@avm.de>
Fixes: 00cfaa943ec3 ("replace strict_strto calls")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/addr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/addr.c
+++ b/net/sunrpc/addr.c
@@ -184,7 +184,7 @@ static int rpc_parse_scope_id(struct net
 			scope_id = dev->ifindex;
 			dev_put(dev);
 		} else {
-			if (kstrtou32(p, 10, &scope_id) == 0) {
+			if (kstrtou32(p, 10, &scope_id) != 0) {
 				kfree(p);
 				return 0;
 			}



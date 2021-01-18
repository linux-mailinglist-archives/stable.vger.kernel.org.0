Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBEF22F9E7C
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390601AbhARLkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:40:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:34192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390595AbhARLkL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:40:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBB17222BB;
        Mon, 18 Jan 2021 11:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969996;
        bh=MjrKb1h4tMErpsH8+EzAbPNEt6Oz+fy/TlWsRz575As=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DO0jeqqP5975fy3bkVWvz0MjuKE+CQ8vmLd5Bj+0ILFZVPYm9lO9dOckIIlm/s9rF
         Taz72Dp5F9TzJr85IiTsZX3xjftC60Z8QmMHFwuxSKs4Kmqh+qDSUrK2rIf3/R/dvd
         nXEchNxnRzEtqlFU+H4hSEr3RbqjL5RBJtyKlmog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Nixdorf <j.nixdorf@avm.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.4 70/76] net: sunrpc: interpret the return value of kstrtou32 correctly
Date:   Mon, 18 Jan 2021 12:35:10 +0100
Message-Id: <20210118113344.316368952@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
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
@@ -185,7 +185,7 @@ static int rpc_parse_scope_id(struct net
 			scope_id = dev->ifindex;
 			dev_put(dev);
 		} else {
-			if (kstrtou32(p, 10, &scope_id) == 0) {
+			if (kstrtou32(p, 10, &scope_id) != 0) {
 				kfree(p);
 				return 0;
 			}



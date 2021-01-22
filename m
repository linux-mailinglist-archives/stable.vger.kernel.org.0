Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FB2300B83
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 19:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729550AbhAVSjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:39:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:37508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728480AbhAVOSj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:18:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 235E223A9A;
        Fri, 22 Jan 2021 14:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324846;
        bh=SB8J9olcChwxi0/uJFauBUyLvKbKCQcEBb/seqsizw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bujSrw3aMiFr94zxVvoUhp+gM1eC6rPcifR9kHnapom70AY6zI4BOqhZE/NXRgVOo
         Ilbb8HSlkpNvespoXqfR5IyWWjrUydT27CWbfWl3ETkcXyvn0bevaI12Gj+7n6O8he
         3UJJMfs4EA3IEwTyr6F4XlwQwAuCvea6cKGQScS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Nixdorf <j.nixdorf@avm.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.14 28/50] net: sunrpc: interpret the return value of kstrtou32 correctly
Date:   Fri, 22 Jan 2021 15:12:09 +0100
Message-Id: <20210122135736.325356204@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.176469491@linuxfoundation.org>
References: <20210122135735.176469491@linuxfoundation.org>
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



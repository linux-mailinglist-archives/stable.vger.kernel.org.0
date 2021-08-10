Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80DE63E8240
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237751AbhHJSGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:06:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238314AbhHJSEB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 14:04:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53CF561221;
        Tue, 10 Aug 2021 17:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617695;
        bh=bswYOrY3+n4a6Hq+ZLvqJTXJghVf156L11jaxz7vkMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DTLrzDpfuZ3XeRYVXPeyHeMe9ZwC+AaadIhqf1HoFzZvXHwqRPsua4QrUK0R7DbIc
         3d9lLGRTvfFXANxObFOeqKhID9GJAPNNTPmizgsNzSwUk1D3ayu2fjoqIS1kekYWux
         drQhqUeuX0+hgpc0rpH7S45ZQ0Y09vlBM95l6XD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiu Jianfeng <xiujianfeng@huawei.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.13 139/175] selinux: correct the return value when loads initial sids
Date:   Tue, 10 Aug 2021 19:30:47 +0200
Message-Id: <20210810173005.520163677@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiu Jianfeng <xiujianfeng@huawei.com>

commit 4c156084daa8ee70978e4b150b5eb5fc7b1f15be upstream.

It should not return 0 when SID 0 is assigned to isids.
This patch fixes it.

Cc: stable@vger.kernel.org
Fixes: e3e0b582c321a ("selinux: remove unused initial SIDs and improve handling")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
[PM: remove changelog from description]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/ss/policydb.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -874,7 +874,7 @@ int policydb_load_isids(struct policydb
 	rc = sidtab_init(s);
 	if (rc) {
 		pr_err("SELinux:  out of memory on SID table init\n");
-		goto out;
+		return rc;
 	}
 
 	head = p->ocontexts[OCON_ISID];
@@ -885,7 +885,7 @@ int policydb_load_isids(struct policydb
 		if (sid == SECSID_NULL) {
 			pr_err("SELinux:  SID 0 was assigned a context.\n");
 			sidtab_destroy(s);
-			goto out;
+			return -EINVAL;
 		}
 
 		/* Ignore initial SIDs unused by this kernel. */
@@ -897,12 +897,10 @@ int policydb_load_isids(struct policydb
 			pr_err("SELinux:  unable to load initial SID %s.\n",
 			       name);
 			sidtab_destroy(s);
-			goto out;
+			return rc;
 		}
 	}
-	rc = 0;
-out:
-	return rc;
+	return 0;
 }
 
 int policydb_class_isvalid(struct policydb *p, unsigned int class)



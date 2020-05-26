Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8C51E2C82
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404444AbgEZTPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:15:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404440AbgEZTPb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:15:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A54C22053B;
        Tue, 26 May 2020 19:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520531;
        bh=+/JqMvW1b6/2UGdBzKQ5fPyQRh+jz9mwgffvKbkkk7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R9GNDILWzuHHvTQCXFJlXW3Ny5mUHB6qM8pkF0Eg4A9cWDm12M5Y/lAsCPQDgNTH/
         5tRqIyvAcVNHMNEFCiJS1GDOFiOePETSG77gY3YQWPT2/lbFsOudVfquk+QUfni6dP
         jwZXb3T3D0fG8FQIl6Kc0CnV33l9PoN5OhgF9cVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        John Johansen <john.johansen@canonical.com>
Subject: [PATCH 5.6 076/126] apparmor: Fix aa_label refcnt leak in policy_update
Date:   Tue, 26 May 2020 20:53:33 +0200
Message-Id: <20200526183944.575436795@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

commit c6b39f070722ea9963ffe756bfe94e89218c5e63 upstream.

policy_update() invokes begin_current_label_crit_section(), which
returns a reference of the updated aa_label object to "label" with
increased refcount.

When policy_update() returns, "label" becomes invalid, so the refcount
should be decreased to keep refcount balanced.

The reference counting issue happens in one exception handling path of
policy_update(). When aa_may_manage_policy() returns not NULL, the
refcnt increased by begin_current_label_crit_section() is not decreased,
causing a refcnt leak.

Fix this issue by jumping to "end_section" label when
aa_may_manage_policy() returns not NULL.

Fixes: 5ac8c355ae00 ("apparmor: allow introspecting the loaded policy pre internal transform")
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/apparmor/apparmorfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -454,7 +454,7 @@ static ssize_t policy_update(u32 mask, c
 	 */
 	error = aa_may_manage_policy(label, ns, mask);
 	if (error)
-		return error;
+		goto end_section;
 
 	data = aa_simple_write_to_buffer(buf, size, size, pos);
 	error = PTR_ERR(data);
@@ -462,6 +462,7 @@ static ssize_t policy_update(u32 mask, c
 		error = aa_replace_profiles(ns, label, mask, data);
 		aa_put_loaddata(data);
 	}
+end_section:
 	end_current_label_crit_section(label);
 
 	return error;



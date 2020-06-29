Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B182920DE3E
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732566AbgF2UX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:23:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732572AbgF2TZc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FEE6253DA;
        Mon, 29 Jun 2020 15:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445316;
        bh=DLpiSkuHHXGMoU/1ydEngL9Q0QpIlhx2bgN93M2f1Mg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n6puT8skakobD/2XHKunsj8j71BKQRnNaghG5v6dIS8fhh9x4c873D6wYSicjOkra
         gPruup3y1ZIT7d0AcmWE8Jc20sGtoV6vsdQ5XajQ+e9cV9oe+CklN9P5NcIK9cjWD3
         VntxRI8MgR5QuQuA90BHCG1ifagkXzKU4IrxUPAw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tom Rix <trix@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Paul Moore <paul@paul-moore.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 084/191] selinux: fix double free
Date:   Mon, 29 Jun 2020 11:38:20 -0400
Message-Id: <20200629154007.2495120-85-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

commit 65de50969a77509452ae590e9449b70a22b923bb upstream.

Clang's static analysis tool reports these double free memory errors.

security/selinux/ss/services.c:2987:4: warning: Attempt to free released memory [unix.Malloc]
                        kfree(bnames[i]);
                        ^~~~~~~~~~~~~~~~
security/selinux/ss/services.c:2990:2: warning: Attempt to free released memory [unix.Malloc]
        kfree(bvalues);
        ^~~~~~~~~~~~~~

So improve the security_get_bools error handling by freeing these variables
and setting their return pointers to NULL and the return len to 0

Cc: stable@vger.kernel.org
Signed-off-by: Tom Rix <trix@redhat.com>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/ss/services.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index bfc4ffa1fa1a4..6ca297821d459 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2616,8 +2616,12 @@ int security_get_bools(int *len, char ***names, int **values)
 	if (*names) {
 		for (i = 0; i < *len; i++)
 			kfree((*names)[i]);
+		kfree(*names);
 	}
 	kfree(*values);
+	*len = 0;
+	*names = NULL;
+	*values = NULL;
 	goto out;
 }
 
-- 
2.25.1


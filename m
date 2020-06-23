Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A1E206303
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390548AbgFWVK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389673AbgFWUdL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:33:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 802472064B;
        Tue, 23 Jun 2020 20:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944392;
        bh=OvdgE5Y5rBORuUbfMDJbswl3DeGzsCcxccz0W59OSik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uB9o5hEpyAYdbcMW1rkXQokfbFduQ6I0WVksS9WrzFZX8Lmhq3gVU8N/JCHmW/KfZ
         NTBMjXCl8vk2TfAxfLYK4bimR3hU3Y8SScmnt6f14Htcd4MXx27XfhO54m5HE082EX
         tfKImTej0VBBixYXNtwC2VYpJAFzWCAql7z5/jHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.4 286/314] selinux: fix double free
Date:   Tue, 23 Jun 2020 21:58:01 +0200
Message-Id: <20200623195352.627009011@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 security/selinux/ss/services.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2844,8 +2844,12 @@ err:
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
 



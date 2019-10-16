Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00BFDD9EF1
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438477AbfJPV7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:59:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438474AbfJPV7U (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:59:20 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F41D20872;
        Wed, 16 Oct 2019 21:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263159;
        bh=K5yb8dbyG3rknn0iUfjQOz9VplQrDY1Y/nQQHL4cefE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CPNf/XtLjIPYjwRsFbAerEZeqDpqHfyfRCv3uO5YA5os3bePp13YvEi6TGnPQzSPR
         4GEc9zOBxyfTC31yIGYOxie4vsnjfsWejDg4lQhKg2DUXKz9INOHgSdKYzF59wRUZz
         6plFg/0PewbWtYdSaHRsnott+V6nozMjeNEnRRd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Milos Malik <mmalik@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.3 070/112] selinux: fix context string corruption in convert_context()
Date:   Wed, 16 Oct 2019 14:51:02 -0700
Message-Id: <20191016214903.275204395@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Mosnacek <omosnace@redhat.com>

commit 2a5243937c700ffe6a28e6557a4562a9ab0a17a4 upstream.

string_to_context_struct() may garble the context string, so we need to
copy back the contents again from the old context struct to avoid
storing the corrupted context.

Since string_to_context_struct() tokenizes (and therefore truncates) the
context string and we are later potentially copying it with kstrdup(),
this may eventually cause pieces of uninitialized kernel memory to be
disclosed to userspace (when copying to userspace based on the stored
length and not the null character).

How to reproduce on Fedora and similar:
    # dnf install -y memcached
    # systemctl start memcached
    # semodule -d memcached
    # load_policy
    # load_policy
    # systemctl stop memcached
    # ausearch -m AVC
    type=AVC msg=audit(1570090572.648:313): avc:  denied  { signal } for  pid=1 comm="systemd" scontext=system_u:system_r:init_t:s0 tcontext=system_u:object_r:unlabeled_t:s0 tclass=process permissive=0 trawcon=73797374656D5F75007400000000000070BE6E847296FFFF726F6D000096FFFF76

Cc: stable@vger.kernel.org
Reported-by: Milos Malik <mmalik@redhat.com>
Fixes: ee1a84fdfeed ("selinux: overhaul sidtab to fix bug and improve performance")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/selinux/ss/services.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -1946,7 +1946,14 @@ static int convert_context(struct contex
 		rc = string_to_context_struct(args->newp, NULL, s,
 					      newc, SECSID_NULL);
 		if (rc == -EINVAL) {
-			/* Retain string representation for later mapping. */
+			/*
+			 * Retain string representation for later mapping.
+			 *
+			 * IMPORTANT: We need to copy the contents of oldc->str
+			 * back into s again because string_to_context_struct()
+			 * may have garbled it.
+			 */
+			memcpy(s, oldc->str, oldc->len);
 			context_init(newc);
 			newc->str = s;
 			newc->len = oldc->len;



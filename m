Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E2F1E2BCA
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389990AbgEZTIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:08:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391806AbgEZTIp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:08:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4C8D20776;
        Tue, 26 May 2020 19:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520125;
        bh=Pb3w8EfsuE0U2OZBSl6Xdlzscep5epzAj1g46ZuRWZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IuFaiC7vmQj6z+mhYuzWds/vnuUO0dMKLXr0yIFzl6ZpbegtUGZRrXkX4mU6K63RQ
         jMKgEmpdyFfzOIzM4YPAoYJn078VgUHS0OfiLJFMNUbtyEf6QVkhP81up3zBltHe7N
         /rfRk5ZzHiXDONAyfg88dO8PkGtuoxEyJ9+W1a0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        John Johansen <john.johansen@canonical.com>
Subject: [PATCH 5.4 067/111] apparmor: fix potential label refcnt leak in aa_change_profile
Date:   Tue, 26 May 2020 20:53:25 +0200
Message-Id: <20200526183939.201163831@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

commit a0b845ffa0d91855532b50fc040aeb2d8338dca4 upstream.

aa_change_profile() invokes aa_get_current_label(), which returns
a reference of the current task's label.

According to the comment of aa_get_current_label(), the returned
reference must be put with aa_put_label().
However, when the original object pointed by "label" becomes
unreachable because aa_change_profile() returns or a new object
is assigned to "label", reference count increased by
aa_get_current_label() is not decreased, causing a refcnt leak.

Fix this by calling aa_put_label() before aa_change_profile() return
and dropping unnecessary aa_get_current_label().

Fixes: 9fcf78cca198 ("apparmor: update domain transitions that are subsets of confinement at nnp")
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/apparmor/domain.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -1334,6 +1334,7 @@ int aa_change_profile(const char *fqname
 		ctx->nnp = aa_get_label(label);
 
 	if (!fqname || !*fqname) {
+		aa_put_label(label);
 		AA_DEBUG("no profile name");
 		return -EINVAL;
 	}
@@ -1352,8 +1353,6 @@ int aa_change_profile(const char *fqname
 			op = OP_CHANGE_PROFILE;
 	}
 
-	label = aa_get_current_label();
-
 	if (*fqname == '&') {
 		stack = true;
 		/* don't have label_parse() do stacking */



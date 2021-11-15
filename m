Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85383450C11
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237751AbhKORed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:34:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:46728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238077AbhKORcf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:32:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3129632AA;
        Mon, 15 Nov 2021 17:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996845;
        bh=xevZ7+7VV1jg7BpvyF5u98+YP2gLJdeSbxvMwWEMJFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jViZoQ+Dmw0xALry01Xs4i0bwthiVdreIAIY0sKNarCBbS+jb7S4ArN8ZobeBqSwZ
         ALBLhm487+KgXsFm1xv7DN9/R3r1cvMqg9Ekd9uTWhMsx3PbUy/YCYRE2+0KYRFwy0
         dSFfr/JSEBa7FPeyCb9zSv11UqYws5edxWW91LTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 289/355] apparmor: fix error check
Date:   Mon, 15 Nov 2021 18:03:33 +0100
Message-Id: <20211115165323.074054510@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit d108370c644b153382632b3e5511ade575c91c86 ]

clang static analysis reports this representative problem:

label.c:1463:16: warning: Assigned value is garbage or undefined
        label->hname = name;
                     ^ ~~~~

In aa_update_label_name(), this the problem block of code

	if (aa_label_acntsxprint(&name, ...) == -1)
		return res;

On failure, aa_label_acntsxprint() has a more complicated return
that just -1.  So check for a negative return.

It was also noted that the aa_label_acntsxprint() main comment refers
to a nonexistent parameter, so clean up the comment.

Fixes: f1bd904175e8 ("apparmor: add the base fns() for domain labels")
Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/label.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/label.c b/security/apparmor/label.c
index 5f324d63ceaa3..747a734a08246 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -1459,7 +1459,7 @@ bool aa_update_label_name(struct aa_ns *ns, struct aa_label *label, gfp_t gfp)
 	if (label->hname || labels_ns(label) != ns)
 		return res;
 
-	if (aa_label_acntsxprint(&name, ns, label, FLAGS_NONE, gfp) == -1)
+	if (aa_label_acntsxprint(&name, ns, label, FLAGS_NONE, gfp) < 0)
 		return res;
 
 	ls = labels_set(label);
@@ -1709,7 +1709,7 @@ int aa_label_asxprint(char **strp, struct aa_ns *ns, struct aa_label *label,
 
 /**
  * aa_label_acntsxprint - allocate a __counted string buffer and print label
- * @strp: buffer to write to. (MAY BE NULL if @size == 0)
+ * @strp: buffer to write to.
  * @ns: namespace profile is being viewed from
  * @label: label to view (NOT NULL)
  * @flags: flags controlling what label info is printed
-- 
2.33.0




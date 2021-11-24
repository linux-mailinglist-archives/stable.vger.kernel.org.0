Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1D145C08D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346455AbhKXNJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:09:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347417AbhKXNHr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:07:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD87360524;
        Wed, 24 Nov 2021 12:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757532;
        bh=KvJdOD6V2r6kk7neSVhLpy8RSHHeNxlmkcv5+kOAo9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNI0nqEks6OQnAdOpwUBhQctfVvfbTRDtGEZUmQhGeFllwDpnX+fJV7xIFcI7KaiY
         qBbWDwOTlz35QDHaptf+Kt6reWYoJwsLW84L0vMcEI4K+HUKYFNM5/MZsJ82tnISX+
         DRwwaoE+RinmbbC7M5M3YeT3MUwQILG0reFuW538=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 200/323] apparmor: fix error check
Date:   Wed, 24 Nov 2021 12:56:30 +0100
Message-Id: <20211124115725.700377783@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
index 6727e6fb69df2..5a80a16a7f751 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -1463,7 +1463,7 @@ bool aa_update_label_name(struct aa_ns *ns, struct aa_label *label, gfp_t gfp)
 	if (label->hname || labels_ns(label) != ns)
 		return res;
 
-	if (aa_label_acntsxprint(&name, ns, label, FLAGS_NONE, gfp) == -1)
+	if (aa_label_acntsxprint(&name, ns, label, FLAGS_NONE, gfp) < 0)
 		return res;
 
 	ls = labels_set(label);
@@ -1713,7 +1713,7 @@ int aa_label_asxprint(char **strp, struct aa_ns *ns, struct aa_label *label,
 
 /**
  * aa_label_acntsxprint - allocate a __counted string buffer and print label
- * @strp: buffer to write to. (MAY BE NULL if @size == 0)
+ * @strp: buffer to write to.
  * @ns: namespace profile is being viewed from
  * @label: label to view (NOT NULL)
  * @flags: flags controlling what label info is printed
-- 
2.33.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 180596DB60
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732847AbfGSEHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:07:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732843AbfGSEHy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:07:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BB64218BB;
        Fri, 19 Jul 2019 04:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509274;
        bh=iBYGP2XBc6Wct1cGsCLA+hgQgp6l9VQMtNASFOIsf4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTy2el7NfKhxKnolJmRo+/Te/gnqIcGD18/j0xmQpPpFg9XF91vU4j6KpRO5BCWjP
         7lVfzUSaTBkPYRQFo/kfYxkTOgULJ65rpoWbAkV4qALhLHh0IECcUy0PvidjzMtx9y
         dak4t5ThIsfGsbLwWeraWDYMTpa7/wlFABrAThPA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gen Zhang <blackgod016574@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 009/101] consolemap: Fix a memory leaking bug in drivers/tty/vt/consolemap.c
Date:   Fri, 19 Jul 2019 00:06:00 -0400
Message-Id: <20190719040732.17285-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040732.17285-1-sashal@kernel.org>
References: <20190719040732.17285-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gen Zhang <blackgod016574@gmail.com>

[ Upstream commit 84ecc2f6eb1cb12e6d44818f94fa49b50f06e6ac ]

In function con_insert_unipair(), when allocation for p2 and p1[n]
fails, ENOMEM is returned, but previously allocated p1 is not freed,
remains as leaking memory. Thus we should free p1 as well when this
allocation fails.

Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/vt/consolemap.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/vt/consolemap.c b/drivers/tty/vt/consolemap.c
index 7c7ada0b3ea0..814d1b7967ae 100644
--- a/drivers/tty/vt/consolemap.c
+++ b/drivers/tty/vt/consolemap.c
@@ -489,7 +489,11 @@ con_insert_unipair(struct uni_pagedir *p, u_short unicode, u_short fontpos)
 	p2 = p1[n = (unicode >> 6) & 0x1f];
 	if (!p2) {
 		p2 = p1[n] = kmalloc_array(64, sizeof(u16), GFP_KERNEL);
-		if (!p2) return -ENOMEM;
+		if (!p2) {
+			kfree(p1);
+			p->uni_pgdir[n] = NULL;
+			return -ENOMEM;
+		}
 		memset(p2, 0xff, 64*sizeof(u16)); /* No glyphs for the characters (yet) */
 	}
 
-- 
2.20.1


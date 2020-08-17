Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64611246EFD
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731080AbgHQRkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:40:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731113AbgHQQQj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:16:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AD2622CF7;
        Mon, 17 Aug 2020 16:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680973;
        bh=3uGyPKpUG2CcoX4bW+WaQM1xcyC7Bitx/A8vr+uogCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HP+jr71v+KLVSXyXN84TopjFOwv5STvAZO/cDUOme4Kls2UgcMEs7ouoMBhLsr3bK
         Bin4THG06Xv3qb6WhoujlmtmE8pFHOIuNdK3sdqsrt0GAA/8TPGf57m/g5WP7uejIm
         BDHjsOBak/N533QGpHf3HzzTBV53MAuf3c/7SPn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+a22c6092d003d6fe1122@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 102/168] Smack: fix another vsscanf out of bounds
Date:   Mon, 17 Aug 2020 17:17:13 +0200
Message-Id: <20200817143738.807496446@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit a6bd4f6d9b07452b0b19842044a6c3ea384b0b88 ]

This is similar to commit 84e99e58e8d1 ("Smack: slab-out-of-bounds in
vsscanf") where we added a bounds check on "rule".

Reported-by: syzbot+a22c6092d003d6fe1122@syzkaller.appspotmail.com
Fixes: f7112e6c9abf ("Smack: allow for significantly longer Smack labels v4")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smackfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 10ee51d044926..981f582539acf 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -933,6 +933,10 @@ static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
 
 	for (i = 0; i < catlen; i++) {
 		rule += SMK_DIGITLEN;
+		if (rule > data + count) {
+			rc = -EOVERFLOW;
+			goto out;
+		}
 		ret = sscanf(rule, "%u", &cat);
 		if (ret != 1 || cat > SMACK_CIPSO_MAXCATNUM)
 			goto out;
-- 
2.25.1




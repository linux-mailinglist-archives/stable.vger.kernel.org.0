Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE5E246F19
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731544AbgHQRmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:42:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731114AbgHQQQj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:16:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D71022BEA;
        Mon, 17 Aug 2020 16:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680976;
        bh=7nvE3dkhdEe7sJvLakuPkpz8dtwTtFlRFnVNQXuA5ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t8yoQhMRQkZIAT+TsyGCqzEaGr9JY2OxqTwKIm+XBYlm3yo3SYU5ayb6t1p+fEIPV
         6H2RjFHo1NFvpXSSe7AhHXdY9OFk6HXjI5/MUCTepBvpdnfbd+mfcekCooG0G0Kn70
         8/1uE3RGOh45ohMPB2IGEqHK69HdYrNaIksCg6oQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 103/168] Smack: prevent underflow in smk_set_cipso()
Date:   Mon, 17 Aug 2020 17:17:14 +0200
Message-Id: <20200817143738.859256032@linuxfoundation.org>
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

[ Upstream commit 42a2df3e829f3c5562090391b33714b2e2e5ad4a ]

We have an upper bound on "maplevel" but forgot to check for negative
values.

Fixes: e114e473771c ("Smack: Simplified Mandatory Access Control Kernel")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smackfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 981f582539acf..accd3846f1e3e 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -912,7 +912,7 @@ static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
 	}
 
 	ret = sscanf(rule, "%d", &maplevel);
-	if (ret != 1 || maplevel > SMACK_CIPSO_MAXLEVEL)
+	if (ret != 1 || maplevel < 0 || maplevel > SMACK_CIPSO_MAXLEVEL)
 		goto out;
 
 	rule += SMK_DIGITLEN;
-- 
2.25.1




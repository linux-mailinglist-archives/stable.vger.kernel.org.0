Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63AB620CC2
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfEPQRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:17:43 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:32946 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726464AbfEPQRn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 12:17:43 -0400
Received: from LHREML713-CAH.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 7994C410BB2BC85C4A0F;
        Thu, 16 May 2019 17:17:41 +0100 (IST)
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.154)
 by smtpsuk.huawei.com (10.201.108.36) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 16 May 2019 17:17:32 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <dmitry.kasatkin@huawei.com>,
        <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 2/4] evm: reset status in evm_inode_post_setattr()
Date:   Thu, 16 May 2019 18:12:55 +0200
Message-ID: <20190516161257.6640-2-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190516161257.6640-1-roberto.sassu@huawei.com>
References: <20190516161257.6640-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.65.154]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch adds a call to evm_reset_status() in evm_inode_post_setattr(),
before security.evm is updated. The same is done in the other
evm_inode_post_* functions.

Fixes: 523b74b16bcbb ("evm: reset EVM status when file attributes change")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Cc: stable@vger.kernel.org
---
 security/integrity/evm/evm_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index b6d9f14bc234..b41c2d8a8834 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -512,8 +512,11 @@ void evm_inode_post_setattr(struct dentry *dentry, int ia_valid)
 	if (!evm_key_loaded())
 		return;
 
-	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID))
+	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID)) {
+		evm_reset_status(dentry->d_inode);
+
 		evm_update_evmxattr(dentry, NULL, NULL, 0);
+	}
 }
 
 /*
-- 
2.17.1


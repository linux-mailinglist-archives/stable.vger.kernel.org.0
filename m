Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7A5608628
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbiJVHp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231529AbiJVHoa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:44:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1928625B254;
        Sat, 22 Oct 2022 00:43:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD78BB82E05;
        Sat, 22 Oct 2022 07:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C136C433C1;
        Sat, 22 Oct 2022 07:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424519;
        bh=7Q6MPwhmrr5duWhaJn7LPUnD03iMIW/ggf8M3L2Dfm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Acyx54IiQQjNTIqUny4gXPQaOLMLf33wZt0uIz0RBzmhilTMV9wrlDC5xi93RTc9v
         Qa9jLjf3hGtTbbf0sHR7mqs3MeUW7qSqKtPFjoO1XQ/S0Ny+VmJv9j/VwgQQzurIHa
         FD/fnJdiLVlODzgDlOqbpFRE6qRjJhWGNHE1rmqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 177/717] ima: fix blocking of security.ima xattrs of unsupported algorithms
Date:   Sat, 22 Oct 2022 09:20:56 +0200
Message-Id: <20221022072446.904520536@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mimi Zohar <zohar@linux.ibm.com>

[ Upstream commit 5926586f291b53cb8a0c9631fc19489be1186e2d ]

Limit validating the hash algorithm to just security.ima xattr, not
the security.evm xattr or any of the protected EVM security xattrs,
nor posix acls.

Fixes: 50f742dd9147 ("IMA: block writes of the security.ima xattr with unsupported algorithms")
Reported-by: Christian Brauner <brauner@kernel.org>
Acked-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_appraise.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index bde74fcecee3..3e0fbbd99534 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -750,22 +750,26 @@ int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
 	const struct evm_ima_xattr_data *xvalue = xattr_value;
 	int digsig = 0;
 	int result;
+	int err;
 
 	result = ima_protect_xattr(dentry, xattr_name, xattr_value,
 				   xattr_value_len);
 	if (result == 1) {
 		if (!xattr_value_len || (xvalue->type >= IMA_XATTR_LAST))
 			return -EINVAL;
+
+		err = validate_hash_algo(dentry, xvalue, xattr_value_len);
+		if (err)
+			return err;
+
 		digsig = (xvalue->type == EVM_IMA_XATTR_DIGSIG);
 	} else if (!strcmp(xattr_name, XATTR_NAME_EVM) && xattr_value_len > 0) {
 		digsig = (xvalue->type == EVM_XATTR_PORTABLE_DIGSIG);
 	}
 	if (result == 1 || evm_revalidate_status(xattr_name)) {
-		result = validate_hash_algo(dentry, xvalue, xattr_value_len);
-		if (result)
-			return result;
-
 		ima_reset_appraise_flags(d_backing_inode(dentry), digsig);
+		if (result == 1)
+			result = 0;
 	}
 	return result;
 }
-- 
2.35.1




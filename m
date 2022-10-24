Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8F160B28C
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbiJXQsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232997AbiJXQrN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:47:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349B91BF228;
        Mon, 24 Oct 2022 08:31:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27311B8196F;
        Mon, 24 Oct 2022 12:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734F3C433C1;
        Mon, 24 Oct 2022 12:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615216;
        bh=A1DSbYE0CBk14ThL+CHiNgxGZfZvPhBFaGIk2PLlJqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNFgh4K+WqC4uCH5LhGswvoKJ4rB5mq8CCJUuJY+UTut0IwCW5aBj/4Qydtydap81
         /zR4irubC27F/Gv25PUiDg93HvLVyqgsPQedaofIb3NLn2CWLFgVrXWTslDlAd1ZMv
         EOSWIcFGi9QohItnMpPJUN77WVBFuNdF3GIV6a+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 136/530] ima: fix blocking of security.ima xattrs of unsupported algorithms
Date:   Mon, 24 Oct 2022 13:28:00 +0200
Message-Id: <20221024113051.209158341@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index ed04bb7c7512..08b49bd1e8ca 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -644,22 +644,26 @@ int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69FB5579AB9
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239183AbiGSMRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239202AbiGSMQ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:16:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A067055082;
        Tue, 19 Jul 2022 05:06:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98E876163C;
        Tue, 19 Jul 2022 12:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA60C341C6;
        Tue, 19 Jul 2022 12:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232365;
        bh=A6a6wkNeNulkql7YiF4UI9D98nrntVs0dK0AcV1Odh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+IVfFUJ3s8mHciRwSt1lBmRjGBhsG8tjMRXOWO1W2imr6ge9LhIvij2FK8sS9puc
         2kNhNwiz8Lt3gG4GO0+PuOddy088nwwXMyw8nbytOB8w0/mliqMV7NGNQxqCvVifGi
         E745293UjaL04DI/PKG3pUe2oXJh5+N2wEKEdoL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huaxin Lu <luhuaxin1@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/112] ima: Fix a potential integer overflow in ima_appraise_measurement
Date:   Tue, 19 Jul 2022 13:53:26 +0200
Message-Id: <20220719114629.378038238@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
References: <20220719114626.156073229@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huaxin Lu <luhuaxin1@huawei.com>

[ Upstream commit d2ee2cfc4aa85ff6a2a3b198a3a524ec54e3d999 ]

When the ima-modsig is enabled, the rc passed to evm_verifyxattr() may be
negative, which may cause the integer overflow problem.

Fixes: 39b07096364a ("ima: Implement support for module-style appended signatures")
Signed-off-by: Huaxin Lu <luhuaxin1@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_appraise.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 3dd8c2e4314e..7122a359a268 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -396,7 +396,8 @@ int ima_appraise_measurement(enum ima_hooks func,
 		goto out;
 	}
 
-	status = evm_verifyxattr(dentry, XATTR_NAME_IMA, xattr_value, rc, iint);
+	status = evm_verifyxattr(dentry, XATTR_NAME_IMA, xattr_value,
+				 rc < 0 ? 0 : rc, iint);
 	switch (status) {
 	case INTEGRITY_PASS:
 	case INTEGRITY_PASS_IMMUTABLE:
-- 
2.35.1




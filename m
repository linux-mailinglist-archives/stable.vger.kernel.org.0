Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9AC5799FE
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238451AbiGSMKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238592AbiGSMJL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:09:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0C850183;
        Tue, 19 Jul 2022 05:02:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F0EDB81B2D;
        Tue, 19 Jul 2022 12:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D170C341C6;
        Tue, 19 Jul 2022 12:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232133;
        bh=/YKQ7D/w6ff5ZwaE0DJ2ZPHJml5aPh3NmKusv3Ju3jE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXhl57HNOayFQVrN9yserNxbg6s5byMT7ZHTZjXVdOQqldoDrtUQAz4GtlNiMqXRA
         bkw6pXDmrNQlCn04XAiq6C2dfzPaY0D5IgIOOrGRd2MhrkHsK9Y9lwsPTEfJEd/2tL
         W9BIak7K+QjhhLkAnSdKt5yq7PBgPa3taWjBFuCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huaxin Lu <luhuaxin1@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 23/71] ima: Fix a potential integer overflow in ima_appraise_measurement
Date:   Tue, 19 Jul 2022 13:53:46 +0200
Message-Id: <20220719114554.491545435@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114552.477018590@linuxfoundation.org>
References: <20220719114552.477018590@linuxfoundation.org>
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
index 23b04c6521b2..9368688449b0 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -352,7 +352,8 @@ int ima_appraise_measurement(enum ima_hooks func,
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




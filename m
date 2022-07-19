Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70690579BDD
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240110AbiGSMc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238375AbiGSMc0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:32:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49EA470E56;
        Tue, 19 Jul 2022 05:12:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 322C8B81B31;
        Tue, 19 Jul 2022 12:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9536EC341C6;
        Tue, 19 Jul 2022 12:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232728;
        bh=Z1JtSfxrx09o6ta6fOCcZnqAzuj3UPKp2mD7YWnzRFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EIFsBrrXi4RQOa2rsRUXxeo0q/If2ltn4SFLW9aG5RHsvY/TmqOFu4WHjKljHoi7v
         1OZo3KSylQ+oocwULsiT8DFtDMK83IxG0RaM3BKt+9ZKdwkZC+cL4atDcn3juG+UKK
         jbHwnk6nps3oOnTc/RukD0pdmHi/cB3DScvemhGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Guozihua (Scott)" <guozihua@huawei.com>,
        Xiu Jianfeng <xiujianfeng@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.15 025/167] Revert "evm: Fix memleak in init_desc"
Date:   Tue, 19 Jul 2022 13:52:37 +0200
Message-Id: <20220719114659.180339695@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
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

From: Xiu Jianfeng <xiujianfeng@huawei.com>

commit 51dd64bb99e4478fc5280171acd8e1b529eadaf7 upstream.

This reverts commit ccf11dbaa07b328fa469415c362d33459c140a37.

Commit ccf11dbaa07b ("evm: Fix memleak in init_desc") said there is
memleak in init_desc. That may be incorrect, as we can see, tmp_tfm is
saved in one of the two global variables hmac_tfm or evm_tfm[hash_algo],
then if init_desc is called next time, there is no need to alloc tfm
again, so in the error path of kmalloc desc or crypto_shash_init(desc),
It is not a problem without freeing tmp_tfm.

And also that commit did not reset the global variable to NULL after
freeing tmp_tfm and this makes *tfm a dangling pointer which may cause a
UAF issue.

Reported-by: Guozihua (Scott) <guozihua@huawei.com>
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/evm/evm_crypto.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -75,7 +75,7 @@ static struct shash_desc *init_desc(char
 {
 	long rc;
 	const char *algo;
-	struct crypto_shash **tfm, *tmp_tfm = NULL;
+	struct crypto_shash **tfm, *tmp_tfm;
 	struct shash_desc *desc;
 
 	if (type == EVM_XATTR_HMAC) {
@@ -120,16 +120,13 @@ unlock:
 alloc:
 	desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(*tfm),
 			GFP_KERNEL);
-	if (!desc) {
-		crypto_free_shash(tmp_tfm);
+	if (!desc)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	desc->tfm = *tfm;
 
 	rc = crypto_shash_init(desc);
 	if (rc) {
-		crypto_free_shash(tmp_tfm);
 		kfree(desc);
 		return ERR_PTR(rc);
 	}



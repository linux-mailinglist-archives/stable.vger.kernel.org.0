Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182E44B499D
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236308AbiBNKSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:18:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347361AbiBNKQ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:16:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD71569CED;
        Mon, 14 Feb 2022 01:53:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6765B80DC6;
        Mon, 14 Feb 2022 09:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB9AC340E9;
        Mon, 14 Feb 2022 09:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832426;
        bh=LBylFngLp5Sc0TB3vzfnAJqZtAbcj0oRjimFAAhmYCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a+5JXt5JjHrsi+F8wUWDJ0pJC0eJ5p4P8fKXTsfuz/MuEGpPjNymkZEt4VYOtOkGi
         yxNuhiPQBEkPKPEYZJiUSpKnHvAel3w1BO5IJR78dTB+79wHkOv3P1MT32/HauNHjL
         srCqJ1J04we7kIa/CRehf0pfnhKUq3P8aufjn9TQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.16 003/203] ima: fix reference leak in asymmetric_verify()
Date:   Mon, 14 Feb 2022 10:24:07 +0100
Message-Id: <20220214092510.337512879@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 926fd9f23b27ca6587492c3f58f4c7f4cd01dad5 upstream.

Don't leak a reference to the key if its algorithm is unknown.

Fixes: 947d70597236 ("ima: Support EC keys for signature verification")
Cc: <stable@vger.kernel.org> # v5.13+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Reviewed-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/digsig_asymmetric.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/security/integrity/digsig_asymmetric.c
+++ b/security/integrity/digsig_asymmetric.c
@@ -109,22 +109,25 @@ int asymmetric_verify(struct key *keyrin
 
 	pk = asymmetric_key_public_key(key);
 	pks.pkey_algo = pk->pkey_algo;
-	if (!strcmp(pk->pkey_algo, "rsa"))
+	if (!strcmp(pk->pkey_algo, "rsa")) {
 		pks.encoding = "pkcs1";
-	else if (!strncmp(pk->pkey_algo, "ecdsa-", 6))
+	} else if (!strncmp(pk->pkey_algo, "ecdsa-", 6)) {
 		/* edcsa-nist-p192 etc. */
 		pks.encoding = "x962";
-	else if (!strcmp(pk->pkey_algo, "ecrdsa") ||
-		   !strcmp(pk->pkey_algo, "sm2"))
+	} else if (!strcmp(pk->pkey_algo, "ecrdsa") ||
+		   !strcmp(pk->pkey_algo, "sm2")) {
 		pks.encoding = "raw";
-	else
-		return -ENOPKG;
+	} else {
+		ret = -ENOPKG;
+		goto out;
+	}
 
 	pks.digest = (u8 *)data;
 	pks.digest_size = datalen;
 	pks.s = hdr->sig;
 	pks.s_size = siglen;
 	ret = verify_signature(key, &pks);
+out:
 	key_put(key);
 	pr_debug("%s() = %d\n", __func__, ret);
 	return ret;



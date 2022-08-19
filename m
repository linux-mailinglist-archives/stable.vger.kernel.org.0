Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78F3C59A3EB
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353918AbiHSQqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354050AbiHSQpp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:45:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027B31136A0;
        Fri, 19 Aug 2022 09:11:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B2F9618B4;
        Fri, 19 Aug 2022 16:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3F7C433C1;
        Fri, 19 Aug 2022 16:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925506;
        bh=msIr613ACoa8RNgncqcEUwmzFWLHI5HcZCYvS+6nmXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fBaNxlv4OBLwYhQkpq6FeN/YEpWZ21t/KsP73Tws8bMxkYeu4ipota9TLmhOYxNU1
         sdR1MRgJSIBmpYrzs+vo7TSVneLZVLJQBglYbjwwmoYrZqx8kgTGKmm26w6es9dRCG
         7I2Q5NWmfYCOuZNFO+M0aJ+JJDPrqi1iO/nhedd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.10 513/545] KEYS: asymmetric: enforce SM2 signature use pkey algo
Date:   Fri, 19 Aug 2022 17:44:43 +0200
Message-Id: <20220819153852.457218291@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

commit 0815291a8fd66cdcf7db1445d4d99b0d16065829 upstream.

The signature verification of SM2 needs to add the Za value and
recalculate sig->digest, which requires the detection of the pkey_algo
in public_key_verify_signature(). As Eric Biggers said, the pkey_algo
field in sig is attacker-controlled and should be use pkey->pkey_algo
instead of sig->pkey_algo, and secondly, if sig->pkey_algo is NULL, it
will also cause signature verification failure.

The software_key_determine_akcipher() already forces the algorithms
are matched, so the SM3 algorithm is enforced in the SM2 signature,
although this has been checked, we still avoid using any algorithm
information in the signature as input.

Fixes: 215525639631 ("X.509: support OSCCA SM2-with-SM3 certificate verification")
Reported-by: Eric Biggers <ebiggers@google.com>
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/asymmetric_keys/public_key.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -260,6 +260,10 @@ static int cert_sig_digest_update(const
 
 	BUG_ON(!sig->data);
 
+	/* SM2 signatures always use the SM3 hash algorithm */
+	if (!sig->hash_algo || strcmp(sig->hash_algo, "sm3") != 0)
+		return -EINVAL;
+
 	ret = sm2_compute_z_digest(tfm_pkey, SM2_DEFAULT_USERID,
 					SM2_DEFAULT_USERID_LEN, dgst);
 	if (ret)
@@ -356,8 +360,7 @@ int public_key_verify_signature(const st
 	if (ret)
 		goto error_free_key;
 
-	if (sig->pkey_algo && strcmp(sig->pkey_algo, "sm2") == 0 &&
-	    sig->data_size) {
+	if (strcmp(pkey->pkey_algo, "sm2") == 0 && sig->data_size) {
 		ret = cert_sig_digest_update(sig, tfm);
 		if (ret)
 			goto error_free_key;



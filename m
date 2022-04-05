Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 495EF4F32B2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245577AbiDEKj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238891AbiDEJdC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:33:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6162ECF4;
        Tue,  5 Apr 2022 02:20:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11674B81B75;
        Tue,  5 Apr 2022 09:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFC8C385A2;
        Tue,  5 Apr 2022 09:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150434;
        bh=Utz1YvWbSMLmkIEVCdwmAdUPQ3ARE9UXbQLDcRmNtww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=09koD/JTbYXOQXStxL8zs1m9nyHJf7dih1HQWLkrviguHaQ8VKcYjTf8TDAaNJy19
         uPRDW+o6O/mekfRPf+EtybG1MMiOlYB6O57G5lq9ZCJEPRASLQvxptuJCsyBJws22J
         UdWLQJ77BGls0CYbkQXN4vC2AFjh/o16kCMOlBeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.15 055/913] KEYS: fix length validation in keyctl_pkey_params_get_2()
Date:   Tue,  5 Apr 2022 09:18:37 +0200
Message-Id: <20220405070341.470126690@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Eric Biggers <ebiggers@google.com>

commit c51abd96837f600d8fd940b6ab8e2da578575504 upstream.

In many cases, keyctl_pkey_params_get_2() is validating the user buffer
lengths against the wrong algorithm properties.  Fix it to check against
the correct properties.

Probably this wasn't noticed before because for all asymmetric keys of
the "public_key" subtype, max_data_size == max_sig_size == max_enc_size
== max_dec_size.  However, this isn't necessarily true for the
"asym_tpm" subtype (it should be, but it's not strictly validated).  Of
course, future key types could have different values as well.

Fixes: 00d60fd3b932 ("KEYS: Provide keyctls to drive the new key type ops for asymmetric keys [ver #2]")
Cc: <stable@vger.kernel.org> # v4.20+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/keyctl_pkey.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/security/keys/keyctl_pkey.c
+++ b/security/keys/keyctl_pkey.c
@@ -135,15 +135,23 @@ static int keyctl_pkey_params_get_2(cons
 
 	switch (op) {
 	case KEYCTL_PKEY_ENCRYPT:
+		if (uparams.in_len  > info.max_dec_size ||
+		    uparams.out_len > info.max_enc_size)
+			return -EINVAL;
+		break;
 	case KEYCTL_PKEY_DECRYPT:
 		if (uparams.in_len  > info.max_enc_size ||
 		    uparams.out_len > info.max_dec_size)
 			return -EINVAL;
 		break;
 	case KEYCTL_PKEY_SIGN:
+		if (uparams.in_len  > info.max_data_size ||
+		    uparams.out_len > info.max_sig_size)
+			return -EINVAL;
+		break;
 	case KEYCTL_PKEY_VERIFY:
-		if (uparams.in_len  > info.max_sig_size ||
-		    uparams.out_len > info.max_data_size)
+		if (uparams.in_len  > info.max_data_size ||
+		    uparams.in2_len > info.max_sig_size)
 			return -EINVAL;
 		break;
 	default:
@@ -151,7 +159,7 @@ static int keyctl_pkey_params_get_2(cons
 	}
 
 	params->in_len  = uparams.in_len;
-	params->out_len = uparams.out_len;
+	params->out_len = uparams.out_len; /* Note: same as in2_len */
 	return 0;
 }
 



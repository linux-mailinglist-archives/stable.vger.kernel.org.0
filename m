Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541404F2BDD
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343700AbiDEI5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235492AbiDEIjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:39:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A72DE0BC;
        Tue,  5 Apr 2022 01:33:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2820961470;
        Tue,  5 Apr 2022 08:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFFFC385A0;
        Tue,  5 Apr 2022 08:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147608;
        bh=Utz1YvWbSMLmkIEVCdwmAdUPQ3ARE9UXbQLDcRmNtww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S5OMWqFRmxc8aHMy0ke3NKB9/R2C/1iafke27AAkWM2qVy08dyFDGkmwSkERmJCuX
         ekG2A433K3w1NZTo1z9h8tdpY2HB8QLwlj72gjl8voA6ficXwBrtIv+tf0fJz1PYLH
         eMJBvJu+mKGkQWuVbOu+XwJacnEvIP3em8f0N6cU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.16 0057/1017] KEYS: fix length validation in keyctl_pkey_params_get_2()
Date:   Tue,  5 Apr 2022 09:16:10 +0200
Message-Id: <20220405070355.877315289@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
 



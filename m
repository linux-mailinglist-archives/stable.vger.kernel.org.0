Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC1612C8B7
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732452AbfL2R5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:57:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:47372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733199AbfL2R5I (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:57:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EA142253D;
        Sun, 29 Dec 2019 17:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642227;
        bh=jEwQgvnZs/5ZtXLyjpAPNphHZZTe9nE+ApMYLsLMX+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VbA8v5u4Tc4hG2Q92yZesbXXUlZEYJDjHh/1PBODyL/lkQQairnun4Xx5tP9LLWOe
         O3SgERo41NifzrfhVvOt+Up8jdkIf+PFmgIqxmhF7C0Wk/HmS6KGKEhDiqQ5Ici6T5
         Vi7EALkh44PZLjdpmcr9qUIhuPhDnc6KV8on9Nfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        James Morris <jamorris@linux.microsoft.com>,
        Eric Biggers <ebiggers@google.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 5.4 395/434] KEYS: asymmetric: return ENOMEM if akcipher_request_alloc() fails
Date:   Sun, 29 Dec 2019 18:27:28 +0100
Message-Id: <20191229172728.609690615@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit bea37414453eb08d4ceffeb60a9d490dbc930cea upstream.

No error code was being set on this error path.

Cc: stable@vger.kernel.org
Fixes: ad4b1eb5fb33 ("KEYS: asym_tpm: Implement encryption operation [ver #2]")
Fixes: c08fed737126 ("KEYS: Implement encrypt, decrypt and sign for software asymmetric key [ver #2]")
Reviewed-by: James Morris <jamorris@linux.microsoft.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/asymmetric_keys/asym_tpm.c   |    1 +
 crypto/asymmetric_keys/public_key.c |    1 +
 2 files changed, 2 insertions(+)

--- a/crypto/asymmetric_keys/asym_tpm.c
+++ b/crypto/asymmetric_keys/asym_tpm.c
@@ -486,6 +486,7 @@ static int tpm_key_encrypt(struct tpm_ke
 	if (ret < 0)
 		goto error_free_tfm;
 
+	ret = -ENOMEM;
 	req = akcipher_request_alloc(tfm, GFP_KERNEL);
 	if (!req)
 		goto error_free_tfm;
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -184,6 +184,7 @@ static int software_key_eds_op(struct ke
 	if (IS_ERR(tfm))
 		return PTR_ERR(tfm);
 
+	ret = -ENOMEM;
 	req = akcipher_request_alloc(tfm, GFP_KERNEL);
 	if (!req)
 		goto error_free_tfm;



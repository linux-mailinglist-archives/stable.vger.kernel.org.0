Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A36409103
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245586AbhIMN5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:57:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343569AbhIMNzk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:55:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28CDA619A6;
        Mon, 13 Sep 2021 13:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540141;
        bh=uPKHFJqu3rTSPQzxnPEi0qkx4KPNse7MlsqU42wUxWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oKHyv923wG2LZxQv0av6hryO05nB6RjVbSAd+FxBw2kVnzhOl7ul5pmPhksQJAYew
         NHkVi7E+8tpjWdYv+YlWyXcKggkkRVJEFUszmTLPqKZoJKOZvuzdxvDEV7mda359h/
         T/csbhPibtxgA1NVX/UsiUJs/GNCbzajN6PlkjtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 069/300] certs: Trigger creation of RSA module signing key if its not an RSA key
Date:   Mon, 13 Sep 2021 15:12:10 +0200
Message-Id: <20210913131111.690051566@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Berger <stefanb@linux.ibm.com>

[ Upstream commit ea35e0d5df6c92fa2e124bb1b91d09b2240715ba ]

Address a kbuild issue where a developer created an ECDSA key for signing
kernel modules and then builds an older version of the kernel, when bi-
secting the kernel for example, that does not support ECDSA keys.

If openssl is installed, trigger the creation of an RSA module signing
key if it is not an RSA key.

Fixes: cfc411e7fff3 ("Move certificate handling to its own directory")
Cc: David Howells <dhowells@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 certs/Makefile | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/certs/Makefile b/certs/Makefile
index 359239a0ee9e..f9344e52ecda 100644
--- a/certs/Makefile
+++ b/certs/Makefile
@@ -57,11 +57,19 @@ endif
 redirect_openssl	= 2>&1
 quiet_redirect_openssl	= 2>&1
 silent_redirect_openssl = 2>/dev/null
+openssl_available       = $(shell openssl help 2>/dev/null && echo yes)
 
 # We do it this way rather than having a boolean option for enabling an
 # external private key, because 'make randconfig' might enable such a
 # boolean option and we unfortunately can't make it depend on !RANDCONFIG.
 ifeq ($(CONFIG_MODULE_SIG_KEY),"certs/signing_key.pem")
+
+ifeq ($(openssl_available),yes)
+X509TEXT=$(shell openssl x509 -in "certs/signing_key.pem" -text 2>/dev/null)
+
+$(if $(findstring rsaEncryption,$(X509TEXT)),,$(shell rm -f "certs/signing_key.pem"))
+endif
+
 $(obj)/signing_key.pem: $(obj)/x509.genkey
 	@$(kecho) "###"
 	@$(kecho) "### Now generating an X.509 key pair to be used for signing modules."
-- 
2.30.2




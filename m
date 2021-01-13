Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB6512F4C03
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 14:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbhAMNHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 08:07:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21168 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725899AbhAMNHh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 08:07:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610543171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+3M69g05v+W82UKg6HPFUpIhTfWlraoP91TJmQGhmD0=;
        b=AYYJpOkB8hIv+eB8vuqwbq5/dFKHjOn5iAWmAiQ6KM2eqmH8nz8T+8a5SmBjCBlL9Xx3Pn
        Kmf055LdPOT+m83wXeU4ry5QAKRR7g7NWLnThDfw6Z43+BF/iZKCf/Ye0oc/bsqcOc3OWU
        6vEMIaGfPLdg3SUOn3DHR88FkPElb5Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-5ZHYiINjM0iq8oINTpHbcg-1; Wed, 13 Jan 2021 08:06:07 -0500
X-MC-Unique: 5ZHYiINjM0iq8oINTpHbcg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C478D107ACF7;
        Wed, 13 Jan 2021 13:06:05 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-8.rdu2.redhat.com [10.10.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E55F65E1A4;
        Wed, 13 Jan 2021 13:06:03 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] X.509: Fix crash caused by NULL pointer
From:   David Howells <dhowells@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     Tobias Markus <tobias@markus-regensburg.de>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        dhowells@redhat.com, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 13 Jan 2021 13:06:03 +0000
Message-ID: <161054316298.2657535.1498909560459842920.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

On the following call path, `sig->pkey_algo` is not assigned
in asymmetric_key_verify_signature(), which causes runtime
crash in public_key_verify_signature().

  keyctl_pkey_verify
    asymmetric_key_verify_signature
      verify_signature
        public_key_verify_signature

This patch simply check this situation and fixes the crash
caused by NULL pointer.

Fixes: 215525639631 ("X.509: support OSCCA SM2-with-SM3 certificate verification")
Reported-by: Tobias Markus <tobias@markus-regensburg.de>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-and-tested-by: Toke Høiland-Jørgensen <toke@redhat.com>
---

 crypto/asymmetric_keys/public_key.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 8892908ad58c..788a4ba1e2e7 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -356,7 +356,8 @@ int public_key_verify_signature(const struct public_key *pkey,
 	if (ret)
 		goto error_free_key;
 
-	if (strcmp(sig->pkey_algo, "sm2") == 0 && sig->data_size) {
+	if (sig->pkey_algo && strcmp(sig->pkey_algo, "sm2") == 0 &&
+	    sig->data_size) {
 		ret = cert_sig_digest_update(sig, tfm);
 		if (ret)
 			goto error_free_key;



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BA0300632
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbhAVOyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:54:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:40268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728635AbhAVOXu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:23:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E728B23A68;
        Fri, 22 Jan 2021 14:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325115;
        bh=DmsPhg0OEX5ppmplaFBzriM5/AiWqaIk2BePzYZz6r0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=irpm26d9ccn3KVjxXyMlbgg0TTz6fBSjClIwwelzfN9g6r/D7RcygbqZ+8lkpHqpH
         gFHObBJRyn06cumdKn3r/eR2fnASBI/yohDjLxDPEvn0yeM8eHJ07d1w/c5YGctnkC
         bW+00Njs3xw3wEe9nNoNS0vQmRPTG9Z5BcAOGdNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tobias Markus <tobias@markus-regensburg.de>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        David Howells <dhowells@redhat.com>,
        =?UTF-8?q?Jo=C3=A3o=20Fonseca?= <jpedrofonseca@ua.pt>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH 5.10 06/43] X.509: Fix crash caused by NULL pointer
Date:   Fri, 22 Jan 2021 15:12:22 +0100
Message-Id: <20210122135735.910313266@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

commit 7178a107f5ea7bdb1cc23073234f0ded0ef90ec7 upstream.

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
Tested-by: João Fonseca <jpedrofonseca@ua.pt>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/asymmetric_keys/public_key.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -356,7 +356,8 @@ int public_key_verify_signature(const st
 	if (ret)
 		goto error_free_key;
 
-	if (strcmp(sig->pkey_algo, "sm2") == 0 && sig->data_size) {
+	if (sig->pkey_algo && strcmp(sig->pkey_algo, "sm2") == 0 &&
+	    sig->data_size) {
 		ret = cert_sig_digest_update(sig, tfm);
 		if (ret)
 			goto error_free_key;



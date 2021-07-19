Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB4A83CDC7E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239213AbhGSOwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:52:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344654AbhGSOtF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:49:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F021C6023D;
        Mon, 19 Jul 2021 15:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708584;
        bh=dKLrO+xo1aBWWQxX/DvRadtLLEsKsx7tONAuEVUq0JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TrNZ2GLXSTdJRpQRjfICR5MTImvJiWL0lb9Bya2um1yu9m7goSUktX2x4j4pZy6bM
         DqtGdbyBuonXz/14PH3AY+Y8OWgULUz5lJ3bA0ou4e/OLVSHJn0aUCSlJoPTLww9qO
         IY2jsdr7B+c+U23WNUes7XWvYYSAp9cELkoOQ550=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 4.19 049/421] evm: Refuse EVM_ALLOW_METADATA_WRITES only if an HMAC key is loaded
Date:   Mon, 19 Jul 2021 16:47:40 +0200
Message-Id: <20210719144947.921329756@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 9acc89d31f0c94c8e573ed61f3e4340bbd526d0c upstream.

EVM_ALLOW_METADATA_WRITES is an EVM initialization flag that can be set to
temporarily disable metadata verification until all xattrs/attrs necessary
to verify an EVM portable signature are copied to the file. This flag is
cleared when EVM is initialized with an HMAC key, to avoid that the HMAC is
calculated on unverified xattrs/attrs.

Currently EVM unnecessarily denies setting this flag if EVM is initialized
with a public key, which is not a concern as it cannot be used to trust
xattrs/attrs updates. This patch removes this limitation.

Fixes: ae1ba1676b88e ("EVM: Allow userland to permit modification of EVM-protected metadata")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Cc: stable@vger.kernel.org # 4.16.x
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/ABI/testing/evm      |   26 ++++++++++++++++++++++++--
 security/integrity/evm/evm_secfs.c |    8 ++++----
 2 files changed, 28 insertions(+), 6 deletions(-)

--- a/Documentation/ABI/testing/evm
+++ b/Documentation/ABI/testing/evm
@@ -42,8 +42,30 @@ Description:
 		modification of EVM-protected metadata and
 		disable all further modification of policy
 
-		Note that once a key has been loaded, it will no longer be
-		possible to enable metadata modification.
+		Echoing a value is additive, the new value is added to the
+		existing initialization flags.
+
+		For example, after::
+
+		  echo 2 ><securityfs>/evm
+
+		another echo can be performed::
+
+		  echo 1 ><securityfs>/evm
+
+		and the resulting value will be 3.
+
+		Note that once an HMAC key has been loaded, it will no longer
+		be possible to enable metadata modification. Signaling that an
+		HMAC key has been loaded will clear the corresponding flag.
+		For example, if the current value is 6 (2 and 4 set)::
+
+		  echo 1 ><securityfs>/evm
+
+		will set the new value to 3 (4 cleared).
+
+		Loading an HMAC key is the only way to disable metadata
+		modification.
 
 		Until key loading has been signaled EVM can not create
 		or validate the 'security.evm' xattr, but returns
--- a/security/integrity/evm/evm_secfs.c
+++ b/security/integrity/evm/evm_secfs.c
@@ -85,12 +85,12 @@ static ssize_t evm_write_key(struct file
 	if (!i || (i & ~EVM_INIT_MASK) != 0)
 		return -EINVAL;
 
-	/* Don't allow a request to freshly enable metadata writes if
-	 * keys are loaded.
+	/*
+	 * Don't allow a request to enable metadata writes if
+	 * an HMAC key is loaded.
 	 */
 	if ((i & EVM_ALLOW_METADATA_WRITES) &&
-	    ((evm_initialized & EVM_KEY_MASK) != 0) &&
-	    !(evm_initialized & EVM_ALLOW_METADATA_WRITES))
+	    (evm_initialized & EVM_INIT_HMAC) != 0)
 		return -EPERM;
 
 	if (i & EVM_INIT_HMAC) {



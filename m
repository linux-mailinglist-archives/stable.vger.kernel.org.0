Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C426D2A16FC
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgJaLtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:49:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727150AbgJaLnF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:43:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5BAA205F4;
        Sat, 31 Oct 2020 11:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144585;
        bh=Dmx4856aMDF3NR3IzuQtcn7Pcfi9Y6BrCatuOiMQszA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQdqR/Qg0OBAEFH1kTKYR/sl9A/38w1binMbBXHuPftmxujv0/fLiMXHQnuM2pkgS
         tbZ7XsdufPgahijTmhWFATV+YGcdJqqKGeJBE2M2NKq05bR/vh1pWtrMK0hjysfghG
         Bwe/38dSaVWpHR/liP560Nc2RVthzSiErGUz80Io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.8 57/70] evm: Check size of security.evm before using it
Date:   Sat, 31 Oct 2020 12:36:29 +0100
Message-Id: <20201031113502.229354143@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 455b6c9112eff8d249e32ba165742085678a80a4 upstream.

This patch checks the size for the EVM_IMA_XATTR_DIGSIG and
EVM_XATTR_PORTABLE_DIGSIG types to ensure that the algorithm is read from
the buffer returned by vfs_getxattr_alloc().

Cc: stable@vger.kernel.org # 4.19.x
Fixes: 5feeb61183dde ("evm: Allow non-SHA1 digital signatures")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/integrity/evm/evm_main.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -181,6 +181,12 @@ static enum integrity_status evm_verify_
 		break;
 	case EVM_IMA_XATTR_DIGSIG:
 	case EVM_XATTR_PORTABLE_DIGSIG:
+		/* accept xattr with non-empty signature field */
+		if (xattr_len <= sizeof(struct signature_v2_hdr)) {
+			evm_status = INTEGRITY_FAIL;
+			goto out;
+		}
+
 		hdr = (struct signature_v2_hdr *)xattr_data;
 		digest.hdr.algo = hdr->hash_algo;
 		rc = evm_calc_hash(dentry, xattr_name, xattr_value,



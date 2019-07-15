Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3ECB68CD0
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 15:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732453AbfGONx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732442AbfGONx4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:53:56 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84E202067C;
        Mon, 15 Jul 2019 13:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198835;
        bh=GvqaO8Hfj0YZ4S9SDbciSuBjpZBuybUg36GS1rxr7mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=087873uw/4BcCTV1ksCIXhcvEYHZ5cSdi2/TQpoj+Ay3oxWF4d3odiOP7e2RRjAdy
         v7w7XZo8YMPTM1A1ZvE8tjTzGdNM1+AlqioSbgVw45Di9OqV4Vwczu4Sha/JjQ2IEC
         Xoou+WcOsOhG3DVTK+hC+/Ip8/JJMxqskwLdjiZA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 116/249] integrity: Fix __integrity_init_keyring() section mismatch
Date:   Mon, 15 Jul 2019 09:44:41 -0400
Message-Id: <20190715134655.4076-116-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 8c655784e2cf59cb6140759b8b546d98261d1ad9 ]

With gcc-4.6.3:

    WARNING: vmlinux.o(.text.unlikely+0x24c64): Section mismatch in reference from the function __integrity_init_keyring() to the function .init.text:set_platform_trusted_keys()
    The function __integrity_init_keyring() references
    the function __init set_platform_trusted_keys().
    This is often because __integrity_init_keyring lacks a __init
    annotation or the annotation of set_platform_trusted_keys is wrong.

Indeed, if the compiler decides not to inline __integrity_init_keyring(),
a warning is issued.

Fix this by adding the missing __init annotation.

Fixes: 9dc92c45177ab70e ("integrity: Define a trusted platform keyring")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Nayna Jain <nayna@linux.ibm.com>
Reviewed-by: James Morris <jamorris@linux.microsoft.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/digsig.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index 4582bc26770a..868ade3e8970 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -69,8 +69,9 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 	return -EOPNOTSUPP;
 }
 
-static int __integrity_init_keyring(const unsigned int id, key_perm_t perm,
-				    struct key_restriction *restriction)
+static int __init __integrity_init_keyring(const unsigned int id,
+					   key_perm_t perm,
+					   struct key_restriction *restriction)
 {
 	const struct cred *cred = current_cred();
 	int err = 0;
-- 
2.20.1


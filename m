Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D22A3C4D61
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241838AbhGLHM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:12:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244224AbhGLHKb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:10:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D68956052B;
        Mon, 12 Jul 2021 07:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073633;
        bh=rLva9fMDKvriGK2gKoaPkMiCSro8/+SWf590MWO1T18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QeVFkgg7NZoY7VCodjkxd544EcNi9wAYtce9qZ9/0h3u71irQm2aj8CHZyDlsySi0
         bg/viGq21SjumlZLHNoptb95U8ZSQhTHrh2M5v+8+ZlvR37Q7ubm5/RITsDB2uQJds
         yBj9eElcbRfLlexoXJolHmaUYJ9PigxmzvO/As7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 264/700] evm: fix writing <securityfs>/evm overflow
Date:   Mon, 12 Jul 2021 08:05:47 +0200
Message-Id: <20210712061004.287297169@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mimi Zohar <zohar@linux.ibm.com>

[ Upstream commit 49219d9b8785ba712575c40e48ce0f7461254626 ]

EVM_SETUP_COMPLETE is defined as 0x80000000, which is larger than INT_MAX.
The "-fno-strict-overflow" compiler option properly prevents signaling
EVM that the EVM policy setup is complete.  Define and read an unsigned
int.

Fixes: f00d79750712 ("EVM: Allow userspace to signal an RSA key has been loaded")
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/evm/evm_secfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/security/integrity/evm/evm_secfs.c b/security/integrity/evm/evm_secfs.c
index c175e2b659e4..5f0da41bccd0 100644
--- a/security/integrity/evm/evm_secfs.c
+++ b/security/integrity/evm/evm_secfs.c
@@ -66,12 +66,13 @@ static ssize_t evm_read_key(struct file *filp, char __user *buf,
 static ssize_t evm_write_key(struct file *file, const char __user *buf,
 			     size_t count, loff_t *ppos)
 {
-	int i, ret;
+	unsigned int i;
+	int ret;
 
 	if (!capable(CAP_SYS_ADMIN) || (evm_initialized & EVM_SETUP_COMPLETE))
 		return -EPERM;
 
-	ret = kstrtoint_from_user(buf, count, 0, &i);
+	ret = kstrtouint_from_user(buf, count, 0, &i);
 
 	if (ret)
 		return ret;
-- 
2.30.2




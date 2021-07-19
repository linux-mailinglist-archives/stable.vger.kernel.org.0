Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD193CDCE7
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237287AbhGSOyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:54:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242445AbhGSOvg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:51:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 686EE6113B;
        Mon, 19 Jul 2021 15:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708716;
        bh=0SqX6GCOY/2fR2HdgpJjGq1oD/9hBS08h1d7helaRyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0z2LMjSr1w7MgKavqTy/Jcw34znjL3flfnsjwVaqXfuxMQozVOcTGi8hAdZEsi8nd
         ARfTgb+LPpjQxNNu6mjER3oWf5T1TwcXqGYVK1rc68fJ/OeZUOsCotbbfuVXhb+Vja
         hC17LIuA0YbeyDYsNp4r/R38eaMRjD5nblKcPu9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 101/421] evm: fix writing <securityfs>/evm overflow
Date:   Mon, 19 Jul 2021 16:48:32 +0200
Message-Id: <20210719144950.110283837@linuxfoundation.org>
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
index 7024b14831e3..c5c44203a59c 100644
--- a/security/integrity/evm/evm_secfs.c
+++ b/security/integrity/evm/evm_secfs.c
@@ -71,12 +71,13 @@ static ssize_t evm_read_key(struct file *filp, char __user *buf,
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB12A3C48B8
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235924AbhGLGkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238236AbhGLGkC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:40:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A60DB6113C;
        Mon, 12 Jul 2021 06:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071798;
        bh=guxg2+eufG9UDUPphOeUcEP+twLiF/YRaELhSaqYqzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5qdKua/CEF0X0KEuXKAHVacE/3ZWeFy5dElTNQ6jDTvUnsPahn6/f8/iO6L+XYmQ
         1FN20s8LX2zVVZW+vw8lvZOdvL9KJwhRKcoxP8DWbm5IkNT2SqM1S2m5FFlhgKKmrJ
         86w71/C622gszWOQxYSSxSr3rRJEoBwnM/gqoEVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 224/593] evm: fix writing <securityfs>/evm overflow
Date:   Mon, 12 Jul 2021 08:06:24 +0200
Message-Id: <20210712060907.586591539@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index a7042ae90b9e..bc10c945f3ed 100644
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




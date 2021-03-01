Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15380328849
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238734AbhCARiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:38:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:54072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237891AbhCAR3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:29:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71D0365090;
        Mon,  1 Mar 2021 16:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617489;
        bh=r6wTBbpVmJdI+L3cNw533nUGzoxGwCL4V5i6XU8EssA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ytwah8GLtPQeWi/X/EgUDBiPUlMOP3Hk4YQNNCqefKl6tWlsRCNubKWVbRJeHNJGv
         uVjr/LbxUoobzxb/2biCxraQDzNRjG8/ICg39sQyHg1lRGZe8xOzrdU+fLlzruBx5m
         vv/hP2CHz+sx9HOOgdSdBYzzsSoptMArBr7Ct3zE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/340] crypto: bcm - Rename struct device_private to bcm_device_private
Date:   Mon,  1 Mar 2021 17:10:35 +0100
Message-Id: <20210301161052.803999107@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit f7f2b43eaf6b4cfe54c75100709be31d5c4b52c8 ]

Renaming 'struct device_private' to 'struct bcm_device_private',
because it clashes with 'struct device_private' from
'drivers/base/base.h'.

While it's not a functional problem, it's causing two distinct
type hierarchies in BTF data. It also breaks build with options:
  CONFIG_DEBUG_INFO_BTF=y
  CONFIG_CRYPTO_DEV_BCM_SPU=y

as reported by Qais Yousef [1].

[1] https://lore.kernel.org/lkml/20201229151352.6hzmjvu3qh6p2qgg@e107158-lin/

Fixes: 9d12ba86f818 ("crypto: brcm - Add Broadcom SPU driver")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/bcm/cipher.c | 2 +-
 drivers/crypto/bcm/cipher.h | 4 ++--
 drivers/crypto/bcm/util.c   | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index ec4b5033013eb..98b8483577ce2 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -41,7 +41,7 @@
 
 /* ================= Device Structure ================== */
 
-struct device_private iproc_priv;
+struct bcm_device_private iproc_priv;
 
 /* ==================== Parameters ===================== */
 
diff --git a/drivers/crypto/bcm/cipher.h b/drivers/crypto/bcm/cipher.h
index 766452b24d0ab..01feed268a0d4 100644
--- a/drivers/crypto/bcm/cipher.h
+++ b/drivers/crypto/bcm/cipher.h
@@ -418,7 +418,7 @@ struct spu_hw {
 	u32 num_chan;
 };
 
-struct device_private {
+struct bcm_device_private {
 	struct platform_device *pdev;
 
 	struct spu_hw spu;
@@ -465,6 +465,6 @@ struct device_private {
 	struct mbox_chan **mbox;
 };
 
-extern struct device_private iproc_priv;
+extern struct bcm_device_private iproc_priv;
 
 #endif
diff --git a/drivers/crypto/bcm/util.c b/drivers/crypto/bcm/util.c
index cd7504101acde..7227dbf8f46c7 100644
--- a/drivers/crypto/bcm/util.c
+++ b/drivers/crypto/bcm/util.c
@@ -348,7 +348,7 @@ char *spu_alg_name(enum spu_cipher_alg alg, enum spu_cipher_mode mode)
 static ssize_t spu_debugfs_read(struct file *filp, char __user *ubuf,
 				size_t count, loff_t *offp)
 {
-	struct device_private *ipriv;
+	struct bcm_device_private *ipriv;
 	char *buf;
 	ssize_t ret, out_offset, out_count;
 	int i;
-- 
2.27.0




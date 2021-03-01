Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45ECC328F9B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242383AbhCATxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:53:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:55184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242311AbhCATo3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:44:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E63165316;
        Mon,  1 Mar 2021 17:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620591;
        bh=01hc1qzVN40yBblDOo6s5Modw8MJb+MRClR0CBk5ono=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zLzQc0J4SayRU7KWkU+7tdeMGEwnEHm63Q20JhjZbcYzxf2zDhBLLlCWiDAXiwNhB
         SEcrHna6OfNb+GV7wqXJKLvBDtdx5CfzaIr0d7s+4LdLUGmF3Xyj+leE18ZlU9mC07
         iU1DUu96XX8UNHeLOBJmqCi762i7ZrWBMkk+he1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 209/775] crypto: bcm - Rename struct device_private to bcm_device_private
Date:   Mon,  1 Mar 2021 17:06:17 +0100
Message-Id: <20210301161211.968744688@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index 30390a7324b29..0e5537838ef36 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -42,7 +42,7 @@
 
 /* ================= Device Structure ================== */
 
-struct device_private iproc_priv;
+struct bcm_device_private iproc_priv;
 
 /* ==================== Parameters ===================== */
 
diff --git a/drivers/crypto/bcm/cipher.h b/drivers/crypto/bcm/cipher.h
index 0ad5892b445d3..71281a3bdbdc0 100644
--- a/drivers/crypto/bcm/cipher.h
+++ b/drivers/crypto/bcm/cipher.h
@@ -420,7 +420,7 @@ struct spu_hw {
 	u32 num_chan;
 };
 
-struct device_private {
+struct bcm_device_private {
 	struct platform_device *pdev;
 
 	struct spu_hw spu;
@@ -467,6 +467,6 @@ struct device_private {
 	struct mbox_chan **mbox;
 };
 
-extern struct device_private iproc_priv;
+extern struct bcm_device_private iproc_priv;
 
 #endif
diff --git a/drivers/crypto/bcm/util.c b/drivers/crypto/bcm/util.c
index 2b304fc780595..77aeedb840555 100644
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




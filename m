Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C7D32867A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237336AbhCARLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:11:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:35318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236634AbhCAREW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:04:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B852E64FF2;
        Mon,  1 Mar 2021 16:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616767;
        bh=emunZBCISOcNBMjLqPn11XryqXmHG4IAB/zp9kEoUrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sMViukeuSEka/pI+VK+YUQd5QNqIpgT5TLips11Cgt7sHiNECUeEgNwe9twjbPPB4
         pxcJ21YgHMKz8UzqYlNPkzFXVM7tm2iY0T8Ntgta2IMo93gRjsrqbs0espF63Qxn4i
         r29l8hSvoUxxRuYjmSnDdJtMwn48scJaAKxkRAeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 087/247] crypto: bcm - Rename struct device_private to bcm_device_private
Date:   Mon,  1 Mar 2021 17:11:47 +0100
Message-Id: <20210301161035.940401803@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
index c2736274ad634..c63992fbbc988 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -52,7 +52,7 @@
 
 /* ================= Device Structure ================== */
 
-struct device_private iproc_priv;
+struct bcm_device_private iproc_priv;
 
 /* ==================== Parameters ===================== */
 
diff --git a/drivers/crypto/bcm/cipher.h b/drivers/crypto/bcm/cipher.h
index 763c425c41cae..36452d26c7c5c 100644
--- a/drivers/crypto/bcm/cipher.h
+++ b/drivers/crypto/bcm/cipher.h
@@ -431,7 +431,7 @@ struct spu_hw {
 	u32 num_chan;
 };
 
-struct device_private {
+struct bcm_device_private {
 	struct platform_device *pdev;
 
 	struct spu_hw spu;
@@ -478,6 +478,6 @@ struct device_private {
 	struct mbox_chan **mbox;
 };
 
-extern struct device_private iproc_priv;
+extern struct bcm_device_private iproc_priv;
 
 #endif
diff --git a/drivers/crypto/bcm/util.c b/drivers/crypto/bcm/util.c
index a912c6ad3e850..f96d1dade010a 100644
--- a/drivers/crypto/bcm/util.c
+++ b/drivers/crypto/bcm/util.c
@@ -400,7 +400,7 @@ char *spu_alg_name(enum spu_cipher_alg alg, enum spu_cipher_mode mode)
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




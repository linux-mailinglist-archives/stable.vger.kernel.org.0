Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00B60D25D8
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387833AbfJJIjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:39:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387796AbfJJIjR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:39:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2636621920;
        Thu, 10 Oct 2019 08:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696756;
        bh=VRTYunhUV9afr/tTCD6DJ8MgAzp+H1ZkWoEb2EMleVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZjkaaOlUfO48vj4nCCNmMprqCG0tflfntR5jrhNfkth0esSEqm8N7BFFpsGX+ppYm
         ct6ExSegNWp0x3Aj5EBAs/lJGhFoRrs20go9qIhk754k2eMUblBn44It29E5xM84vK
         bRX63s+8MjEY6nMjotph4anS4llnO17hHFJ/eTNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.3 042/148] crypto: cavium/zip - Add missing single_release()
Date:   Thu, 10 Oct 2019 10:35:03 +0200
Message-Id: <20191010083613.686679057@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

commit c552ffb5c93d9d65aaf34f5f001c4e7e8484ced1 upstream.

When using single_open() for opening, single_release() should be
used instead of seq_release(), otherwise there is a memory leak.

Fixes: 09ae5d37e093 ("crypto: zip - Add Compression/Decompression statistics")
Cc: <stable@vger.kernel.org>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/cavium/zip/zip_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/crypto/cavium/zip/zip_main.c
+++ b/drivers/crypto/cavium/zip/zip_main.c
@@ -593,6 +593,7 @@ static const struct file_operations zip_
 	.owner = THIS_MODULE,
 	.open  = zip_stats_open,
 	.read  = seq_read,
+	.release = single_release,
 };
 
 static int zip_clear_open(struct inode *inode, struct file *file)
@@ -604,6 +605,7 @@ static const struct file_operations zip_
 	.owner = THIS_MODULE,
 	.open  = zip_clear_open,
 	.read  = seq_read,
+	.release = single_release,
 };
 
 static int zip_regs_open(struct inode *inode, struct file *file)
@@ -615,6 +617,7 @@ static const struct file_operations zip_
 	.owner = THIS_MODULE,
 	.open  = zip_regs_open,
 	.read  = seq_read,
+	.release = single_release,
 };
 
 /* Root directory for thunderx_zip debugfs entry */



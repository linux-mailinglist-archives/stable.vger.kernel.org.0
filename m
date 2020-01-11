Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77EA8137D23
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 10:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbgAKJyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 04:54:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:41862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728810AbgAKJyB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 04:54:01 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FD9220848;
        Sat, 11 Jan 2020 09:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736441;
        bh=NOONUvF9kJjBxTEf6adfuyqO6k9ELW7UnMqCWQbJMCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+ScUM3v++cjowhU5JB9hX/lEbfvzXOt2SnitZPMUwLspl2f3tjsD42UhYjiI9CBx
         0aaSqIY6ork4LJgiZPcGJs81MK4f34qP6JEcolK0JnyejtaqmbguMyiCf3MwFWQTeE
         q6rBDp6RhcBKz+MuQMtuFR3atkusOPG0wVb0ChyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Lukas Wunner <lukas@wunner.de>, Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.4 18/59] dmaengine: Fix access to uninitialized dma_slave_caps
Date:   Sat, 11 Jan 2020 10:49:27 +0100
Message-Id: <20200111094842.443057321@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094835.417654274@linuxfoundation.org>
References: <20200111094835.417654274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 53a256a9b925b47c7e67fc1f16ca41561a7b877c upstream.

dmaengine_desc_set_reuse() allocates a struct dma_slave_caps on the
stack, populates it using dma_get_slave_caps() and then accesses one
of its members.

However dma_get_slave_caps() may fail and this isn't accounted for,
leading to a legitimate warning of gcc-4.9 (but not newer versions):

   In file included from drivers/spi/spi-bcm2835.c:19:0:
   drivers/spi/spi-bcm2835.c: In function 'dmaengine_desc_set_reuse':
>> include/linux/dmaengine.h:1370:10: warning: 'caps.descriptor_reuse' is used uninitialized in this function [-Wuninitialized]
     if (caps.descriptor_reuse) {

Fix it, thereby also silencing the gcc-4.9 warning.

The issue has been present for 4 years but surfaces only now that
the first caller of dmaengine_desc_set_reuse() has been added in
spi-bcm2835.c. Another user of reusable DMA descriptors has existed
for a while in pxa_camera.c, but it sets the DMA_CTRL_REUSE flag
directly instead of calling dmaengine_desc_set_reuse(). Nevertheless,
tag this commit for stable in case there are out-of-tree users.

Fixes: 272420214d26 ("dmaengine: Add DMA_CTRL_REUSE")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v4.3+
Link: https://lore.kernel.org/r/ca92998ccc054b4f2bfd60ef3adbab2913171eac.1575546234.git.lukas@wunner.de
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/dmaengine.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -1207,8 +1207,11 @@ static inline int dma_get_slave_caps(str
 static inline int dmaengine_desc_set_reuse(struct dma_async_tx_descriptor *tx)
 {
 	struct dma_slave_caps caps;
+	int ret;
 
-	dma_get_slave_caps(tx->chan, &caps);
+	ret = dma_get_slave_caps(tx->chan, &caps);
+	if (ret)
+		return ret;
 
 	if (caps.descriptor_reuse) {
 		tx->flags |= DMA_CTRL_REUSE;



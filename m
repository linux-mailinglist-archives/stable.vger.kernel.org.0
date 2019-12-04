Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9EC1128F1
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 11:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbfLDKKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 05:10:15 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38023 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbfLDKKP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 05:10:15 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1icRbp-0006Wr-D3; Wed, 04 Dec 2019 11:10:13 +0100
Received: from sha by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1icRbp-0006lF-00; Wed, 04 Dec 2019 11:10:13 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-mtd@lists.infradead.org
Cc:     Richard Weinberger <richard@nod.at>, kernel@pengutronix.de,
        Sascha Hauer <s.hauer@pengutronix.de>, stable@vger.kernel.org,
        Naga Sureshkumar Relli <nagasure@xilinx.com>
Subject: [PATCH] ubifs: Fix wrong memory allocation
Date:   Wed,  4 Dec 2019 11:09:58 +0100
Message-Id: <20191204100958.19938-1-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In create_default_filesystem() when we allocate the idx node we must use
the idx_node_size we calculated just one line before, not tmp, which
contains completely other data.

Fixes: c4de6d7e4319 ("ubifs: Refactor create_default_filesystem()")
Cc: stable@vger.kernel.org # v4.20+
Reported-by: Naga Sureshkumar Relli <nagasure@xilinx.com>
Tested-by: Naga Sureshkumar Relli <nagasure@xilinx.com>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 fs/ubifs/sb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ubifs/sb.c b/fs/ubifs/sb.c
index 2b7c04bf8983..17c90dff7266 100644
--- a/fs/ubifs/sb.c
+++ b/fs/ubifs/sb.c
@@ -161,7 +161,7 @@ static int create_default_filesystem(struct ubifs_info *c)
 	sup = kzalloc(ALIGN(UBIFS_SB_NODE_SZ, c->min_io_size), GFP_KERNEL);
 	mst = kzalloc(c->mst_node_alsz, GFP_KERNEL);
 	idx_node_size = ubifs_idx_node_sz(c, 1);
-	idx = kzalloc(ALIGN(tmp, c->min_io_size), GFP_KERNEL);
+	idx = kzalloc(ALIGN(idx_node_size, c->min_io_size), GFP_KERNEL);
 	ino = kzalloc(ALIGN(UBIFS_INO_NODE_SZ, c->min_io_size), GFP_KERNEL);
 	cs = kzalloc(ALIGN(UBIFS_CS_NODE_SZ, c->min_io_size), GFP_KERNEL);
 
-- 
2.24.0


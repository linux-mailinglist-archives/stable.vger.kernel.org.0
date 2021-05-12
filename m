Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59A237C428
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbhELP3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:29:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233684AbhELPWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:22:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE326619AA;
        Wed, 12 May 2021 15:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832163;
        bh=sBEwm+uHlyVNF45BaxNuJHaixHJpYJV7yDlSlaGqhwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dQ9A+MkVgiRO9R5+YMbQfjWk/dkz4LX5F78QN2qBL1z3dXAuFCPYcRQmmb95L1gcE
         gBkjiYRk5mPC5q/wqwV2LDXsoWClflRDe2rDq1uGKZa38I+Wa+VAfpoZkQPk7KhNak
         sktSY4U/3nN55ngZ/0qPNQq5r4LB4IYPWvo5aVZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 167/530] devtmpfs: fix placement of complete() call
Date:   Wed, 12 May 2021 16:44:37 +0200
Message-Id: <20210512144825.326123199@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

[ Upstream commit 38f087de8947700d3b06d3d1594490e0f611c5d1 ]

Calling complete() from within the __init function is wrong -
theoretically, the init process could proceed all the way to freeing
the init mem before the devtmpfsd thread gets to execute the return
instruction in devtmpfs_setup().

In practice, it seems to be harmless as gcc inlines devtmpfs_setup()
into devtmpfsd(). So the calls of the __init functions init_chdir()
etc. actually happen from devtmpfs_setup(), but the __ref on that one
silences modpost (it's all right, because those calls happen before
the complete()). But it does make the __init annotation of the setup
function moot, which we'll fix in a subsequent patch.

Fixes: bcbacc4909f1 ("devtmpfs: refactor devtmpfsd()")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Link: https://lore.kernel.org/r/20210312103027.2701413-1-linux@rasmusvillemoes.dk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/devtmpfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index eac184e6d657..a71d14117943 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -416,7 +416,6 @@ static int __init devtmpfs_setup(void *p)
 	init_chroot(".");
 out:
 	*(int *)p = err;
-	complete(&setup_done);
 	return err;
 }
 
@@ -429,6 +428,7 @@ static int __ref devtmpfsd(void *p)
 {
 	int err = devtmpfs_setup(p);
 
+	complete(&setup_done);
 	if (err)
 		return err;
 	devtmpfs_work_loop();
-- 
2.30.2




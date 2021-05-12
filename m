Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC0B37CC0A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241919AbhELQj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:39:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235902AbhELQcO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:32:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9916861107;
        Wed, 12 May 2021 15:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835113;
        bh=0vI9HVHUZLdAeqwj9RGj/+rSjzHBRRXnRRmJjFn913Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QAI/Fin6Qz2mImrnNHKQMw7bkehDShRMB8+72Pn/+Cp7YDIiMP0dJ1uTyK6T4c71i
         Xog2gbLia4tctAnldQD62sd+B8e3ABcu/PxSkFiDVvf8fKImqrmOq90tLVMs4GhlKi
         tlhpi6FnlsTn/2xDDVrpIOgxu1N6gtoVdJ2h7nCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 213/677] devtmpfs: fix placement of complete() call
Date:   Wed, 12 May 2021 16:44:19 +0200
Message-Id: <20210512144844.315836325@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index 653c8c6ac7a7..aedeb2dc1a18 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -419,7 +419,6 @@ static int __init devtmpfs_setup(void *p)
 	init_chroot(".");
 out:
 	*(int *)p = err;
-	complete(&setup_done);
 	return err;
 }
 
@@ -432,6 +431,7 @@ static int __ref devtmpfsd(void *p)
 {
 	int err = devtmpfs_setup(p);
 
+	complete(&setup_done);
 	if (err)
 		return err;
 	devtmpfs_work_loop();
-- 
2.30.2




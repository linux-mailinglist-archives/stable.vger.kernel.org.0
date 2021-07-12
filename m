Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A056F3C4D38
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245382AbhGLHMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:12:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244764AbhGLHLI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:11:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F54A60FE7;
        Mon, 12 Jul 2021 07:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073700;
        bh=nxorP0AjeDbTsaSIPSaNd7W1AcawTcRlxr0saWQW2Uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xyIVExiWaDfU3oFOnCyAtlVRUrC34G4jCUni3mG+BNUoyLgV+FhSVzabiVanzlZTp
         srKiHTNgHmgk5i+h4hloFqqYNU3CtzJvBJ5DRUa4Jr+myP9RC1SBJDTx4veO/140xu
         xZNGueC/X+OLHyjQbM09woIz/Wks00tYlBu2Gq5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 330/700] mark pstore-blk as broken
Date:   Mon, 12 Jul 2021 08:06:53 +0200
Message-Id: <20210712061011.517916360@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit d07f3b081ee632268786601f55e1334d1f68b997 ]

pstore-blk just pokes directly into the pagecache for the block
device without going through the file operations for that by faking
up it's own file operations that do not match the block device ones.

As this breaks the control of the block layer of it's page cache,
and even now just works by accident only the best thing is to just
disable this driver.

Fixes: 17639f67c1d6 ("pstore/blk: Introduce backend for block devices")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20210608161327.1537919-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/pstore/Kconfig b/fs/pstore/Kconfig
index 8adabde685f1..328da35da390 100644
--- a/fs/pstore/Kconfig
+++ b/fs/pstore/Kconfig
@@ -173,6 +173,7 @@ config PSTORE_BLK
 	tristate "Log panic/oops to a block device"
 	depends on PSTORE
 	depends on BLOCK
+	depends on BROKEN
 	select PSTORE_ZONE
 	default n
 	help
-- 
2.30.2




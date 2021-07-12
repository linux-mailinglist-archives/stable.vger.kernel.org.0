Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A364D3C4949
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238006AbhGLGnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:43:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:34676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238669AbhGLGlt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:41:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D63661166;
        Mon, 12 Jul 2021 06:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071927;
        bh=3MAqpF/9SWuEGiSjf2Mm6Jmve9x6pUdqIRnr5vEv3Ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RTPnhxcv5LAk5ZiIA28nVoMCsPFWEVpVzZLWkQJbpQ9iWgLumYPDPYHvmjVoTrGgX
         5OGctOeyGIRYrNwl1YjUtFojPeRA4/raHt/n/jwQ0A9O24MT1RfFIeU70YpyGFVTMy
         bE8rBEzSI7z+AuZeai4aEg6824LDF6D0y2OPAC2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 279/593] mark pstore-blk as broken
Date:   Mon, 12 Jul 2021 08:07:19 +0200
Message-Id: <20210712060914.729174211@linuxfoundation.org>
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
index e16a49ebfe54..8efe60487b48 100644
--- a/fs/pstore/Kconfig
+++ b/fs/pstore/Kconfig
@@ -165,6 +165,7 @@ config PSTORE_BLK
 	tristate "Log panic/oops to a block device"
 	depends on PSTORE
 	depends on BLOCK
+	depends on BROKEN
 	select PSTORE_ZONE
 	default n
 	help
-- 
2.30.2




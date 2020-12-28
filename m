Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076F22E4098
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391235AbgL1OyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:54:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:52136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441426AbgL1ORR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:17:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DCFA207B2;
        Mon, 28 Dec 2020 14:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165022;
        bh=gbZNBjrc2zlFcnWBSOD6PhrMpM+qwB4I32NGCWBDp/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BkZHEAheBYSkJK+G9njY0SeAyFA2z0aRHGw0aT4Y5grrWIIfGNs/FPf/AMROlqUuN
         ieiG88BMCYvOMhzYgeSy1y/h6Rjv8a2k9HOMr61peKORZHYDPWiwdlGlynUvXUtBYL
         15axxs3OjZAkBkQLjgvm3I8CNjiCvhUvKo543x2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 342/717] block/rnbd: fix a null pointer dereference on dev->blk_symlink_name
Date:   Mon, 28 Dec 2020 13:45:40 +0100
Message-Id: <20201228125037.409803523@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 733c15bd3a944b8eeaacdddf061759b6a83dd3f4 ]

Currently in the case where dev->blk_symlink_name fails to be allocates
the error return path attempts to set an end-of-string character to
the unallocated dev->blk_symlink_name causing a null pointer dereference
error. Fix this by returning with an explicity ENOMEM error (which also
is missing in the original code as was not initialized).

Fixes: 1eb54f8f5dd8 ("block/rnbd: client: sysfs interface functions")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Addresses-Coverity: ("Dereference after null check")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-clt-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rnbd/rnbd-clt-sysfs.c b/drivers/block/rnbd/rnbd-clt-sysfs.c
index b53df40c9a97f..d854f057056bb 100644
--- a/drivers/block/rnbd/rnbd-clt-sysfs.c
+++ b/drivers/block/rnbd/rnbd-clt-sysfs.c
@@ -494,7 +494,7 @@ static int rnbd_clt_add_dev_symlink(struct rnbd_clt_dev *dev)
 	dev->blk_symlink_name = kzalloc(len, GFP_KERNEL);
 	if (!dev->blk_symlink_name) {
 		rnbd_clt_err(dev, "Failed to allocate memory for blk_symlink_name\n");
-		goto out_err;
+		return -ENOMEM;
 	}
 
 	ret = rnbd_clt_get_path_name(dev, dev->blk_symlink_name,
-- 
2.27.0




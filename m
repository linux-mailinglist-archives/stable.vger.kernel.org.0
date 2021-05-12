Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E15D37C97D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235432AbhELQTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:19:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236110AbhELQLX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:11:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4943061D46;
        Wed, 12 May 2021 15:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834044;
        bh=YqOFofuOdzYsQIUxsYo5jEgGPfN7n5zL14DIlrivLGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xRnqSBIjSWgjTqRxzSX2kfekIuBWv3XHfdjspjQHXKdLTZDHDhr5tSVdzo9i3EBlC
         6WWWWFUx0SJIY0U43DzKxTBQkEskjLjWOVNwa3PX+bG0dnz/RcMzDV5RSQcnie+Z+r
         6izyATIReloybktPXTF8UJgMaLbaAjrlG6+QRsH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 387/601] ataflop: fix off by one in ataflop_probe()
Date:   Wed, 12 May 2021 16:47:44 +0200
Message-Id: <20210512144840.545798878@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit b777f4c47781df6b23e3f4df6fdb92d9aceac7bb ]

Smatch complains that the "type > NUM_DISK_MINORS" should be >=
instead of >.  We also need to subtract one from "type" at the start.

Fixes: bf9c0538e485 ("ataflop: use a separate gendisk for each media format")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ataflop.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index aed2c2a4f4ea..d601e49f80e0 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -2001,7 +2001,10 @@ static void ataflop_probe(dev_t dev)
 	int drive = MINOR(dev) & 3;
 	int type  = MINOR(dev) >> 2;
 
-	if (drive >= FD_MAX_UNITS || type > NUM_DISK_MINORS)
+	if (type)
+		type--;
+
+	if (drive >= FD_MAX_UNITS || type >= NUM_DISK_MINORS)
 		return;
 	mutex_lock(&ataflop_probe_lock);
 	if (!unit[drive].disk[type]) {
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D042E3DE7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437921AbgL1OVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:21:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:56064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502427AbgL1OVQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:21:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1004B22B2C;
        Mon, 28 Dec 2020 14:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165260;
        bh=b0jcMGLxfRGb7TrSxt2oYTfuWtuHkhr6KAf1Dqypw7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oCfrdj1r/sRWoqNd1dcNR1OcziFO4alxnNTwz8c3CIoyhpnV9maiXhCoCAPFxrOv9
         9lY4WNxX/p9nWg+zR/cf3fhtS4PYEjAE/dO1Bhh8ad0PV3r7lnMPLxpu33CYjiHDre
         U2LtrtTd4fQsXDrDhr+NMGMGJh8GAp7F+l0VStIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Md Haris Iqbal <haris.iqbal@cloud.ionos.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 469/717] block/rnbd-clt: Get rid of warning regarding size argument in strlcpy
Date:   Mon, 28 Dec 2020 13:47:47 +0100
Message-Id: <20201228125043.440779235@linuxfoundation.org>
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

From: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>

[ Upstream commit e7508d48565060af5d89f10cb83c9359c8ae1310 ]

The kernel test robot triggerred the following warning,

>> drivers/block/rnbd/rnbd-clt.c:1397:42: warning: size argument in
'strlcpy' call appears to be size of the source; expected the size of the
destination [-Wstrlcpy-strlcat-size]
	strlcpy(dev->pathname, pathname, strlen(pathname) + 1);
					      ~~~~~~~^~~~~~~~~~~~~

To get rid of the above warning, use a kstrdup as Bart suggested.

Fixes: 64e8a6ece1a5 ("block/rnbd-clt: Dynamically alloc buffer for pathname & blk_symlink_name")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-clt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-clt.c b/drivers/block/rnbd/rnbd-clt.c
index f180ebf1e11c9..7af1b60582fe5 100644
--- a/drivers/block/rnbd/rnbd-clt.c
+++ b/drivers/block/rnbd/rnbd-clt.c
@@ -1383,12 +1383,11 @@ static struct rnbd_clt_dev *init_dev(struct rnbd_clt_session *sess,
 		goto out_queues;
 	}
 
-	dev->pathname = kzalloc(strlen(pathname) + 1, GFP_KERNEL);
+	dev->pathname = kstrdup(pathname, GFP_KERNEL);
 	if (!dev->pathname) {
 		ret = -ENOMEM;
 		goto out_queues;
 	}
-	strlcpy(dev->pathname, pathname, strlen(pathname) + 1);
 
 	dev->clt_device_id	= ret;
 	dev->sess		= sess;
-- 
2.27.0




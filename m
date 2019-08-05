Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1507E81C50
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730400AbfHENWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:22:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730679AbfHENWd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:22:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF2F120657;
        Mon,  5 Aug 2019 13:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011352;
        bh=F86ykidCWdaICRidaYLn2HmerqQTkga+35rAYsfXs4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ovRASTrLCMx58Eyi6S0tW/getYGYbXl2iHC0ectUBSIm7V0UJJVOl7mr7dY9p4lUG
         9zD5WQflhDqtDpviRTdB39oJtvcs8Z7abjEKBK7R5JUMAJCpAbVAV73h9ReGsGpgY4
         OhaHse67+IcVQZ+t3y+55OdmZyDoQkxUfWiCB+50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 060/131] drivers/rapidio/devices/rio_mport_cdev.c: NUL terminate some strings
Date:   Mon,  5 Aug 2019 15:02:27 +0200
Message-Id: <20190805124955.448039480@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 156e0b1a8112b76e351684ac948c59757037ac36 ]

The dev_info.name[] array has space for RIO_MAX_DEVNAME_SZ + 1
characters.  But the problem here is that we don't ensure that the user
put a NUL terminator on the end of the string.  It could lead to an out
of bounds read.

Link: http://lkml.kernel.org/r/20190529110601.GB19119@mwanda
Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rapidio/devices/rio_mport_cdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/rapidio/devices/rio_mport_cdev.c b/drivers/rapidio/devices/rio_mport_cdev.c
index ce7a90e680422..8155f59ece38d 100644
--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -1686,6 +1686,7 @@ static int rio_mport_add_riodev(struct mport_cdev_priv *priv,
 
 	if (copy_from_user(&dev_info, arg, sizeof(dev_info)))
 		return -EFAULT;
+	dev_info.name[sizeof(dev_info.name) - 1] = '\0';
 
 	rmcd_debug(RDEV, "name:%s ct:0x%x did:0x%x hc:0x%x", dev_info.name,
 		   dev_info.comptag, dev_info.destid, dev_info.hopcount);
@@ -1817,6 +1818,7 @@ static int rio_mport_del_riodev(struct mport_cdev_priv *priv, void __user *arg)
 
 	if (copy_from_user(&dev_info, arg, sizeof(dev_info)))
 		return -EFAULT;
+	dev_info.name[sizeof(dev_info.name) - 1] = '\0';
 
 	mport = priv->md->mport;
 
-- 
2.20.1




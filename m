Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD361013FF
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728944AbfKSF3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:29:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:47826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728968AbfKSF3S (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:29:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B03FE222A2;
        Tue, 19 Nov 2019 05:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141357;
        bh=Ek+tRWptDmvc/XOB2PFxRi0EZJosnbs0W+8St8JxikU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rKZaHhsUoF1bQnyNH1bXPbQg1NrV70AfFhnFfeUGXtoJVkvn3uRfYZ3ijQYzjF+dm
         rc3B/0O4u76CLVOQPeM4SPdVfuGFBIwxyGx781CU5labh5OYqKDdaIo2P7KI9b1rkP
         qy5LoQo5OPlIdZ4mTfXxqwbB+lVsY4j46GuGESgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ding Xiang <dingxiang@cmss.chinamobile.com>,
        Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
        Paul Burton <paul.burton@mips.com>, ralf@linux-mips.org,
        jhogan@kernel.org, linux-mips@linux-mips.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 132/422] mips: txx9: fix iounmap related issue
Date:   Tue, 19 Nov 2019 06:15:29 +0100
Message-Id: <20191119051407.434383835@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ding Xiang <dingxiang@cmss.chinamobile.com>

[ Upstream commit c6e1241a82e6e74d1ae5cc34581dab2ffd6022d0 ]

if device_register return error, iounmap should be called, also iounmap
need to call before put_device.

Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
Reviewed-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Patchwork: https://patchwork.linux-mips.org/patch/20476/
Cc: ralf@linux-mips.org
Cc: jhogan@kernel.org
Cc: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/txx9/generic/setup.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/mips/txx9/generic/setup.c b/arch/mips/txx9/generic/setup.c
index f6d9182ef82a9..70a1ab66d252c 100644
--- a/arch/mips/txx9/generic/setup.c
+++ b/arch/mips/txx9/generic/setup.c
@@ -960,12 +960,11 @@ void __init txx9_sramc_init(struct resource *r)
 		goto exit_put;
 	err = sysfs_create_bin_file(&dev->dev.kobj, &dev->bindata_attr);
 	if (err) {
-		device_unregister(&dev->dev);
 		iounmap(dev->base);
-		kfree(dev);
+		device_unregister(&dev->dev);
 	}
 	return;
 exit_put:
+	iounmap(dev->base);
 	put_device(&dev->dev);
-	return;
 }
-- 
2.20.1




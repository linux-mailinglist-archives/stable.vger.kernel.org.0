Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B6A499B06
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443780AbiAXVtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457341AbiAXVlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:41:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7186AC0419D4;
        Mon, 24 Jan 2022 12:28:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1343861513;
        Mon, 24 Jan 2022 20:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CB0C340E5;
        Mon, 24 Jan 2022 20:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056087;
        bh=KRYqqgWjbG1axnu97YGHjeYl7Ss7mR3mkioLhNf+bLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1f3XycK3MDxy4zu+NAw7TzV6JYekAGX5AC5EPN7NrEzqi0JO1vZkyVrJYs4KLW6Q8
         QGUPm5uknPt0lbgaaRTYSEdnzIjz+BqfW7srjVyK3O3+jUQ1xvWDi1w/Fy2xUb8IfO
         AUTQWHdSRxRKmop5CAifWMb8+L/hZa33srTQ3Tp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 333/846] drivers/firmware: Add missing platform_device_put() in sysfb_create_simplefb
Date:   Mon, 24 Jan 2022 19:37:30 +0100
Message-Id: <20220124184112.401323857@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 0589e8889dce8e0f0ea5bbf757f38865e2a469c1 ]

Add the missing platform_device_put() before return from
sysfb_create_simplefb() in the error handling case.

Fixes: 8633ef82f101 ("drivers/firmware: consolidate EFI framebuffer setup for all arches")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20211231080431.15385-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/sysfb_simplefb.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/sysfb_simplefb.c b/drivers/firmware/sysfb_simplefb.c
index b86761904949c..303a491e520d1 100644
--- a/drivers/firmware/sysfb_simplefb.c
+++ b/drivers/firmware/sysfb_simplefb.c
@@ -113,12 +113,16 @@ __init int sysfb_create_simplefb(const struct screen_info *si,
 	sysfb_apply_efi_quirks(pd);
 
 	ret = platform_device_add_resources(pd, &res, 1);
-	if (ret)
+	if (ret) {
+		platform_device_put(pd);
 		return ret;
+	}
 
 	ret = platform_device_add_data(pd, mode, sizeof(*mode));
-	if (ret)
+	if (ret) {
+		platform_device_put(pd);
 		return ret;
+	}
 
 	return platform_device_add(pd);
 }
-- 
2.34.1




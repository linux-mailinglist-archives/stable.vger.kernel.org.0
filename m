Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80BA35BFCF
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239175AbhDLJG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:06:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239994AbhDLJE0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:04:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60F8861262;
        Mon, 12 Apr 2021 09:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218119;
        bh=F8b3vb5PTEDH2Um/4peEt+2NFeHbIcQ86UXLBpPN+Ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJU6UjIZ4Xbb4iM114kjjhx0ke1a5lwQ6x/2kd+/vhchxlttL5vwv8TOMmhFMa7k/
         xRscV1k5ZJxpATsxWUrBf9KumaVvXZUD1UByIO4MzqdqACUtD1h7EwztgbKkmM6n4c
         VwD22dnZeBzzpOrAk7IaWK7rv8iznUaFt0fjW050=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.11 078/210] thunderbolt: Fix a leak in tb_retimer_add()
Date:   Mon, 12 Apr 2021 10:39:43 +0200
Message-Id: <20210412084018.615202728@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit bec4d7c93afc07dd0454ae41c559513f858cfb83 upstream.

After the device_register() succeeds, then the correct way to clean up
is to call device_unregister().  The unregister calls both device_del()
and device_put().  Since this code was only device_del() it results in
a memory leak.

Fixes: dacb12877d92 ("thunderbolt: Add support for on-board retimers")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/retimer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thunderbolt/retimer.c
+++ b/drivers/thunderbolt/retimer.c
@@ -347,7 +347,7 @@ static int tb_retimer_add(struct tb_port
 	ret = tb_retimer_nvm_add(rt);
 	if (ret) {
 		dev_err(&rt->dev, "failed to add NVM devices: %d\n", ret);
-		device_del(&rt->dev);
+		device_unregister(&rt->dev);
 		return ret;
 	}
 



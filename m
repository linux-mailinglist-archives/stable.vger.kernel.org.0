Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89CEAA8FAA
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733057AbfIDSFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:05:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388825AbfIDSFD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:05:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA3DB2339E;
        Wed,  4 Sep 2019 18:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620302;
        bh=r3hHmwvr5gwac8HXyAhPmaX+ldpvoyfb/3IuCoowTQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F2tKM7zzkfFH62XT+jTK9hLNfNbkDTTVa/kg8HeGKsQ+xTiGtr15thAfrL1zRHurC
         DAZ8mUCKf+OJXAf6mXKnBZcwFkfibf3K0paxLgH3o75nmgSVe9/RrLPNfghiC6Ks7h
         g/8i5B2pq61ezBJsyWzFOFyw+vJoPMqVm27Cnu70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ding Xiang <dingxiang@cmss.chinamobile.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH 4.14 41/57] stm class: Fix a double free of stm_source_device
Date:   Wed,  4 Sep 2019 19:54:09 +0200
Message-Id: <20190904175306.005214863@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175301.777414715@linuxfoundation.org>
References: <20190904175301.777414715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ding Xiang <dingxiang@cmss.chinamobile.com>

commit 961b6ffe0e2c403b09a8efe4a2e986b3c415391a upstream.

In the error path of stm_source_register_device(), the kfree is
unnecessary, as the put_device() before it ends up calling
stm_source_device_release() to free stm_source_device, leading to
a double free at the outer kfree() call. Remove it.

Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Fixes: 7bd1d4093c2fa ("stm class: Introduce an abstraction for System Trace Module devices")
Link: https://lore.kernel.org/linux-arm-kernel/1563354988-23826-1-git-send-email-dingxiang@cmss.chinamobile.com/
Cc: stable@vger.kernel.org # v4.4+
Link: https://lore.kernel.org/r/20190821074955.3925-2-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/stm/core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/hwtracing/stm/core.c
+++ b/drivers/hwtracing/stm/core.c
@@ -1107,7 +1107,6 @@ int stm_source_register_device(struct de
 
 err:
 	put_device(&src->dev);
-	kfree(src);
 
 	return err;
 }



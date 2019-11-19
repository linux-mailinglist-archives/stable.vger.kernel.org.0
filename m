Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4D21018E5
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbfKSFYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:24:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:41094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728254AbfKSFYo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:24:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBBBE21783;
        Tue, 19 Nov 2019 05:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141083;
        bh=jWJ5mDAo7L57NSsmegMb4kpVXwktbrG+j01VyzTZwl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gyrq46x9oVf72301gO/AiDSTBTT53NUB5zIykVXqiiBRlFDkC03WgiEb5zSKo9EfV
         I1D8ROXPCXZUmx4UuMEyKIFy2ufNI4eAohwd938+9/KqWwI3yF5Pv02+vAsUO/nGJG
         rsBGSakV8SqI69fbv8hoT7A6tmF9wL6WWmVyW4b8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sanyog Kale <sanyog.r.kale@intel.com>,
        Shreyas NC <shreyas.nc@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 038/422] soundwire: Initialize completion for defer messages
Date:   Tue, 19 Nov 2019 06:13:55 +0100
Message-Id: <20191119051402.440815842@linuxfoundation.org>
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

From: Shreyas NC <shreyas.nc@intel.com>

[ Upstream commit a306a0e4a5326269b6c78d136407f08433ab5ece ]

Deferred messages are async messages used to synchronize
transitions mostly while doing a bank switch on multi links.
On successful transitions these messages are marked complete
and thereby confirming that all the buses performed bank switch
successfully.

So, initialize the completion structure for the same.

Signed-off-by: Sanyog Kale <sanyog.r.kale@intel.com>
Signed-off-by: Shreyas NC <shreyas.nc@intel.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/bus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soundwire/bus.c b/drivers/soundwire/bus.c
index 83576810eee65..df172bf3925f6 100644
--- a/drivers/soundwire/bus.c
+++ b/drivers/soundwire/bus.c
@@ -175,6 +175,7 @@ static inline int do_transfer_defer(struct sdw_bus *bus,
 
 	defer->msg = msg;
 	defer->length = msg->len;
+	init_completion(&defer->complete);
 
 	for (i = 0; i <= retry; i++) {
 		resp = bus->ops->xfer_msg_defer(bus, msg, defer);
-- 
2.20.1




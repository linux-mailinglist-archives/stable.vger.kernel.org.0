Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBEF316738B
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732982AbgBUINU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:13:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:49344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732978AbgBUINR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:13:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1EAA24650;
        Fri, 21 Feb 2020 08:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272797;
        bh=cgZgQbXA5EXmpfCJ4zk9MfAj8jEBQWtRyXE+AKDmBgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=baH1pFIpynKRRXx+KYoV2yvNr5FUbTX/SpV+vLf/6lEJEGjIxqrh7/wdhpBAZpKoI
         +Bb1Qg1nU3zk2wa8xufAaYfy+YfiX3Z/pWzomA1A53oJo8Ib0eZ+nycR4KhegujqGt
         w5aQlpwD1ST29kFyM3pCB7GvuHuXdrkn3pTL+UVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 278/344] driver core: platform: fix u32 greater or equal to zero comparison
Date:   Fri, 21 Feb 2020 08:41:17 +0100
Message-Id: <20200221072415.010652868@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 0707cfa5c3ef58effb143db9db6d6e20503f9dec ]

Currently the check that a u32 variable i is >= 0 is always true because
the unsigned variable will never be negative, causing the loop to run
forever.  Fix this by changing the pre-decrement check to a zero check on
i followed by a decrement of i.

Addresses-Coverity: ("Unsigned compared against 0")
Fixes: 39cc539f90d0 ("driver core: platform: Prevent resouce overflow from causing infinite loops")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/20200116175758.88396-1-colin.king@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index ee99b15581290..60386a32208ff 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -543,7 +543,7 @@ int platform_device_add(struct platform_device *pdev)
 		pdev->id = PLATFORM_DEVID_AUTO;
 	}
 
-	while (--i >= 0) {
+	while (i--) {
 		struct resource *r = &pdev->resource[i];
 		if (r->parent)
 			release_resource(r);
-- 
2.20.1




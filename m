Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98A6F14817F
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390911AbgAXLUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:20:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:58020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390894AbgAXLUX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:20:23 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26C382087E;
        Fri, 24 Jan 2020 11:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864822;
        bh=cx/nSVJngerfZa7sPy/5nVYQe9qvWBVZeqT8wg5K0Bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qwi8EFvSjYp69cSyNub9k8rpAwUso/8yHbQUKqajQ7lNW0HyKXhu7jn2gCKGBe9HQ
         WEVVU/veuw+aQ/BmIjIiO77Qj7/7LQ4tlisxz9bNawXHSvTXxuRa0uRlysh0E8q5/8
         GFblVVlUgCLOPRuUcwAntQyNQOdWW8IGn/wlVI5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 362/639] platform/x86: alienware-wmi: printing the wrong error code
Date:   Fri, 24 Jan 2020 10:28:52 +0100
Message-Id: <20200124093132.457859705@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 6d1f8b3d75419a8659ac916a1e9543bb3513a882 ]

The "out_data" variable is uninitialized at the point.  Originally, this
used to print "status" instead and that seems like the correct thing to
print.

Fixes: bc2ef884320b ("alienware-wmi: For WMAX HDMI method, introduce a way to query HDMI cable status")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Mario Limonciello <mario.limonciello@dell.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/alienware-wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/alienware-wmi.c b/drivers/platform/x86/alienware-wmi.c
index c0d1555735cdd..83fd7677af24c 100644
--- a/drivers/platform/x86/alienware-wmi.c
+++ b/drivers/platform/x86/alienware-wmi.c
@@ -587,7 +587,7 @@ static ssize_t show_hdmi_source(struct device *dev,
 			return scnprintf(buf, PAGE_SIZE,
 					 "input [gpu] unknown\n");
 	}
-	pr_err("alienware-wmi: unknown HDMI source status: %d\n", out_data);
+	pr_err("alienware-wmi: unknown HDMI source status: %u\n", status);
 	return scnprintf(buf, PAGE_SIZE, "input gpu [unknown]\n");
 }
 
-- 
2.20.1




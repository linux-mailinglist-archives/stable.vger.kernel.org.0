Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF33F13F58B
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389122AbgAPS4n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:56:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:38658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389103AbgAPRHM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:07:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75F12205F4;
        Thu, 16 Jan 2020 17:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194431;
        bh=6thWP7j/k1pgl9Cw4eqJkOw8u52jLWNsZu9rydc9Gn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k5RT2mClGd/6z/GTu62kyIXiErbZZyIrh/4t2An2VtW+Y0SYTYzUW8WBiGqNnYLMo
         QywuQ7pAaZLv0tyej3lkFXskmA2jktQD3GiJysUhSRY3oqeH7jWtg0QUQ/FxWU0jZh
         CRXpN1r8Bm9luG2p0kgo3q3Zvmj9nsf3TXnmpLfo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 347/671] platform/x86: alienware-wmi: printing the wrong error code
Date:   Thu, 16 Jan 2020 11:59:45 -0500
Message-Id: <20200116170509.12787-84-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index c0d1555735cd..83fd7677af24 100644
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED922B6386
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732701AbgKQNiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:38:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732693AbgKQNiv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:38:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D889A20870;
        Tue, 17 Nov 2020 13:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620330;
        bh=NCblQ7PM6uHO7cLp6xTKZV2eFlzXy84C7Jk0apAPbDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UaIbV9GMla3i6VygIaorGuUW2kiG+C0aHmy4lAlNzbznAwAd5M1gR6CHkkQeIvJ1F
         MJo89c20Bo1R5QAIvoYybrYTQl/siedgq0ariI6cWbDjhRNWGA7ywsWA7n523czQe+
         cDXRgj7yVd1DrbrNhfHefJHFlBqWR1IFs4J9CJvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.9 182/255] firmware: xilinx: fix out-of-bounds access
Date:   Tue, 17 Nov 2020 14:05:22 +0100
Message-Id: <20201117122147.777135834@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit f3217d6f2f7a76b36a3326ad58c8897f4d5fbe31 upstream.

The zynqmp_pm_set_suspend_mode() and zynqmp_pm_get_trustzone_version()
functions pass values as api_id into zynqmp_pm_invoke_fn
that are beyond PM_API_MAX, resulting in an out-of-bounds access:

drivers/firmware/xilinx/zynqmp.c: In function 'zynqmp_pm_set_suspend_mode':
drivers/firmware/xilinx/zynqmp.c:150:24: warning: array subscript 2562 is above array bounds of 'u32[64]' {aka 'unsigned int[64]'} [-Warray-bounds]
  150 |  if (zynqmp_pm_features[api_id] != PM_FEATURE_UNCHECKED)
      |      ~~~~~~~~~~~~~~~~~~^~~~~~~~
drivers/firmware/xilinx/zynqmp.c:28:12: note: while referencing 'zynqmp_pm_features'
   28 | static u32 zynqmp_pm_features[PM_API_MAX];
      |            ^~~~~~~~~~~~~~~~~~

Replace the resulting undefined behavior with an error return.
This may break some things that happen to work at the moment
but seems better than randomly overwriting kernel data.

I assume we need additional fixes for the two functions that now
return an error.

Fixes: 76582671eb5d ("firmware: xilinx: Add Zynqmp firmware driver")
Fixes: e178df31cf41 ("firmware: xilinx: Implement ZynqMP power management APIs")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20201026155449.3703142-1-arnd@kernel.org
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/xilinx/zynqmp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/firmware/xilinx/zynqmp.c
+++ b/drivers/firmware/xilinx/zynqmp.c
@@ -147,6 +147,9 @@ static int zynqmp_pm_feature(u32 api_id)
 		return 0;
 
 	/* Return value if feature is already checked */
+	if (api_id > ARRAY_SIZE(zynqmp_pm_features))
+		return PM_FEATURE_INVALID;
+
 	if (zynqmp_pm_features[api_id] != PM_FEATURE_UNCHECKED)
 		return zynqmp_pm_features[api_id];
 



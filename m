Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC0613F04B
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730868AbgAPSUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:20:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:38988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404139AbgAPR2N (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:28:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69199246E3;
        Thu, 16 Jan 2020 17:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195693;
        bh=gE3am8simhOn5Aj73vBTSzBvMCWjmOSAuDyRhW5QpyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=va945u64vxu4q+vp566d3CokIubWLIAr4r2s9bip4LfKkWlJ+2nZfYo0/IiWN91eU
         zE4NeD71T/o8oXHjd3tt1wu30BZbbf7pVxDoCekXTxc7C3ClUVMZsh3Bc0SKFokk3N
         I0BQLzm82Ea9q6FP9nRGjQvc4cdW87BNf9TNN8vM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 243/371] mfd: intel-lpss: Release IDA resources
Date:   Thu, 16 Jan 2020 12:21:55 -0500
Message-Id: <20200116172403.18149-186-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 02f36911c1b41fcd8779fa0c135aab0554333fa5 ]

ida instances allocate some internal memory for ->free_bitmap
in addition to the base 'struct ida'. Use ida_destroy() to release
that memory at module_exit().

Fixes: 4b45efe85263 ("mfd: Add support for Intel Sunrisepoint LPSS devices")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel-lpss.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/intel-lpss.c b/drivers/mfd/intel-lpss.c
index b5c4f8f974aa..9ed573e232c0 100644
--- a/drivers/mfd/intel-lpss.c
+++ b/drivers/mfd/intel-lpss.c
@@ -541,6 +541,7 @@ module_init(intel_lpss_init);
 
 static void __exit intel_lpss_exit(void)
 {
+	ida_destroy(&intel_lpss_devid_ida);
 	debugfs_remove(intel_lpss_debugfs);
 }
 module_exit(intel_lpss_exit);
-- 
2.20.1


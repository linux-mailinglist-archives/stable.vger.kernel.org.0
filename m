Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9939404769
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 10:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbhIII5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 04:57:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232198AbhIII52 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 04:57:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B8EB61041;
        Thu,  9 Sep 2021 08:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631177779;
        bh=UQc9VKdMGk35AXtq9HG/C98PtQU7GXp4ewWJ6O1MgDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hTBevQAMmMeCuwz5ZEXyWUps8aMdHwfmn4+BGODKodIdyzTCIKy0qGjsHTLSmNsgx
         vqWcSv2THajhsPCmAy/aRsBcDbLSGuShVxnYrAeuNt9zOl3vNSt21bFCich3piz4i3
         cmA7q+80PyAlOvoU9Xmg0XkjpY8qD7X2fz2IahZlsihX53RweBnw7jQWXTgRO/8bil
         vqVqvHwH/vYvg8RHf8RNWCeXcyZ3Ifs1S7Pmg+p68O3BI6LIuO/joRK7KdFHnPn46o
         DSZ3RvH1/vr2oyehMEJ1decqnbvgDTPwGZOfRG/G1GEsozu0il0f7Jp4Uv/XtXH2IH
         5m24qOBRIwwyw==
From:   Antoine Tenart <atenart@kernel.org>
To:     rui.zhang@intel.com, daniel.lezcano@linaro.org, amitk@kernel.org,
        srinivas.pandruvada@linux.intel.com
Cc:     Antoine Tenart <atenart@kernel.org>, linux-pm@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2 1/2] thermal: int340x: do not set a wrong tcc offset on resume
Date:   Thu,  9 Sep 2021 10:56:12 +0200
Message-Id: <20210909085613.5577-2-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210909085613.5577-1-atenart@kernel.org>
References: <20210909085613.5577-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After upgrading to Linux 5.13.3 I noticed my laptop would shutdown due
to overheat (when it should not). It turned out this was due to commit
fe6a6de6692e ("thermal/drivers/int340x/processor_thermal: Fix tcc setting").

What happens is this drivers uses a global variable to keep track of the
tcc offset (tcc_offset_save) and uses it on resume. The issue is this
variable is initialized to 0, but is only set in
tcc_offset_degree_celsius_store, i.e. when the tcc offset is explicitly
set by userspace. If that does not happen, the resume path will set the
offset to 0 (in my case the h/w default being 3, the offset would become
too low after a suspend/resume cycle).

The issue did not arise before commit fe6a6de6692e, as the function
setting the offset would return if the offset was 0. This is no longer
the case (rightfully).

Fix this by not applying the offset if it wasn't saved before, reverting
back to the old logic. A better approach will come later, but this will
be easier to apply to stable kernels.

The logic to restore the offset after a resume was there long before
commit fe6a6de6692e, but as a value of 0 was considered invalid I'm
referencing the commit that made the issue possible in the Fixes tag
instead.

Fixes: fe6a6de6692e ("thermal/drivers/int340x/processor_thermal: Fix tcc setting")
Cc: stable@vger.kernel.org
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 .../thermal/intel/int340x_thermal/processor_thermal_device.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
index 0f0038af2ad4..fb64acfd5e07 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
@@ -107,7 +107,7 @@ static int tcc_offset_update(unsigned int tcc)
 	return 0;
 }
 
-static unsigned int tcc_offset_save;
+static int tcc_offset_save = -1;
 
 static ssize_t tcc_offset_degree_celsius_store(struct device *dev,
 				struct device_attribute *attr, const char *buf,
@@ -352,7 +352,8 @@ int proc_thermal_resume(struct device *dev)
 	proc_dev = dev_get_drvdata(dev);
 	proc_thermal_read_ppcc(proc_dev);
 
-	tcc_offset_update(tcc_offset_save);
+	if (tcc_offset_save >= 0)
+		tcc_offset_update(tcc_offset_save);
 
 	return 0;
 }
-- 
2.31.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D649419A6C
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236478AbhI0RJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:09:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236110AbhI0RHw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:07:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C41FC611F0;
        Mon, 27 Sep 2021 17:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762373;
        bh=xi95IEWQSZdZ1nRNe0fmKxA2/HNzYWWNPOdEgCniOxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zo95UljvxGwkJgcjpogfM0PHboNkkoz9pw/PiPBhvBo/dzgl3HdNfmJ1o+ubu516V
         yykpjaXBgM0aeBwp7CkqB23DITTVrof5lxSeB5zaRg1T7DVYuM6FAJaGczMsx5tAIc
         jKt09Ardlmsu4BpKVDQrsfXZpZVV2kK7/ie/onoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Antoine Tenart <atenart@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Srinivas Pandruvada <srinivas.pIandruvada@linux.intel.com>
Subject: [PATCH 5.4 65/68] thermal/drivers/int340x: Do not set a wrong tcc offset on resume
Date:   Mon, 27 Sep 2021 19:03:01 +0200
Message-Id: <20210927170222.218389250@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <atenart@kernel.org>

commit 8b4bd256674720709a9d858a219fcac6f2f253b5 upstream.

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
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Tested-by: Srinivas Pandruvada <srinivas.pI andruvada@linux.intel.com>
Link: https://lore.kernel.org/r/20210909085613.5577-2-atenart@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel/int340x_thermal/processor_thermal_device.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
@@ -179,7 +179,7 @@ static int tcc_offset_update(unsigned in
 	return 0;
 }
 
-static unsigned int tcc_offset_save;
+static int tcc_offset_save = -1;
 
 static ssize_t tcc_offset_degree_celsius_store(struct device *dev,
 				struct device_attribute *attr, const char *buf,
@@ -703,7 +703,8 @@ static int proc_thermal_resume(struct de
 	proc_dev = dev_get_drvdata(dev);
 	proc_thermal_read_ppcc(proc_dev);
 
-	tcc_offset_update(tcc_offset_save);
+	if (tcc_offset_save >= 0)
+		tcc_offset_update(tcc_offset_save);
 
 	return 0;
 }



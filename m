Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D962E3B5B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406053AbgL1NtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:49:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:50606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406051AbgL1NtG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:49:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E019B2064B;
        Mon, 28 Dec 2020 13:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163300;
        bh=Zvit1UuchjFkeoMJwJDTMpBLsYH6aMiyycroSb5ai/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uSPQ4oQ71GbEcXHL4Q7/Np6gi2DUS/ZdHXco0aM9tRD0aN91vfKLO0R5aG9WNsicC
         3chCXFR6HMJFyYMhc4cCdJJyzQhTZdHPDwNQ69ks+u2+JHkYk2fVS79AADY46RrcX3
         4E23m6nkjuQgj0S+chGBzVDAqqKM7rXxeKwKT3x0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 208/453] hwmon: (ina3221) Fix PM usage counter unbalance in ina3221_write_enable
Date:   Mon, 28 Dec 2020 13:47:24 +0100
Message-Id: <20201228124947.229019996@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit bce776f10069c806290eaac712ba73432ae8ecd7 ]

pm_runtime_get_sync will increment pm usage counter
even it failed. Forgetting to putting operation will
result in reference leak here. We fix it by replacing
it with pm_runtime_resume_and_get to keep usage counter
balanced. It depends on the mainline commit[PM: runtime:
Add pm_runtime_resume_and_get to deal with usagecounter].

Fixes: 323aeb0eb5d9a ("hwmon: (ina3221) Add PM runtime support")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201202145320.1135614-1-zhangqilong3@huawei.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ina3221.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/ina3221.c b/drivers/hwmon/ina3221.c
index 8a51dcf055eab..026f70d7c5a43 100644
--- a/drivers/hwmon/ina3221.c
+++ b/drivers/hwmon/ina3221.c
@@ -403,7 +403,7 @@ static int ina3221_write_enable(struct device *dev, int channel, bool enable)
 
 	/* For enabling routine, increase refcount and resume() at first */
 	if (enable) {
-		ret = pm_runtime_get_sync(ina->pm_dev);
+		ret = pm_runtime_resume_and_get(ina->pm_dev);
 		if (ret < 0) {
 			dev_err(dev, "Failed to get PM runtime\n");
 			return ret;
-- 
2.27.0




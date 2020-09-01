Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41AD225949C
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731272AbgIAPl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:41:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731230AbgIAPlK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:41:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE092207D3;
        Tue,  1 Sep 2020 15:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974869;
        bh=rMIaUkbwsXlDXRDktehm3F7/SiCBsyj9jRFyFLhGohk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2NDKWrmyLq7hrMqN09cdpNRj3LYkdt8pCAzLMWGfDFy9vZHTIVHogITOCZ6GRLrfF
         INy6BfCWpYiNSYEr9uHYP9CO+JtMOaT4T86S5BA34qe9jZV39niFZYyu43CEdZDuXh
         s8QZMJ2LpW2O5TYUFRq8PIOUj46lFHpTEFXqDscA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Baron <jbaron@akamai.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 091/255] hwmon: (nct7904) Correct divide by 0
Date:   Tue,  1 Sep 2020 17:09:07 +0200
Message-Id: <20200901151005.085204957@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Baron <jbaron@akamai.com>

[ Upstream commit 8aebbbb2d573d0b4afc08b90ac7d73dba2d9da97 ]

We hit a kernel panic due to a divide by 0 in nct7904_read_fan() for
the hwmon_fan_min case. Extend the check to hwmon_fan_input case as well
for safety.

[ 1656.545650] divide error: 0000 [#1] SMP PTI
[ 1656.545779] CPU: 12 PID: 18010 Comm: sensors Not tainted 5.4.47 #1
[ 1656.546065] RIP: 0010:nct7904_read+0x1e9/0x510 [nct7904]
...
[ 1656.546549] RAX: 0000000000149970 RBX: ffffbd6b86bcbe08 RCX: 0000000000000000
...
[ 1656.547548] Call Trace:
[ 1656.547665]  hwmon_attr_show+0x32/0xd0 [hwmon]
[ 1656.547783]  dev_attr_show+0x18/0x50
[ 1656.547898]  sysfs_kf_seq_show+0x99/0x120
[ 1656.548013]  seq_read+0xd8/0x3e0
[ 1656.548127]  vfs_read+0x89/0x130
[ 1656.548234]  ksys_read+0x7d/0xb0
[ 1656.548342]  do_syscall_64+0x48/0x110
[ 1656.548451]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: d65a5102a99f5 ("hwmon: (nct7904) Convert to use new hwmon registration API")
Signed-off-by: Jason Baron <jbaron@akamai.com>
Link: https://lore.kernel.org/r/1598026814-2604-1-git-send-email-jbaron@akamai.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct7904.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/nct7904.c b/drivers/hwmon/nct7904.c
index b0425694f7022..242ff8bee78dd 100644
--- a/drivers/hwmon/nct7904.c
+++ b/drivers/hwmon/nct7904.c
@@ -231,7 +231,7 @@ static int nct7904_read_fan(struct device *dev, u32 attr, int channel,
 		if (ret < 0)
 			return ret;
 		cnt = ((ret & 0xff00) >> 3) | (ret & 0x1f);
-		if (cnt == 0x1fff)
+		if (cnt == 0 || cnt == 0x1fff)
 			rpm = 0;
 		else
 			rpm = 1350000 / cnt;
@@ -243,7 +243,7 @@ static int nct7904_read_fan(struct device *dev, u32 attr, int channel,
 		if (ret < 0)
 			return ret;
 		cnt = ((ret & 0xff00) >> 3) | (ret & 0x1f);
-		if (cnt == 0x1fff)
+		if (cnt == 0 || cnt == 0x1fff)
 			rpm = 0;
 		else
 			rpm = 1350000 / cnt;
-- 
2.25.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C447B3A01D5
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236195AbhFHS4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:56:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236105AbhFHSxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:53:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3570A6157E;
        Tue,  8 Jun 2021 18:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177641;
        bh=nUB/Ap4eZ/hR5xEvf/2VZdkW/1M2N1RdoizMM+wCb1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1MPpkavmrZJ98H6ZJehwXVCqdQwSJ+G5Pe3OX5e++Qmmj/1eh3CWlUar+R99WKYiI
         rPLNlabzpDNxVcjMRaPhQSWVUfmszli+ghVm7kbIK4HWIzW3cZd1tzEJevpgJ2aFj/
         8K45lMFaUTuGE91kh25opSULiuKpvzOtvuT3sJ7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Armin Wolf <W_Armin@gmx.de>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/137] hwmon: (dell-smm-hwmon) Fix index values
Date:   Tue,  8 Jun 2021 20:25:43 +0200
Message-Id: <20210608175942.495284430@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 35d470b5fbc9f82feb77b56bb0d5d0b5cd73e9da ]

When support for up to 10 temp sensors and for disabling automatic BIOS
fan control was added, noone updated the index values used for
disallowing fan support and fan type calls.
Fix those values.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/20210513154546.12430-1-W_Armin@gmx.de
Fixes: 1bb46a20e73b ("hwmon: (dell-smm) Support up to 10 temp sensors")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/dell-smm-hwmon.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
index 73b9db9e3aab..63b74e781c5d 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -838,10 +838,10 @@ static struct attribute *i8k_attrs[] = {
 static umode_t i8k_is_visible(struct kobject *kobj, struct attribute *attr,
 			      int index)
 {
-	if (disallow_fan_support && index >= 8)
+	if (disallow_fan_support && index >= 20)
 		return 0;
 	if (disallow_fan_type_call &&
-	    (index == 9 || index == 12 || index == 15))
+	    (index == 21 || index == 25 || index == 28))
 		return 0;
 	if (index >= 0 && index <= 1 &&
 	    !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP1))
-- 
2.30.2




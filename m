Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005C43A00B3
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235304AbhFHSqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:46:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235511AbhFHSoG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:44:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6879D6144E;
        Tue,  8 Jun 2021 18:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177390;
        bh=UY5gR3r7gyS9RtNxz/kI3SliK+QCmQE20Ty1PLUDCS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ig5CaNzlU6uCQMl0WSMQyLTLCQLwx/fqqMYAMe3VmLq0ZOuRrbsGNSs/j+lvsjghZ
         UvRryqOfmdD2wU24R7QfgobtgVO/yecmSyBjsUBDXxZnAc3g/WEG3QXAxi27gQNgde
         oAnI1U8wRMgk2DVhLVQiV/nsa0RQNQI04sS299m0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Armin Wolf <W_Armin@gmx.de>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 05/78] hwmon: (dell-smm-hwmon) Fix index values
Date:   Tue,  8 Jun 2021 20:26:34 +0200
Message-Id: <20210608175935.447376708@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
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
index 4212d022d253..35c00420d855 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -792,10 +792,10 @@ static struct attribute *i8k_attrs[] = {
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




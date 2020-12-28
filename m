Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFF42E66FF
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732523AbgL1NOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:14:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:42650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731428AbgL1NOg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:14:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D03722583;
        Mon, 28 Dec 2020 13:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161235;
        bh=EhnV4EG3T2F0XxZ18kiCQA35xmBeDZIkXQj9UKroSeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YNVXuKvEE3+B6FWTfURMn95GNl+YkbN+yg7C6ioa1DkvaRDkeoGzaqWRq8aAB4etD
         VrnwQH6emiijfT46vZKzJ8oZ6OUkg8TABRIGctMWFhc71I8m3pJZBeUgaFF7rAfW8X
         Zsc7Lbi63DpgzcE1689AET0XzkBnhxfx1QQfISos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 148/242] powerpc/pseries/hibernation: drop pseries_suspend_begin() from suspend ops
Date:   Mon, 28 Dec 2020 13:49:13 +0100
Message-Id: <20201228124911.992206968@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 52719fce3f4c7a8ac9eaa191e8d75a697f9fbcbc ]

There are three ways pseries_suspend_begin() can be reached:

1. When "mem" is written to /sys/power/state:

kobj_attr_store()
-> state_store()
  -> pm_suspend()
    -> suspend_devices_and_enter()
      -> pseries_suspend_begin()

This never works because there is no way to supply a valid stream id
using this interface, and H_VASI_STATE is called with a stream id of
zero. So this call path is useless at best.

2. When a stream id is written to /sys/devices/system/power/hibernate.
pseries_suspend_begin() is polled directly from store_hibernate()
until the stream is in the "Suspending" state (i.e. the platform is
ready for the OS to suspend execution):

dev_attr_store()
-> store_hibernate()
  -> pseries_suspend_begin()

3. When a stream id is written to /sys/devices/system/power/hibernate
(continued). After #2, pseries_suspend_begin() is called once again
from the pm core:

dev_attr_store()
-> store_hibernate()
  -> pm_suspend()
    -> suspend_devices_and_enter()
      -> pseries_suspend_begin()

This is redundant because the VASI suspend state is already known to
be Suspending.

The begin() callback of platform_suspend_ops is optional, so we can
simply remove that assignment with no loss of function.

Fixes: 32d8ad4e621d ("powerpc/pseries: Partition hibernation support")
Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201207215200.1785968-18-nathanl@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/suspend.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/suspend.c b/arch/powerpc/platforms/pseries/suspend.c
index 89726f07d2492..33077ad106cf0 100644
--- a/arch/powerpc/platforms/pseries/suspend.c
+++ b/arch/powerpc/platforms/pseries/suspend.c
@@ -224,7 +224,6 @@ static struct bus_type suspend_subsys = {
 
 static const struct platform_suspend_ops pseries_suspend_ops = {
 	.valid		= suspend_valid_only_mem,
-	.begin		= pseries_suspend_begin,
 	.prepare_late	= pseries_prepare_late,
 	.enter		= pseries_suspend_enter,
 };
-- 
2.27.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FCB40E842
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245443AbhIPRiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:38:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344451AbhIPRgS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:36:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EDD161A70;
        Thu, 16 Sep 2021 16:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810964;
        bh=S/mYC2aZPFp2a9cuahC+9ncNQUxRy7at7ImfNz5LxPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xTRl292GTFq4398SOznROSVkyEDkQYwKL/AHg23JBQ+jcWaErUGDUm3BWPADGfeQN
         DLZa0WvpuUd5eySzOp3sUqVlt3BwTh4YEL0oxfEz86+E6X5iKIpOjRGRw2ihUZTQ2O
         F6RNuzTZM+D43U/9B31CwgK7TYktN3CQ28Z5OtQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 332/432] rtw88: wow: build wow function only if CONFIG_PM is on
Date:   Thu, 16 Sep 2021 18:01:21 +0200
Message-Id: <20210916155822.098682143@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 05e45887382c4c0f9522515759b34991aa17e69d ]

The kernel test robot reports undefined reference after we report wakeup
reason to mac80211. This is because CONFIG_PM is not defined in the testing
configuration file. In fact, functions within wow.c are used if CONFIG_PM
is defined, so use CONFIG_PM to decide whether we build this file or not.

The reported messages are:
   hppa-linux-ld: drivers/net/wireless/realtek/rtw88/wow.o: in function `rtw_wow_show_wakeup_reason':
>> (.text+0x6c4): undefined reference to `ieee80211_report_wowlan_wakeup'
>> hppa-linux-ld: (.text+0x6e0): undefined reference to `ieee80211_report_wowlan_wakeup'

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210728014335.8785-4-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/Makefile b/drivers/net/wireless/realtek/rtw88/Makefile
index c0e4b111c8b4..73d6807a8cdf 100644
--- a/drivers/net/wireless/realtek/rtw88/Makefile
+++ b/drivers/net/wireless/realtek/rtw88/Makefile
@@ -15,9 +15,9 @@ rtw88_core-y += main.o \
 	   ps.o \
 	   sec.o \
 	   bf.o \
-	   wow.o \
 	   regd.o
 
+rtw88_core-$(CONFIG_PM) += wow.o
 
 obj-$(CONFIG_RTW88_8822B)	+= rtw88_8822b.o
 rtw88_8822b-objs		:= rtw8822b.o rtw8822b_table.o
-- 
2.30.2




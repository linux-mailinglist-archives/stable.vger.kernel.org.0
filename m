Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE572A2270
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 00:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbgKAXw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 18:52:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:48262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727119AbgKAXw6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Nov 2020 18:52:58 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50FD52076E;
        Sun,  1 Nov 2020 23:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604274778;
        bh=KoHBMaUwivysyYB5XJPocmNAMiyh3lNe2IVzJBdSTx4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uVQ4XeCGEemc/DLbOu2PF5x/S5hHViwTrD55+BXW4iUEYxUe9UwOhWJ0IZvdyb4Nx
         +ijP2Ouz3wcLeOFwcowNI8q8eDwQL/VPy8vb8/91dsXTZ3UPrBjLOH9pFApZ+uvcb6
         4CCj0Uqt5sDk2XeiAcL3ofDb+SKuwbN13O6Yig84=
Date:   Sun, 1 Nov 2020 18:52:57 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zhen Lei <thunder.leizhen@huawei.com>
Subject: Re: [PATCH AUTOSEL 5.9 087/147] genirq: Add stub for
 set_handle_irq() when !GENERIC_IRQ_MULTI_HANDLER
Message-ID: <20201101235257.GC2092@sasha-vm>
References: <20201026234905.1022767-1-sashal@kernel.org>
 <20201026234905.1022767-87-sashal@kernel.org>
 <afd454bc23c458d4561378907f95a0aa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <afd454bc23c458d4561378907f95a0aa@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 27, 2020 at 08:51:15AM +0000, Marc Zyngier wrote:
>On 2020-10-26 23:48, Sasha Levin wrote:
>>From: Zhen Lei <thunder.leizhen@huawei.com>
>>
>>[ Upstream commit ea0c80d1764449acf2f70fdb25aec33800cd0348 ]
>>
>>In order to avoid compilation errors when a driver references 
>>set_handle_irq(),
>>but that the architecture doesn't select GENERIC_IRQ_MULTI_HANDLER,
>>add a stub function that will just WARN_ON_ONCE() if ever used.
>>
>>Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
>>[maz: commit message]
>>Signed-off-by: Marc Zyngier <maz@kernel.org>
>>Link: https://lore.kernel.org/r/20200924071754.4509-2-thunder.leizhen@huawei.com
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>>---
>> include/linux/irq.h | 6 ++++++
>> 1 file changed, 6 insertions(+)
>>
>>diff --git a/include/linux/irq.h b/include/linux/irq.h
>>index 1b7f4dfee35b3..b167baef88c0b 100644
>>--- a/include/linux/irq.h
>>+++ b/include/linux/irq.h
>>@@ -1252,6 +1252,12 @@ int __init set_handle_irq(void
>>(*handle_irq)(struct pt_regs *));
>>  * top-level IRQ handler.
>>  */
>> extern void (*handle_arch_irq)(struct pt_regs *) __ro_after_init;
>>+#else
>>+#define set_handle_irq(handle_irq)		\
>>+	do {					\
>>+		(void)handle_irq;		\
>>+		WARN_ON(1);			\
>>+	} while (0)
>> #endif
>>
>> #endif /* _LINUX_IRQ_H */
>
>What is the reason for this backport? The only user is a driver that
>isn't getting backported (d59f7d159891 and following patches).

I'll drop it, thanks!

-- 
Thanks,
Sasha

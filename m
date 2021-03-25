Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715DE348F2B
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhCYL0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:26:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230266AbhCYLZj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:25:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25C7061A32;
        Thu, 25 Mar 2021 11:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671538;
        bh=ZIBK+DcXpwRnT1TlbAwNVT8KjBmWwCUFwwQohg62jwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L+0GTjGB673YLzQvjFJuM34BH9GTHSMmd1FMnQBxZQ8DBuWVa1WniUdffuANq8myK
         OMWtAr8RrbX8pEMQDDlIhHwo6cre0wmOM7F3lUaWHJ28Ca2wNb2o+nXq2A7Qbuc7ix
         AJq9uYVU4S1y09DcfPLCvoJ0jKuXGqLJcZJolFWDLR8AFaQGXWtuGe9kHximon5dhJ
         8p7Z4qpuM0zIyTiLlJ8K+nGXASfJHGJnjnBMyC7tUIRzc308FvZCXqLeexC/s4jA/k
         wbkUYuVxfdjYUfvgtwVWlq+EDe3cubNShSdCbeXFsRvs6M6IrmkZbY5lbdeGYekGel
         jv3GG1HIc/qPQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>, Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.11 30/44] staging: comedi: cb_pcidas64: fix request_irq() warn
Date:   Thu, 25 Mar 2021 07:24:45 -0400
Message-Id: <20210325112459.1926846-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112459.1926846-1-sashal@kernel.org>
References: <20210325112459.1926846-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit d2d106fe3badfc3bf0dd3899d1c3f210c7203eab ]

request_irq() wont accept a name which contains slash so we need to
repalce it with something else -- otherwise it will trigger a warning
and the entry in /proc/irq/ will not be created
since the .name might be used by userspace and we don't want to break
userspace, so we are changing the parameters passed to request_irq()

[    1.565966] name 'pci-das6402/16'
[    1.566149] WARNING: CPU: 0 PID: 184 at fs/proc/generic.c:180 __xlate_proc_name+0x93/0xb0
[    1.568923] RIP: 0010:__xlate_proc_name+0x93/0xb0
[    1.574200] Call Trace:
[    1.574722]  proc_mkdir+0x18/0x20
[    1.576629]  request_threaded_irq+0xfe/0x160
[    1.576859]  auto_attach+0x60a/0xc40 [cb_pcidas64]

Suggested-by: Ian Abbott <abbotti@mev.co.uk>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Link: https://lore.kernel.org/r/20210315195814.4692-1-ztong0001@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/comedi/drivers/cb_pcidas64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index fa987bb0e7cd..6d3ba399a7f0 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -4035,7 +4035,7 @@ static int auto_attach(struct comedi_device *dev,
 	init_stc_registers(dev);
 
 	retval = request_irq(pcidev->irq, handle_interrupt, IRQF_SHARED,
-			     dev->board_name, dev);
+			     "cb_pcidas64", dev);
 	if (retval) {
 		dev_dbg(dev->class_dev, "unable to allocate irq %u\n",
 			pcidev->irq);
-- 
2.30.1


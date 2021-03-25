Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0FF634909B
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhCYLgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:36:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231800AbhCYLeP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:34:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84C9461A80;
        Thu, 25 Mar 2021 11:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671724;
        bh=CtZ/vzzW/5Ws0GYk7dTy6lCUpfL2ZWWC5U4jabLBQHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJaCcbf7fb93or+r7BHI+ltxZ2gd2eWnJ8tWSXpPTO854rUlxqePgEO+85i7Mbe9i
         BIDO0e3frM+8QarWAWc60QvhHy6IInZdq+9uG78h8TqaFDtK1QG2f6Uqgl2cQg+JUG
         kmHbTqO69w4N+VAodOaaSn8OZU0qsyBEmonmHJizyoAw0XXlHUtSbU2cU9qgGbxy8C
         nDmaPXLv3E1IaBixpKVzTu0/QIWDTyWhkw+QDN5Lu85DIOO6QbmPMM2LhOQHdAfja2
         XKIXN/GbogSY+Tn1RZkyjWy8lYr27rcUKJjOmcajbH/OOgKPc/34nigidGP+7Htttw
         7zjkcfpNfEujA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>, Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 4.4 09/10] staging: comedi: cb_pcidas64: fix request_irq() warn
Date:   Thu, 25 Mar 2021 07:28:30 -0400
Message-Id: <20210325112832.1928898-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112832.1928898-1-sashal@kernel.org>
References: <20210325112832.1928898-1-sashal@kernel.org>
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
index d33b8fe872a7..93d8c0b06d55 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -4040,7 +4040,7 @@ static int auto_attach(struct comedi_device *dev,
 	init_stc_registers(dev);
 
 	retval = request_irq(pcidev->irq, handle_interrupt, IRQF_SHARED,
-			     dev->board_name, dev);
+			     "cb_pcidas64", dev);
 	if (retval) {
 		dev_dbg(dev->class_dev, "unable to allocate irq %u\n",
 			pcidev->irq);
-- 
2.30.1


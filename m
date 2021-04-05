Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83EE4353D95
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236524AbhDEJAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234042AbhDEJAj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:00:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAF49610E8;
        Mon,  5 Apr 2021 09:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613234;
        bh=gCjSjWEMVtaZ6tWw1zQgoMyWDSUPQciiygslKQvvAyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z0S0EQk9lf2tR/bjLj3Mnma4O7jVkEfJUDHrp/9DjAL0Hmk4wjyDnCRU2oJigxkl/
         K+MHzW6zU4VQ/89/gKy5qxGGlORjGRQumGaZGiNI6+tvlSgcPn+1bjwHc+QD8Za62G
         f2a/VS8NM+zxPXT5et8fYPFm38DIXDlCIAIgnZJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>,
        Tong Zhang <ztong0001@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 18/56] staging: comedi: cb_pcidas64: fix request_irq() warn
Date:   Mon,  5 Apr 2021 10:53:49 +0200
Message-Id: <20210405085023.125224939@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085022.562176619@linuxfoundation.org>
References: <20210405085022.562176619@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 631a703b345d..91403cc1bbf9 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -4021,7 +4021,7 @@ static int auto_attach(struct comedi_device *dev,
 	init_stc_registers(dev);
 
 	retval = request_irq(pcidev->irq, handle_interrupt, IRQF_SHARED,
-			     dev->board_name, dev);
+			     "cb_pcidas64", dev);
 	if (retval) {
 		dev_dbg(dev->class_dev, "unable to allocate irq %u\n",
 			pcidev->irq);
-- 
2.30.1




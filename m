Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3015353C8D
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbhDEIz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:55:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229660AbhDEIz0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:55:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F4256138A;
        Mon,  5 Apr 2021 08:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617612921;
        bh=ZXXW/k7cTS+S5VFAlsQf8Nid+9xzg5C/OEezLtOHqNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rGxvxsvEWOCI+rwALhKi1x9CRIzFI/Tv+fhoPtn7O/ZjmYSzFvA7qXTa5OgnqdE5K
         6eMgE3sXZqPxjgQDAAep3ulVNyMJAk56PJsUL7JM7CSMqN62Qx451CJyQ5fVxSLO3R
         xYPtup/8UYcEa49MpkVx13hx3RL5k6RtV1ggZGeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>,
        Tong Zhang <ztong0001@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 10/28] staging: comedi: cb_pcidas: fix request_irq() warn
Date:   Mon,  5 Apr 2021 10:53:44 +0200
Message-Id: <20210405085017.350023329@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085017.012074144@linuxfoundation.org>
References: <20210405085017.012074144@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit 2e5848a3d86f03024ae096478bdb892ab3d79131 ]

request_irq() wont accept a name which contains slash so we need to
repalce it with something else -- otherwise it will trigger a warning
and the entry in /proc/irq/ will not be created
since the .name might be used by userspace and we don't want to break
userspace, so we are changing the parameters passed to request_irq()

[    1.630764] name 'pci-das1602/16'
[    1.630950] WARNING: CPU: 0 PID: 181 at fs/proc/generic.c:180 __xlate_proc_name+0x93/0xb0
[    1.634009] RIP: 0010:__xlate_proc_name+0x93/0xb0
[    1.639441] Call Trace:
[    1.639976]  proc_mkdir+0x18/0x20
[    1.641946]  request_threaded_irq+0xfe/0x160
[    1.642186]  cb_pcidas_auto_attach+0xf4/0x610 [cb_pcidas]

Suggested-by: Ian Abbott <abbotti@mev.co.uk>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Link: https://lore.kernel.org/r/20210315195914.4801-1-ztong0001@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 3ea15bb0e56e..15b9cc8531f0 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -1290,7 +1290,7 @@ static int cb_pcidas_auto_attach(struct comedi_device *dev,
 	     devpriv->amcc + AMCC_OP_REG_INTCSR);
 
 	ret = request_irq(pcidev->irq, cb_pcidas_interrupt, IRQF_SHARED,
-			  dev->board_name, dev);
+			  "cb_pcidas", dev);
 	if (ret) {
 		dev_dbg(dev->class_dev, "unable to allocate irq %d\n",
 			pcidev->irq);
-- 
2.30.1




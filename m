Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96D1348FE7
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhCYLaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:36152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229626AbhCYL2P (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:28:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39F8461A45;
        Thu, 25 Mar 2021 11:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671637;
        bh=TtjDfljzF3YuQqvLSCfdBTg8d35CJEcQSOiW7F+Pg9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VtVTGTCXoEMMf0TFH17P/9LFFuDSZV4I+aJdePEGBAwj2ZWTfQSjoNX7JXaESqGi7
         +upd6H9KKWiF/gt0esyD5AKvDsdzeF0k6Rqtb/kodSjHsR7vDPatgjtCJbKd3bKCpI
         0Q8gK6VUme3ZBpd8U30j28wk5RLfMxOdIA+eRITL2ArLXQQSXH+QoSwe4qkBjZoSNe
         WDpah7oowL3atMCdG02FIUtIiRaib6wMNPjpDgggNAi+1XGdH9VNdFWYNEXViRp0Y/
         8OywNQPlQFMrfbC1X5uim55pA9vZaQwfEg2X961h74G62DVkKxjXUjUqx0MQLAOdvP
         UrhXM/xhiEvRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>, Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.4 19/24] staging: comedi: cb_pcidas: fix request_irq() warn
Date:   Thu, 25 Mar 2021 07:26:45 -0400
Message-Id: <20210325112651.1927828-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112651.1927828-1-sashal@kernel.org>
References: <20210325112651.1927828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 1893c70de0b9..10f097a7d847 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -1281,7 +1281,7 @@ static int cb_pcidas_auto_attach(struct comedi_device *dev,
 	     devpriv->amcc + AMCC_OP_REG_INTCSR);
 
 	ret = request_irq(pcidev->irq, cb_pcidas_interrupt, IRQF_SHARED,
-			  dev->board_name, dev);
+			  "cb_pcidas", dev);
 	if (ret) {
 		dev_dbg(dev->class_dev, "unable to allocate irq %d\n",
 			pcidev->irq);
-- 
2.30.1


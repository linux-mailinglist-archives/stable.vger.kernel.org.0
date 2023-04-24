Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10A156D46F0
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbjDCOPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbjDCOPo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:15:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7833A40E1
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:15:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2951BB81B6A
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809D0C4339B;
        Mon,  3 Apr 2023 14:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531328;
        bh=3tnAaibem4HgE+t6IcuUMmEIPAYnS8mtHUxGs8rLdps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLSIrlu55FuebeGZG62DgEYZQLTAfhleh+0N6g9sETF/kqvDMAKx/8QUi7uj5r24r
         g5HV0opl2lr+1ay6PDh6c2gDdOGhGAzzmHx3GvaELVy8ADYswx7r2uv3p4o9xpxZjO
         QpZGS0FaU3ijtMBXLIMC0vA1MRZpTyucflbLMmpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 21/84] hvc/xen: prevent concurrent accesses to the shared ring
Date:   Mon,  3 Apr 2023 16:08:22 +0200
Message-Id: <20230403140354.094197567@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Pau Monne <roger.pau@citrix.com>

[ Upstream commit 6214894f49a967c749ee6c07cb00f9cede748df4 ]

The hvc machinery registers both a console and a tty device based on
the hv ops provided by the specific implementation.  Those two
interfaces however have different locks, and there's no single locks
that's shared between the tty and the console implementations, hence
the driver needs to protect itself against concurrent accesses.
Otherwise concurrent calls using the split interfaces are likely to
corrupt the ring indexes, leaving the console unusable.

Introduce a lock to xencons_info to serialize accesses to the shared
ring.  This is only required when using the shared memory console,
concurrent accesses to the hypercall based console implementation are
not an issue.

Note the conditional logic in domU_read_console() is slightly modified
so the notify_daemon() call can be done outside of the locked region:
it's an hypercall and there's no need for it to be done with the lock
held.

Fixes: b536b4b96230 ('xen: use the hvc console infrastructure for Xen console')
Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20221130150919.13935-1-roger.pau@citrix.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/hvc/hvc_xen.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index 47ffb485ff34c..59d85bdd132bd 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -43,6 +43,7 @@ struct xencons_info {
 	int irq;
 	int vtermno;
 	grant_ref_t gntref;
+	spinlock_t ring_lock;
 };
 
 static LIST_HEAD(xenconsoles);
@@ -89,12 +90,15 @@ static int __write_console(struct xencons_info *xencons,
 	XENCONS_RING_IDX cons, prod;
 	struct xencons_interface *intf = xencons->intf;
 	int sent = 0;
+	unsigned long flags;
 
+	spin_lock_irqsave(&xencons->ring_lock, flags);
 	cons = intf->out_cons;
 	prod = intf->out_prod;
 	mb();			/* update queue values before going on */
 
 	if ((prod - cons) > sizeof(intf->out)) {
+		spin_unlock_irqrestore(&xencons->ring_lock, flags);
 		pr_err_once("xencons: Illegal ring page indices");
 		return -EINVAL;
 	}
@@ -104,6 +108,7 @@ static int __write_console(struct xencons_info *xencons,
 
 	wmb();			/* write ring before updating pointer */
 	intf->out_prod = prod;
+	spin_unlock_irqrestore(&xencons->ring_lock, flags);
 
 	if (sent)
 		notify_daemon(xencons);
@@ -146,16 +151,19 @@ static int domU_read_console(uint32_t vtermno, char *buf, int len)
 	int recv = 0;
 	struct xencons_info *xencons = vtermno_to_xencons(vtermno);
 	unsigned int eoiflag = 0;
+	unsigned long flags;
 
 	if (xencons == NULL)
 		return -EINVAL;
 	intf = xencons->intf;
 
+	spin_lock_irqsave(&xencons->ring_lock, flags);
 	cons = intf->in_cons;
 	prod = intf->in_prod;
 	mb();			/* get pointers before reading ring */
 
 	if ((prod - cons) > sizeof(intf->in)) {
+		spin_unlock_irqrestore(&xencons->ring_lock, flags);
 		pr_err_once("xencons: Illegal ring page indices");
 		return -EINVAL;
 	}
@@ -179,10 +187,13 @@ static int domU_read_console(uint32_t vtermno, char *buf, int len)
 		xencons->out_cons = intf->out_cons;
 		xencons->out_cons_same = 0;
 	}
+	if (!recv && xencons->out_cons_same++ > 1) {
+		eoiflag = XEN_EOI_FLAG_SPURIOUS;
+	}
+	spin_unlock_irqrestore(&xencons->ring_lock, flags);
+
 	if (recv) {
 		notify_daemon(xencons);
-	} else if (xencons->out_cons_same++ > 1) {
-		eoiflag = XEN_EOI_FLAG_SPURIOUS;
 	}
 
 	xen_irq_lateeoi(xencons->irq, eoiflag);
@@ -239,6 +250,7 @@ static int xen_hvm_console_init(void)
 		info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL);
 		if (!info)
 			return -ENOMEM;
+		spin_lock_init(&info->ring_lock);
 	} else if (info->intf != NULL) {
 		/* already configured */
 		return 0;
@@ -275,6 +287,7 @@ static int xen_hvm_console_init(void)
 
 static int xencons_info_pv_init(struct xencons_info *info, int vtermno)
 {
+	spin_lock_init(&info->ring_lock);
 	info->evtchn = xen_start_info->console.domU.evtchn;
 	/* GFN == MFN for PV guest */
 	info->intf = gfn_to_virt(xen_start_info->console.domU.mfn);
@@ -325,6 +338,7 @@ static int xen_initial_domain_console_init(void)
 		info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL);
 		if (!info)
 			return -ENOMEM;
+		spin_lock_init(&info->ring_lock);
 	}
 
 	info->irq = bind_virq_to_irq(VIRQ_CONSOLE, 0, false);
@@ -482,6 +496,7 @@ static int xencons_probe(struct xenbus_device *dev,
 	info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
+	spin_lock_init(&info->ring_lock);
 	dev_set_drvdata(&dev->dev, info);
 	info->xbdev = dev;
 	info->vtermno = xenbus_devid_to_vtermno(devid);
-- 
2.39.2




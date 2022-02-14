Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22F6A4B46DB
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244686AbiBNJma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:42:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245499AbiBNJlf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:41:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD9166F84;
        Mon, 14 Feb 2022 01:37:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED5A660FA2;
        Mon, 14 Feb 2022 09:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BADC340EF;
        Mon, 14 Feb 2022 09:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831448;
        bh=lShB54pXEsuVMdEa75Lut4GCcHf1i95uT3A0jIc9o9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3QIKaB8GCKzheZ/32TNgpIJHCrUsECMrfVbBSDXEZZWMnr5Ice9VNKsU26qPRof1
         cfE8aDHTAXdXIrnSlNfihmsdLJ434rPuRGob0yvqaK0uwrST23vymrhsczlrWfkj/R
         ed9uvhlSiDp7mbVlzHqaj6/fYuhRVC/gUWFSnx3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Keeping <john@metanate.com>,
        Pratham Pratap <quic_ppratap@quicinc.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 38/71] usb: f_fs: Fix use-after-free for epfile
Date:   Mon, 14 Feb 2022 10:26:06 +0100
Message-Id: <20220214092453.309901158@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
References: <20220214092452.020713240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Udipto Goswami <quic_ugoswami@quicinc.com>

[ Upstream commit ebe2b1add1055b903e2acd86b290a85297edc0b3 ]

Consider a case where ffs_func_eps_disable is called from
ffs_func_disable as part of composition switch and at the
same time ffs_epfile_release get called from userspace.
ffs_epfile_release will free up the read buffer and call
ffs_data_closed which in turn destroys ffs->epfiles and
mark it as NULL. While this was happening the driver has
already initialized the local epfile in ffs_func_eps_disable
which is now freed and waiting to acquire the spinlock. Once
spinlock is acquired the driver proceeds with the stale value
of epfile and tries to free the already freed read buffer
causing use-after-free.

Following is the illustration of the race:

      CPU1                                  CPU2

   ffs_func_eps_disable
   epfiles (local copy)
					ffs_epfile_release
					ffs_data_closed
					if (last file closed)
					ffs_data_reset
					ffs_data_clear
					ffs_epfiles_destroy
spin_lock
dereference epfiles

Fix this races by taking epfiles local copy & assigning it under
spinlock and if epfiles(local) is null then update it in ffs->epfiles
then finally destroy it.
Extending the scope further from the race, protecting the ep related
structures, and concurrent accesses.

Fixes: a9e6f83c2df1 ("usb: gadget: f_fs: stop sleeping in ffs_func_eps_disable")
Co-developed-by: Udipto Goswami <quic_ugoswami@quicinc.com>
Reviewed-by: John Keeping <john@metanate.com>
Signed-off-by: Pratham Pratap <quic_ppratap@quicinc.com>
Signed-off-by: Udipto Goswami <quic_ugoswami@quicinc.com>
Link: https://lore.kernel.org/r/1643256595-10797-1-git-send-email-quic_ugoswami@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c | 56 ++++++++++++++++++++++--------
 1 file changed, 42 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 2bea33b41553b..5fd4fc49aef9f 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1729,16 +1729,24 @@ static void ffs_data_put(struct ffs_data *ffs)
 
 static void ffs_data_closed(struct ffs_data *ffs)
 {
+	struct ffs_epfile *epfiles;
+	unsigned long flags;
+
 	ENTER();
 
 	if (atomic_dec_and_test(&ffs->opened)) {
 		if (ffs->no_disconnect) {
 			ffs->state = FFS_DEACTIVATED;
-			if (ffs->epfiles) {
-				ffs_epfiles_destroy(ffs->epfiles,
-						   ffs->eps_count);
-				ffs->epfiles = NULL;
-			}
+			spin_lock_irqsave(&ffs->eps_lock, flags);
+			epfiles = ffs->epfiles;
+			ffs->epfiles = NULL;
+			spin_unlock_irqrestore(&ffs->eps_lock,
+							flags);
+
+			if (epfiles)
+				ffs_epfiles_destroy(epfiles,
+						 ffs->eps_count);
+
 			if (ffs->setup_state == FFS_SETUP_PENDING)
 				__ffs_ep0_stall(ffs);
 		} else {
@@ -1785,14 +1793,27 @@ static struct ffs_data *ffs_data_new(const char *dev_name)
 
 static void ffs_data_clear(struct ffs_data *ffs)
 {
+	struct ffs_epfile *epfiles;
+	unsigned long flags;
+
 	ENTER();
 
 	ffs_closed(ffs);
 
 	BUG_ON(ffs->gadget);
 
-	if (ffs->epfiles) {
-		ffs_epfiles_destroy(ffs->epfiles, ffs->eps_count);
+	spin_lock_irqsave(&ffs->eps_lock, flags);
+	epfiles = ffs->epfiles;
+	ffs->epfiles = NULL;
+	spin_unlock_irqrestore(&ffs->eps_lock, flags);
+
+	/*
+	 * potential race possible between ffs_func_eps_disable
+	 * & ffs_epfile_release therefore maintaining a local
+	 * copy of epfile will save us from use-after-free.
+	 */
+	if (epfiles) {
+		ffs_epfiles_destroy(epfiles, ffs->eps_count);
 		ffs->epfiles = NULL;
 	}
 
@@ -1940,12 +1961,15 @@ static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
 
 static void ffs_func_eps_disable(struct ffs_function *func)
 {
-	struct ffs_ep *ep         = func->eps;
-	struct ffs_epfile *epfile = func->ffs->epfiles;
-	unsigned count            = func->ffs->eps_count;
+	struct ffs_ep *ep;
+	struct ffs_epfile *epfile;
+	unsigned short count;
 	unsigned long flags;
 
 	spin_lock_irqsave(&func->ffs->eps_lock, flags);
+	count = func->ffs->eps_count;
+	epfile = func->ffs->epfiles;
+	ep = func->eps;
 	while (count--) {
 		/* pending requests get nuked */
 		if (likely(ep->ep))
@@ -1963,14 +1987,18 @@ static void ffs_func_eps_disable(struct ffs_function *func)
 
 static int ffs_func_eps_enable(struct ffs_function *func)
 {
-	struct ffs_data *ffs      = func->ffs;
-	struct ffs_ep *ep         = func->eps;
-	struct ffs_epfile *epfile = ffs->epfiles;
-	unsigned count            = ffs->eps_count;
+	struct ffs_data *ffs;
+	struct ffs_ep *ep;
+	struct ffs_epfile *epfile;
+	unsigned short count;
 	unsigned long flags;
 	int ret = 0;
 
 	spin_lock_irqsave(&func->ffs->eps_lock, flags);
+	ffs = func->ffs;
+	ep = func->eps;
+	epfile = ffs->epfiles;
+	count = ffs->eps_count;
 	while(count--) {
 		ep->ep->driver_data = ep;
 
-- 
2.34.1




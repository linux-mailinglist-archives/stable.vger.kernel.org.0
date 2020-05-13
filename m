Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72FB21D122D
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 14:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730004AbgEMMEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 08:04:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728165AbgEMMEI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 08:04:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18DB1206E5;
        Wed, 13 May 2020 12:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589371448;
        bh=DiV0D3Gb+mopJPqtZYLn6dDxXQ/rOD7NVFWiMcoroLc=;
        h=Subject:To:From:Date:From;
        b=wD6CY/Umv+7ksaKfSimkDB+r2n4QMdvHmJVSxYLRqzKZQZywsuOHpVXFLxBvni+Ba
         ECl9MEQigTFF9vSUvFFYNta/SWAdvOGXV9F8oONAgMW8VBV12MhmF1k4qzCCefbKQp
         PS5TmLkkC2LCuPxd2kdCrp9jeugAmTFI8N/79IdM=
Subject: patch "staging: wfx: unlock on error path" added to staging-linus
To:     dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        jerome.pouiller@silabs.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 13 May 2020 14:03:58 +0200
Message-ID: <1589371438185235@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: wfx: unlock on error path

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f0b9d875faa4499afe3381404c3795e9da84bc00 Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 12 May 2020 11:36:56 +0300
Subject: staging: wfx: unlock on error path
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We need to release the tx_lock on the error path before returning.

Fixes: d1c015b4ef6f ("staging: wfx: rewrite wfx_hw_scan()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Link: https://lore.kernel.org/r/20200512083656.GA251760@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/wfx/scan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wfx/scan.c b/drivers/staging/wfx/scan.c
index 6e1e50048651..9aa14331affd 100644
--- a/drivers/staging/wfx/scan.c
+++ b/drivers/staging/wfx/scan.c
@@ -57,8 +57,10 @@ static int send_scan_req(struct wfx_vif *wvif,
 	wvif->scan_abort = false;
 	reinit_completion(&wvif->scan_complete);
 	timeout = hif_scan(wvif, req, start_idx, i - start_idx);
-	if (timeout < 0)
+	if (timeout < 0) {
+		wfx_tx_unlock(wvif->wdev);
 		return timeout;
+	}
 	ret = wait_for_completion_timeout(&wvif->scan_complete, timeout);
 	if (req->channels[start_idx]->max_power != wvif->vif->bss_conf.txpower)
 		hif_set_output_power(wvif, wvif->vif->bss_conf.txpower);
-- 
2.26.2



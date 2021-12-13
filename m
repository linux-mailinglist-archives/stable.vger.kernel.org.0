Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19235472F13
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239080AbhLMOYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:24:09 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37188 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234220AbhLMOYI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:24:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B80AFB81062
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 14:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB8FC34607;
        Mon, 13 Dec 2021 14:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639405446;
        bh=L9glz+/XipxIqYP0SgJraBEc2HXyFM/KMLvsj1UZBaY=;
        h=Subject:To:From:Date:From;
        b=PRObdaN2ltiLckKAlCX3YgyZBx32RL+nokhxUUTv+daIbm36Rh43+TdxWnc7+glUT
         LkTfwlt3sZ1uePvhP8d4AilkR2qmwwIbM3Xz1aLNyOvj9QpymmMYsudKzCJc0enksK
         VU/ZQZcFHHJn64tlxIO3eN2j5/qt//riv/iU7exw=
Subject: patch "usb: cdnsp: Fix incorrect status for control request" added to usb-linus
To:     pawell@cadence.com, gregkh@linuxfoundation.org,
        jianhe@ambarella.com, peter.chen@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Dec 2021 15:23:51 +0100
Message-ID: <163940543114348@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdnsp: Fix incorrect status for control request

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 99ea221f2e2f2743314e348b25c1e2574b467528 Mon Sep 17 00:00:00 2001
From: Pawel Laszczak <pawell@cadence.com>
Date: Tue, 7 Dec 2021 10:18:38 +0100
Subject: usb: cdnsp: Fix incorrect status for control request

Patch fixes incorrect status for control request.
Without this fix all usb_request objects were returned to upper drivers
with usb_reqest->status field set to -EINPROGRESS.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
cc: <stable@vger.kernel.org>
Reported-by: Ken (Jian) He <jianhe@ambarella.com>
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20211207091838.39572-1-pawell@gli-login.cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-ring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
index e1ac6c398bd3..e45c3d6e1536 100644
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -1029,6 +1029,8 @@ static void cdnsp_process_ctrl_td(struct cdnsp_device *pdev,
 		return;
 	}
 
+	*status = 0;
+
 	cdnsp_finish_td(pdev, td, event, pep, status);
 }
 
-- 
2.34.1



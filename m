Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC92834012C
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 09:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhCRIs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 04:48:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229828AbhCRIsE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Mar 2021 04:48:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AAF364EF9;
        Thu, 18 Mar 2021 08:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616057283;
        bh=Rgp0vLXfAlwbOLAmaH2shrcI033Ktm3FOKCAuvMqhcg=;
        h=Subject:To:From:Date:From;
        b=uwDoRllBAA+MdwEsNFaue73JRaJskTcWGpsUe/7MED27FkdPWg7UlNtm3hhUk5ZuX
         0aeVaH0/zo7Yq1FtLbxQ4RT9Yu/G8n18PGUQFudpGUbbUELD1IHmLeiBlsMmyYWclL
         H7cyPA6pIEKPYAAVlR45G+nGgF0AA+UfWXseeA6U=
Subject: patch "usb: typec: tcpm: Skip sink_cap query only when VDM sm is busy" added to usb-linus
To:     badhri@google.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 18 Mar 2021 09:48:01 +0100
Message-ID: <161605728113014@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpm: Skip sink_cap query only when VDM sm is busy

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 2b8c956ea6ba896ec18ae36c2684ecfa04c1f479 Mon Sep 17 00:00:00 2001
From: Badhri Jagan Sridharan <badhri@google.com>
Date: Wed, 17 Mar 2021 23:48:05 -0700
Subject: usb: typec: tcpm: Skip sink_cap query only when VDM sm is busy

When port partner responds "Not supported" to the DiscIdentity command,
VDM state machine can remain in NVDM_STATE_ERR_TMOUT and this causes
querying sink cap to be skipped indefinitely. Hence check for
vdm_sm_running instead of checking for VDM_STATE_DONE.

Fixes: 8dc4bd073663f ("usb: typec: tcpm: Add support for Sink Fast Role SWAP(FRS)")
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210318064805.3747831-1-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 92093ea12cff..ce7af398c7c1 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -5173,7 +5173,7 @@ static void tcpm_enable_frs_work(struct kthread_work *work)
 		goto unlock;
 
 	/* Send when the state machine is idle */
-	if (port->state != SNK_READY || port->vdm_state != VDM_STATE_DONE || port->send_discover)
+	if (port->state != SNK_READY || port->vdm_sm_running || port->send_discover)
 		goto resched;
 
 	port->upcoming_state = GET_SINK_CAP;
-- 
2.30.2



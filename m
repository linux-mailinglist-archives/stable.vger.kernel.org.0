Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7E2158357
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 20:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgBJTOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 14:14:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:44288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726831AbgBJTOp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 14:14:45 -0500
Received: from localhost (unknown [104.132.1.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AA992051A;
        Mon, 10 Feb 2020 19:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581362084;
        bh=CvySMsScrVihvsr/jU+E2pufhOALv6JzU3bLZ76cqGo=;
        h=Subject:To:From:Date:From;
        b=vVV8yWOqO8mm7wgg3Uo/oIORAcrQ7x5AhSgXEhhu1Lq0ZO2SZkqCFcxaCUqFuLGMd
         N69ZKLhF94YOSTfcfiGlaCXt3NevK9C2QEY86sOxfdGkFP8nWjVBAi5mR8r+mdLqWi
         +OrkhjhiEJ8uxnzj56yv5lychYvSgfQDP5YmWQNg=
Subject: patch "usb: dwc3: debug: fix string position formatting mixup with ret and" added to usb-linus
To:     colin.king@canonical.com, dan.carpenter@oracle.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 Feb 2020 11:14:43 -0800
Message-ID: <1581362083183122@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: debug: fix string position formatting mixup with ret and

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b32196e35bd7bbc8038db1aba1fbf022dc469b6a Mon Sep 17 00:00:00 2001
From: Colin Ian King <colin.king@canonical.com>
Date: Mon, 10 Feb 2020 09:51:39 +0000
Subject: usb: dwc3: debug: fix string position formatting mixup with ret and
 len

Currently the string formatting is mixing up the offset of ret and
len. Re-work the code to use just len, remove ret and use scnprintf
instead of snprintf and len position accumulation where required.
Remove the -ve return check since scnprintf never returns a failure
-ve size. Also break overly long lines to clean up checkpatch
warnings.

Addresses-Coverity: ("Unused value")
Fixes: 1381a5113caf ("usb: dwc3: debug: purge usage of strcat")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200210095139.328711-1-colin.king@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/debug.h | 39 +++++++++++++++------------------------
 1 file changed, 15 insertions(+), 24 deletions(-)

diff --git a/drivers/usb/dwc3/debug.h b/drivers/usb/dwc3/debug.h
index e56beb9d1e36..4a13ceaf4093 100644
--- a/drivers/usb/dwc3/debug.h
+++ b/drivers/usb/dwc3/debug.h
@@ -256,86 +256,77 @@ static inline const char *dwc3_ep_event_string(char *str, size_t size,
 	u8 epnum = event->endpoint_number;
 	size_t len;
 	int status;
-	int ret;
 
-	ret = snprintf(str, size, "ep%d%s: ", epnum >> 1,
+	len = scnprintf(str, size, "ep%d%s: ", epnum >> 1,
 			(epnum & 1) ? "in" : "out");
-	if (ret < 0)
-		return "UNKNOWN";
 
 	status = event->status;
 
 	switch (event->endpoint_event) {
 	case DWC3_DEPEVT_XFERCOMPLETE:
-		len = strlen(str);
-		snprintf(str + len, size - len, "Transfer Complete (%c%c%c)",
+		len += scnprintf(str + len, size - len,
+				"Transfer Complete (%c%c%c)",
 				status & DEPEVT_STATUS_SHORT ? 'S' : 's',
 				status & DEPEVT_STATUS_IOC ? 'I' : 'i',
 				status & DEPEVT_STATUS_LST ? 'L' : 'l');
 
-		len = strlen(str);
-
 		if (epnum <= 1)
-			snprintf(str + len, size - len, " [%s]",
+			scnprintf(str + len, size - len, " [%s]",
 					dwc3_ep0_state_string(ep0state));
 		break;
 	case DWC3_DEPEVT_XFERINPROGRESS:
-		len = strlen(str);
-
-		snprintf(str + len, size - len, "Transfer In Progress [%d] (%c%c%c)",
+		scnprintf(str + len, size - len,
+				"Transfer In Progress [%d] (%c%c%c)",
 				event->parameters,
 				status & DEPEVT_STATUS_SHORT ? 'S' : 's',
 				status & DEPEVT_STATUS_IOC ? 'I' : 'i',
 				status & DEPEVT_STATUS_LST ? 'M' : 'm');
 		break;
 	case DWC3_DEPEVT_XFERNOTREADY:
-		len = strlen(str);
-
-		snprintf(str + len, size - len, "Transfer Not Ready [%d]%s",
+		len += scnprintf(str + len, size - len,
+				"Transfer Not Ready [%d]%s",
 				event->parameters,
 				status & DEPEVT_STATUS_TRANSFER_ACTIVE ?
 				" (Active)" : " (Not Active)");
 
-		len = strlen(str);
-
 		/* Control Endpoints */
 		if (epnum <= 1) {
 			int phase = DEPEVT_STATUS_CONTROL_PHASE(event->status);
 
 			switch (phase) {
 			case DEPEVT_STATUS_CONTROL_DATA:
-				snprintf(str + ret, size - ret,
+				scnprintf(str + len, size - len,
 						" [Data Phase]");
 				break;
 			case DEPEVT_STATUS_CONTROL_STATUS:
-				snprintf(str + ret, size - ret,
+				scnprintf(str + len, size - len,
 						" [Status Phase]");
 			}
 		}
 		break;
 	case DWC3_DEPEVT_RXTXFIFOEVT:
-		snprintf(str + ret, size - ret, "FIFO");
+		scnprintf(str + len, size - len, "FIFO");
 		break;
 	case DWC3_DEPEVT_STREAMEVT:
 		status = event->status;
 
 		switch (status) {
 		case DEPEVT_STREAMEVT_FOUND:
-			snprintf(str + ret, size - ret, " Stream %d Found",
+			scnprintf(str + len, size - len, " Stream %d Found",
 					event->parameters);
 			break;
 		case DEPEVT_STREAMEVT_NOTFOUND:
 		default:
-			snprintf(str + ret, size - ret, " Stream Not Found");
+			scnprintf(str + len, size - len, " Stream Not Found");
 			break;
 		}
 
 		break;
 	case DWC3_DEPEVT_EPCMDCMPLT:
-		snprintf(str + ret, size - ret, "Endpoint Command Complete");
+		scnprintf(str + len, size - len, "Endpoint Command Complete");
 		break;
 	default:
-		snprintf(str, size, "UNKNOWN");
+		scnprintf(str + len, size - len, "UNKNOWN");
 	}
 
 	return str;
-- 
2.25.0



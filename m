Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCFEB9268
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387890AbfITOcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:32:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36560 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388308AbfITOZL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:11 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqP-0004xe-2O; Fri, 20 Sep 2019 15:25:09 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqF-0007vZ-VH; Fri, 20 Sep 2019 15:24:59 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mario Limonciello" <mario.limonciello@dell.com>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        "Dan Carpenter" <dan.carpenter@oracle.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.837758257@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 087/132] platform/x86: alienware-wmi: printing the
 wrong error code
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 6d1f8b3d75419a8659ac916a1e9543bb3513a882 upstream.

The "out_data" variable is uninitialized at the point.  Originally, this
used to print "status" instead and that seems like the correct thing to
print.

Fixes: bc2ef884320b ("alienware-wmi: For WMAX HDMI method, introduce a way to query HDMI cable status")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Mario Limonciello <mario.limonciello@dell.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/platform/x86/alienware-wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/alienware-wmi.c
+++ b/drivers/platform/x86/alienware-wmi.c
@@ -494,7 +494,7 @@ static ssize_t show_hdmi_source(struct d
 			return scnprintf(buf, PAGE_SIZE,
 					 "input [gpu] unknown\n");
 	}
-	pr_err("alienware-wmi: unknown HDMI source status: %d\n", out_data);
+	pr_err("alienware-wmi: unknown HDMI source status: %u\n", status);
 	return scnprintf(buf, PAGE_SIZE, "input gpu [unknown]\n");
 }
 


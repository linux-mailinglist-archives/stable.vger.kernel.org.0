Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F02D1B6823
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729059AbgDWXMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:12:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50050 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728509AbgDWXGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:51 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvY-0004mS-Gf; Fri, 24 Apr 2020 00:06:40 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvU-00E6uq-8p; Fri, 24 Apr 2020 00:06:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Xiang Chen" <chenxiang66@hisilicon.com>
Date:   Fri, 24 Apr 2020 00:06:34 +0100
Message-ID: <lsq.1587683028.702346965@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 167/245] scsi: sd: Clear sdkp->protection_type if
 disk is reformatted without PI
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Chen <chenxiang66@hisilicon.com>

commit 465f4edaecc6c37f81349233e84d46246bcac11a upstream.

If an attached disk with protection information enabled is reformatted
to Type 0 the revalidation code does not clear the original protection
type and subsequent accesses will keep setting RDPROTECT/WRPROTECT.

Set the protection type to 0 if the disk reports PROT_EN=0 in READ
CAPACITY(16).

[mkp: commit desc]

Fixes: fe542396da73 ("[SCSI] sd: Ensure we correctly disable devices with unknown protection type")
Link: https://lore.kernel.org/r/1578532344-101668-1-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/sd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1910,8 +1910,10 @@ static int sd_read_protection_type(struc
 	u8 type;
 	int ret = 0;
 
-	if (scsi_device_protection(sdp) == 0 || (buffer[12] & 1) == 0)
+	if (scsi_device_protection(sdp) == 0 || (buffer[12] & 1) == 0) {
+		sdkp->protection_type = 0;
 		return ret;
+	}
 
 	type = ((buffer[12] >> 1) & 7) + 1; /* P_TYPE 0 = Type 1 */
 


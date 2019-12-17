Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 901A8122006
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbfLQAvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:51:31 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34476 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726313AbfLQAvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:31 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15E-0003Ia-AD; Tue, 17 Dec 2019 00:51:28 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15D-0005Rj-GT; Tue, 17 Dec 2019 00:51:27 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Oliver Neukum" <oneukum@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Date:   Tue, 17 Dec 2019 00:45:40 +0000
Message-ID: <lsq.1576543535.191587988@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 006/136] scsi: sd: Ignore a failure to sync cache due
 to lack of authorization
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 21e3d6c81179bbdfa279efc8de456c34b814cfd2 upstream.

I've got a report about a UAS drive enclosure reporting back Sense: Logical
unit access not authorized if the drive it holds is password protected.
While the drive is obviously unusable in that state as a mass storage
device, it still exists as a sd device and when the system is asked to
perform a suspend of the drive, it will be sent a SYNCHRONIZE CACHE. If
that fails due to password protection, the error must be ignored.

Link: https://lore.kernel.org/r/20190903101840.16483-1-oneukum@suse.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[bwh: Backported to 3.16: sshdr is a struct not a pointer here]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/sd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1470,7 +1470,8 @@ static int sd_sync_cache(struct scsi_dis
 		/* we need to evaluate the error return  */
 		if (scsi_sense_valid(&sshdr) &&
 			(sshdr.asc == 0x3a ||	/* medium not present */
-			 sshdr.asc == 0x20))	/* invalid command */
+			 sshdr.asc == 0x20 ||	/* invalid command */
+			 (sshdr.asc == 0x74 && sshdr.ascq == 0x71)))	/* drive is password locked */
 				/* this is no error here */
 				return 0;
 


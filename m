Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A59E1161D6
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfLHNyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:54:46 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60434 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726879AbfLHNyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:45 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1G-0007hP-6V; Sun, 08 Dec 2019 13:54:42 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1E-0002PB-U8; Sun, 08 Dec 2019 13:54:40 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Navid Emamdoost" <navid.emamdoost@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Date:   Sun, 08 Dec 2019 13:53:43 +0000
Message-ID: <lsq.1575813165.251391907@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 59/72] scsi: bfa: release allocated memory in case of
 error
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit 0e62395da2bd5166d7c9e14cbc7503b256a34cb0 upstream.

In bfad_im_get_stats if bfa_port_get_stats fails, allocated memory needs to
be released.

Link: https://lore.kernel.org/r/20190910234417.22151-1-navid.emamdoost@gmail.com
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/bfa/bfad_attr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -282,8 +282,10 @@ bfad_im_get_stats(struct Scsi_Host *shos
 	rc = bfa_port_get_stats(BFA_FCPORT(&bfad->bfa),
 				fcstats, bfad_hcb_comp, &fcomp);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
-	if (rc != BFA_STATUS_OK)
+	if (rc != BFA_STATUS_OK) {
+		kfree(fcstats);
 		return NULL;
+	}
 
 	wait_for_completion(&fcomp.comp);
 


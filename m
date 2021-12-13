Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC92472667
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235097AbhLMJve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:51:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35130 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236362AbhLMJtc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:49:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9E65B80E15;
        Mon, 13 Dec 2021 09:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196EBC00446;
        Mon, 13 Dec 2021 09:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388969;
        bh=6vupwk4iuoLddn3076TMeCNd9kwtzeIX4eLL5bHWMTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yc0comwQIjuUeznp31f+rpFOHKeYcd71s5dHg6kwSnFvlcc66jMpr0jXPDkb2qwX+
         pkneBtg+AI1a5bxgVYv1UVQVzIgW6FmcD9J4/nYCuFpcTZNt/ylBY0oHubNtQm2mPr
         S7qjio1yL1IvUBlIO10ep4xUJbSw9Dx78BwHVNrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vishakha Channapattan <vishakhavc@google.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Igor Pylypiv <ipylypiv@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 072/132] scsi: pm80xx: Do not call scsi_remove_host() in pm8001_alloc()
Date:   Mon, 13 Dec 2021 10:30:13 +0100
Message-Id: <20211213092941.582274471@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Igor Pylypiv <ipylypiv@google.com>

commit 653926205741add87a6cf452e21950eebc6ac10b upstream.

Calling scsi_remove_host() before scsi_add_host() results in a crash:

 BUG: kernel NULL pointer dereference, address: 0000000000000108
 RIP: 0010:device_del+0x63/0x440
 Call Trace:
  device_unregister+0x17/0x60
  scsi_remove_host+0xee/0x2a0
  pm8001_pci_probe+0x6ef/0x1b90 [pm80xx]
  local_pci_probe+0x3f/0x90

We cannot call scsi_remove_host() in pm8001_alloc() because scsi_add_host()
has not been called yet at that point in time.

Function call tree:

  pm8001_pci_probe()
  |
  `- pm8001_pci_alloc()
  |  |
  |  `- pm8001_alloc()
  |     |
  |     `- scsi_remove_host()
  |
  `- scsi_add_host()

Link: https://lore.kernel.org/r/20211201041627.1592487-1-ipylypiv@google.com
Fixes: 05c6c029a44d ("scsi: pm80xx: Increase number of supported queues")
Reviewed-by: Vishakha Channapattan <vishakhavc@google.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/pm8001/pm8001_init.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -280,12 +280,12 @@ static int pm8001_alloc(struct pm8001_hb
 	if (rc) {
 		pm8001_dbg(pm8001_ha, FAIL,
 			   "pm8001_setup_irq failed [ret: %d]\n", rc);
-		goto err_out_shost;
+		goto err_out;
 	}
 	/* Request Interrupt */
 	rc = pm8001_request_irq(pm8001_ha);
 	if (rc)
-		goto err_out_shost;
+		goto err_out;
 
 	count = pm8001_ha->max_q_num;
 	/* Queues are chosen based on the number of cores/msix availability */
@@ -419,8 +419,6 @@ static int pm8001_alloc(struct pm8001_hb
 	pm8001_tag_init(pm8001_ha);
 	return 0;
 
-err_out_shost:
-	scsi_remove_host(pm8001_ha->shost);
 err_out_nodev:
 	for (i = 0; i < pm8001_ha->max_memcnt; i++) {
 		if (pm8001_ha->memoryMap.region[i].virt_ptr != NULL) {



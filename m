Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 782ED17DD42
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 11:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725796AbgCIKRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 06:17:43 -0400
Received: from mail-ed1-f43.google.com ([209.85.208.43]:46677 "EHLO
        mail-ed1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgCIKRn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 06:17:43 -0400
Received: by mail-ed1-f43.google.com with SMTP id ca19so2353226edb.13
        for <stable@vger.kernel.org>; Mon, 09 Mar 2020 03:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=y9lWFuYotbnSp10glrvwH/tdSEv+SA+99ng+nKIV30o=;
        b=irtT91WWOSjZs2rsaeTqdXwiTKOwjVxhETPnCtmdVcOEyDAfWELbKZEu2/h806chqN
         Aa2PP9tZlP1e4PonltPWAjNXshFSqHQzoJxdFcEgkPGl8PrG6/e8Jx0gsYtRDdyvjeKW
         2Rx5gvCG1qApsuDl+FHOCIQvX35Mn94a78cKkptd9yP7X4pVgbrv/rkCLErChOqFjhRt
         U21+qyNGRiAy4ZjFGOgSoehnLh3EecLfRHPKc3vOb2Hqbw0G0Q9WkxeOtL6jeZ6/tbFr
         GkvAH17sarzTCWyeNOUDTy9oNUX7LMYbDW4DC0pxryvBRbiF9WIQVpbeSnT/u8qdpKLp
         XZnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=y9lWFuYotbnSp10glrvwH/tdSEv+SA+99ng+nKIV30o=;
        b=nCCcl0vUZmMt2wXqhpjE9ee9xY+YiTVPf9zURKRxNTFN9ijXlkAyrwwJoTaIgCCFTe
         LCNghy25kGztnNkLnKQME4QKyW0HsLqQU5HBIZXM6oUkuK6tw/vv4vCJZy5LH7EuG7iy
         WJA0daIQdvj4y7vueeD+cEXXsraAbUlgfpZfnnUxlCK8anyssxblwuXI0AGcrmjCxCDq
         hbh0KP6eIjDxp8CNs3IUHJMa6Z9Q7VcIoU11PO+M7jj+vh8a/k3A19fPtuSz0z2o5/TT
         YKfJbuGcurRQf/k2YtqOct4ZdqkmJcC63hqwP8WHtsNHtmdieAnB13qs4AB2XhJ9lM+N
         cYFw==
X-Gm-Message-State: ANhLgQ3Mmg/Bb4KvMbF5BEAgOMOCgaDyq8wgNQ6MXpMLrFU/vTtz7vlg
        h7POVXz564Ta8Dcq84fsqEr+212naeQ=
X-Google-Smtp-Source: ADFU+vvDdF65s/4UvR4/r0+W6e1tpjFGcozKG13Puc2KLYeccc3U2wrnH4tj/4CCucj05SdkktiSYA==
X-Received: by 2002:a50:9d06:: with SMTP id v6mr10395552ede.189.1583749061566;
        Mon, 09 Mar 2020 03:17:41 -0700 (PDT)
Received: from jwang-Latitude-5491.pb.local ([2001:1438:4010:2558:1934:edf1:9b2c:8a6c])
        by smtp.gmail.com with ESMTPSA id p20sm1317409ejf.6.2020.03.09.03.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 03:17:41 -0700 (PDT)
From:   Jack Wang <jinpu.wang@cloud.ionos.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Viswas G <Viswas.G@microsemi.com>,
        Deepak Ukey <deepak.ukey@microsemi.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [stable-4.19 1/2] scsi: pm80xx: panic on ncq error cleaning up the read log.
Date:   Mon,  9 Mar 2020 11:17:38 +0100
Message-Id: <20200309101739.32483-2-jinpu.wang@cloud.ionos.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200309101739.32483-1-jinpu.wang@cloud.ionos.com>
References: <20200309101739.32483-1-jinpu.wang@cloud.ionos.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viswas G <Viswas.G@microsemi.com>

commit 0b6df110b3d0c12562011fcd032cfb6ff16b6d56 upstream

when there's an error in 'ncq mode' the host has to read the ncq error
log (10h) to clear the error state. however, the ccb that is setup for
doing this doesn't setup the ccb so that the previous state is
cleared. if the ccb was previously used for an IO n_elems is set and
pm8001_ccb_task_free() treats this as the signal to go free a
scatter-gather list (that's already been freed).

Signed-off-by: Deepak Ukey <deepak.ukey@microsemi.com>
Signed-off-by: Viswas G <Viswas.G@microsemi.com>
Acked-by: Jack Wang <jinpu.wang@profitbricks.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 8627feb80261..bd945d832eb8 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1500,8 +1500,9 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	ccb->ccb_tag = ccb_tag;
 	ccb->task = task;
 	ccb->n_elem = 0;
-	pm8001_ha_dev->id |= NCQ_READ_LOG_FLAG;
-	pm8001_ha_dev->id |= NCQ_2ND_RLE_FLAG;
+	pm8001_ha_dev->id |= NCQ_READ_LOG_FLAG;	// set this flag to indicate read log
+	pm8001_ha_dev->id |= NCQ_2ND_RLE_FLAG;	// set this flag to guard against 2nd RLE. Workaround 
+						// till FW fix is available. 
 
 	memset(&sata_cmd, 0, sizeof(sata_cmd));
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
-- 
2.17.1


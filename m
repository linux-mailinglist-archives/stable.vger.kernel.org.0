Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D312A5207
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731133AbgKCUqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:46:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:35036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729851AbgKCUqE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:46:04 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C731D223FD;
        Tue,  3 Nov 2020 20:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436364;
        bh=vYNjNsP1G2vZoouKPMCZ7fRCdGXUHmDmCr/9+CYnFOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q9ZvLbOYSlWC3gHId4iaYwgvxxsTCGEHiKi2zCBay7j1ug1pt6taIfyKnZY+3uH+1
         RKDb8CqWutQhugZp7otvPbVv4LxkK6GQD2pX0oqRiIAgoF5KGAQmo9ZklZDWbDxJfv
         pcrwAR1LEt38WViHGoaaITrZrrC+L2fNeVZROf9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.9 217/391] scsi: qla2xxx: Fix MPI reset needed message
Date:   Tue,  3 Nov 2020 21:34:28 +0100
Message-Id: <20201103203401.576798835@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

commit 7a6cdbd5e87515ebf6231b762ad903c7cff87b9c upstream.

When printing the message:

  "MPI Heartbeat stop. MPI reset is not needed.."

..the wrong register was checked leading to always printing that MPI reset
is not needed, even when it is needed. Fix the MPI reset message.

Link: https://lore.kernel.org/r/20200929102152.32278-4-njavali@marvell.com
Fixes: cbb01c2f2f63 ("scsi: qla2xxx: Fix MPI failure AEN (8200) handling")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_isr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -767,7 +767,7 @@ qla27xx_handle_8200_aen(scsi_qla_host_t
 	ql_log(ql_log_warn, vha, 0x02f0,
 	       "MPI Heartbeat stop. MPI reset is%s needed. "
 	       "MB0[%xh] MB1[%xh] MB2[%xh] MB3[%xh]\n",
-	       mb[0] & BIT_8 ? "" : " not",
+	       mb[1] & BIT_8 ? "" : " not",
 	       mb[0], mb[1], mb[2], mb[3]);
 
 	if ((mb[1] & BIT_8) == 0)



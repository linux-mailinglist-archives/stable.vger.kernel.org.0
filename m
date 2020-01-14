Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 288C313A67E
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731750AbgANKLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:11:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:47402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728983AbgANKLr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:11:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A96E524689;
        Tue, 14 Jan 2020 10:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996707;
        bh=k7kjU9j0TYsN5f6EiBfMNCH3voyuC2Mmp1NyQsEfLoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eFwUdS+uTwBuuuI1GoWjsyvdm0dsor/co/Xbx63iWwHWmMcNqmhMHLa+LiFsenyk/
         j7tSoT3B0ScFUh9wdxMQHY3rAlaByB/qecT5Ez9klJu0JR2C9AamFm7UTVeYQC4rb5
         B8Qu3Yfs2zj2MNwH/Vn6AYCIAMfHzdf0jXaQXOY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.9 27/31] scsi: bfa: release allocated memory in case of error
Date:   Tue, 14 Jan 2020 11:02:19 +0100
Message-Id: <20200114094345.035651201@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094334.725604663@linuxfoundation.org>
References: <20200114094334.725604663@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit 0e62395da2bd5166d7c9e14cbc7503b256a34cb0 upstream.

In bfad_im_get_stats if bfa_port_get_stats fails, allocated memory needs to
be released.

Link: https://lore.kernel.org/r/20190910234417.22151-1-navid.emamdoost@gmail.com
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/bfa/bfad_attr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -283,8 +283,10 @@ bfad_im_get_stats(struct Scsi_Host *shos
 	rc = bfa_port_get_stats(BFA_FCPORT(&bfad->bfa),
 				fcstats, bfad_hcb_comp, &fcomp);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
-	if (rc != BFA_STATUS_OK)
+	if (rc != BFA_STATUS_OK) {
+		kfree(fcstats);
 		return NULL;
+	}
 
 	wait_for_completion(&fcomp.comp);
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C4538A2C1
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233221AbhETJpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:45:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233646AbhETJnW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:43:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A8DB61440;
        Thu, 20 May 2021 09:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503168;
        bh=KBgj9Whg8NcgLbUX2Xtc1vIJqOwTMWowVEg19JRHroA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/fM7f3FIj0/NZtusvK6KDCO+A2z7i4ulcebSC7NBm5Nfi6r5iQcqv1/jyRNq7mGI
         tsZ/AIV3MrttWQRQui4DbAXvX/OlAWUGEtgnbNGN0C0UIsWEvrQ1NzGMTg1UQzoyno
         ngeZN7w6aJXHMYjbf4NKFzzkNBmSxxSedI2rOYwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 072/425] scsi: libfc: Fix a format specifier
Date:   Thu, 20 May 2021 11:17:21 +0200
Message-Id: <20210520092133.817573446@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 90d6697810f06aceea9de71ad836a8c7669789cd ]

Since the 'mfs' member has been declared as 'u32' in include/scsi/libfc.h,
use the %u format specifier instead of %hu. This patch fixes the following
clang compiler warning:

warning: format specifies type
      'unsigned short' but the argument has type 'u32' (aka 'unsigned int')
      [-Wformat]
                             "lport->mfs:%hu\n", mfs, lport->mfs);
                                         ~~~          ^~~~~~~~~~
                                         %u

Link: https://lore.kernel.org/r/20210415220826.29438-8-bvanassche@acm.org
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libfc/fc_lport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index ff943f477d6f..f653109d56af 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1741,7 +1741,7 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	if (mfs < FC_SP_MIN_MAX_PAYLOAD || mfs > FC_SP_MAX_MAX_PAYLOAD) {
 		FC_LPORT_DBG(lport, "FLOGI bad mfs:%hu response, "
-			     "lport->mfs:%hu\n", mfs, lport->mfs);
+			     "lport->mfs:%u\n", mfs, lport->mfs);
 		fc_lport_error(lport, fp);
 		goto out;
 	}
-- 
2.30.2




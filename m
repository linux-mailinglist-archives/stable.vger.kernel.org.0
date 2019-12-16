Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57DD212125D
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 18:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbfLPRwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:52:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:43190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727337AbfLPRwE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:52:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 936F821739;
        Mon, 16 Dec 2019 17:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518724;
        bh=nqVOCcvzWOMIqqzTT2laj68lZle9/3vcD0fMWng/tfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=foCFgxKlbqoDtGIQaddBFBBNaXN7X0tCD+otZ0BiUlInATPlJTLoZpqIR368ze4le
         7IxmJsL+2sve2N5/yBAtPEHSXo0sawOPYfjXj43tEOTx2zdBRAatxg0juNhNME1SnX
         jvuHmLmcIn+z9i2CoY0jiy1ARNpIZcfSofJuYO1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 040/267] scsi: zfcp: drop default switch case which might paper over missing case
Date:   Mon, 16 Dec 2019 18:46:06 +0100
Message-Id: <20191216174853.280722981@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steffen Maier <maier@linux.ibm.com>

[ Upstream commit 0c902936e55cff9335b27ed632fc45e7115ced75 ]

This was introduced with v4.18 commit 8c3d20aada70 ("scsi: zfcp: fix
missing REC trigger trace for all objects in ERP_FAILED") but would now
suppress helpful -Wswitch compiler warnings when building with W=1 such as
the following forced example:

drivers/s390/scsi/zfcp_erp.c: In function 'zfcp_erp_handle_failed':
drivers/s390/scsi/zfcp_erp.c:126:2: warning: enumeration value 'ZFCP_ERP_ACTION_REOPEN_PORT_FORCED' not handled in switch [-Wswitch]
  switch (want) {
  ^~~~~~

But then again, only with W=1 we would notice unhandled enum cases.
Without the default cases and a missed unhandled enum case, the code might
perform unforeseen things we might not want...

As of today, we never run through the removed default case, so removing it
is no functional change.  In the future, we never should run through a
default case but introduce the necessary specific case(s) to handle new
functionality.

Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/scsi/zfcp_erp.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 64d70de98cdb6..8f90e4cea2545 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -179,9 +179,6 @@ static int zfcp_erp_handle_failed(int want, struct zfcp_adapter *adapter,
 				adapter, ZFCP_STATUS_COMMON_ERP_FAILED);
 		}
 		break;
-	default:
-		need = 0;
-		break;
 	}
 
 	return need;
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22F7A73D2B
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404309AbfGXTyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:54:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404310AbfGXTyR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:54:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FDDF20665;
        Wed, 24 Jul 2019 19:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998056;
        bh=LOARK0T404+azY1suHxq6Tt9I+LxkICd8FbLI+35sfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GSk74EDIvolqs+8zWCKmz7346Ko7+m5rcyMTUR1NaIghE/DzXjksreQ+umk/R+s52
         cZAofc1FgNiWFPVfihpMN0NnnphODD2SdT326z7dphja6WkTGJ8o86y7I+r1PzHF3E
         IMfHtebNzsbvwpJK//9qPUyYza2QUtJOwqn2qfvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Stan Johnson <userm57@yahoo.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.1 231/371] Revert "scsi: ncr5380: Increase register polling limit"
Date:   Wed, 24 Jul 2019 21:19:43 +0200
Message-Id: <20190724191741.855280714@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

commit 25fcf94a2fa89dd3e73e965ebb0b38a2a4f72aa4 upstream.

This reverts commit 4822827a69d7cd3bc5a07b7637484ebd2cf88db6.

The purpose of that commit was to suppress a timeout warning message which
appeared to be caused by target latency. But suppressing the warning is
undesirable as the warning may indicate a messed up transfer count.

Another problem with that commit is that 15 ms is too long to keep
interrupts disabled as interrupt latency can cause system clock drift and
other problems.

Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: stable@vger.kernel.org
Fixes: 4822827a69d7 ("scsi: ncr5380: Increase register polling limit")
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Tested-by: Stan Johnson <userm57@yahoo.com>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/NCR5380.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -235,7 +235,7 @@ struct NCR5380_cmd {
 #define NCR5380_PIO_CHUNK_SIZE		256
 
 /* Time limit (ms) to poll registers when IRQs are disabled, e.g. during PDMA */
-#define NCR5380_REG_POLL_TIME		15
+#define NCR5380_REG_POLL_TIME		10
 
 static inline struct scsi_cmnd *NCR5380_to_scmd(struct NCR5380_cmd *ncmd_ptr)
 {



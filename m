Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61150FAA4F
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 07:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbfKMGj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 01:39:56 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38835 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbfKMGj4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Nov 2019 01:39:56 -0500
Received: by mail-pf1-f193.google.com with SMTP id c13so952672pfp.5
        for <stable@vger.kernel.org>; Tue, 12 Nov 2019 22:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IELyr1Q+i9Wzh04c8H0SAI7IsNk+BvT60IddXtdHRsA=;
        b=cdHKxe2ivVUQXP3tgqePAJnJAKTIOFTiq0Ue0RQuM0c9xltCwwkbpf8ClyNaiQKB8w
         1Ua0FOunnou5NMAGbL+X7ZH8l2al95C/eARFHR5L2pIjiqLhkRnsn5DK9U9Snc4gTb13
         Va3iRbhLW6dB0Cto9rwYsDK3cq9X1txvovbVkNPmDddt8mBWQEbw28/ihrkw/GRMYQae
         4zf07ki5dIYoiaYFvFBhyQ6FP37pDZ/HX76jW41DytvH/XCYdWhgWQXLi21CHsu/X1Z9
         AQK0HE/xThFicYexuBiBXSL9wTeQRm6i5g5ixqtjU/zlLO2wrMh1e4cKc860ok74WEKp
         myyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IELyr1Q+i9Wzh04c8H0SAI7IsNk+BvT60IddXtdHRsA=;
        b=SZxSp5Tt8jPiQ5eRo+w+3g+ifXWSRLXK2GpiYjVl810qc4Nt9K193sXXIw9hF1H4XV
         2/fozizjP27F4jKdSwdus7jlan6sfN6C6hCXJWQX1SZHsml3bkzvwKFvLuuEMvIJ8zSH
         Sr2Az4ZMWXVNABNaSO3Q7b5DzanppK64AWMPKSKS8Km27gbP++Qza1bIZngfMZgkogJH
         yiAzWbV0Lc6VuRqSsjf3AeZyNlZcon3EcK4oGkUglwLnF7uGQHT2mC4SnaBlCyQuqaWY
         bWDUyMlxMl60gjWT4pJoAZf0GrgXE9+Ow7UK3QX8wU8cOTai7J4fqc1fghy/zzYcsCvP
         LK8g==
X-Gm-Message-State: APjAAAWLWQNi6tKgUzbzeZut+E7ppzdETe1qoxRaJ/mSAgQPDBpSmlKd
        M8qUYU0rsJn+Obo+W+4+g0w=
X-Google-Smtp-Source: APXvYqxvXt7L0XpRhfF5ewQCghKLAnl17TAIXGI5ZVyGyv5u8LsPHcWcFXPPEQOZ5iJY+tggivTo1w==
X-Received: by 2002:a17:90a:aa96:: with SMTP id l22mr2543270pjq.112.1573627195655;
        Tue, 12 Nov 2019 22:39:55 -0800 (PST)
Received: from xplor.waratah.dyndns.org (122-58-182-39-adsl.sparkbb.co.nz. [122.58.182.39])
        by smtp.gmail.com with ESMTPSA id c12sm1079794pfp.178.2019.11.12.22.39.54
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Tue, 12 Nov 2019 22:39:54 -0800 (PST)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 2446E360079; Wed, 13 Nov 2019 19:39:51 +1300 (NZDT)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     stable@vger.kernel.org
Cc:     schmitzmic@gmail.com, Finn Thain <fthain@telegraphics.com.au>,
        Sasha Levin <sashal@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: core: Handle drivers which set sg_tablesize to zero
Date:   Wed, 13 Nov 2019 19:39:41 +1300
Message-Id: <1573627181-20123-1-git-send-email-schmitzmic@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20191113012739.GN8496@sasha-vm>
References: <20191113012739.GN8496@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 9393c8de628c upstream

In scsi_mq_setup_tags(), cmd_size is calculated based on zero size
for the scatter-gather list in case the low level driver uses SG_NONE
in its host template.d, and an empty message aborts the commit.

cmd_size is passed on to the block layer for calculation of the request
size, and we've seen NULL pointer dereference errors from the block
layer in drivers where SG_NONE is used and a mq IO scheduler is active,
apparently as a consequence of this (see commit 68ab2d76e4be for the
cxflash driver, and a recent patch by Finn Thain converting the three
m68k NFR5380 drivers to avoid setting SG_NONE).

Try to avoid these errors by accounting for at least one sg list entry
when caculating cmd_size, regardless of whether the low level driver
set a zero sg_tablesize.

Tested on 030 m68k with the atari_scsi driver - setting sg_tablesize to
SG_NONE no longer results in a crash when loading this driver.

Backport of commit 9393c8de628c to stable kernels before 4.19 which lack
commit 3dccdf53c2f3 ("scsi: core: avoid preallocating big SGL for data"),
as requestef by Sasha Levin.

Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
Cc: Finn Thain <fthain@telegraphics.com.au>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/scsi_lib.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0adfb3b..e0a4ad9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2356,7 +2356,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 {
 	unsigned int cmd_size, sgl_size;
 
-	sgl_size = scsi_mq_sgl_size(shost);
+	sgl_size = max_t(unsigned int, sizeof(struct scatterlist),
+			scsi_mq_sgl_size(shost));
 	cmd_size = sizeof(struct scsi_cmnd) + shost->hostt->cmd_size + sgl_size;
 	if (scsi_host_get_prot(shost))
 		cmd_size += sizeof(struct scsi_data_buffer) + sgl_size;
-- 
1.7.0.4


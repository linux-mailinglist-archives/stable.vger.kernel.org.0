Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF9D6E678E
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732058AbfJ0VWC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:22:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732053AbfJ0VWB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:22:01 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDC282070B;
        Sun, 27 Oct 2019 21:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211321;
        bh=ReglJFEYFZJHDzlpCC3pzyMEJOdfKYqm49G+LpI+siY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fSSIxS/2aLYb2Moboa2+wiFHNeMW435BcVxCgBHpv5eqDlbPHHhlyuphmXY2SpNQg
         YRMWPJH/iP9LuKEBVEiKKo/PMGwRQ9Kz/y3H6CmN+jK0HDqH5V1XrCAY04wG07uHHk
         r11bb9CJ9vOGdPPdhsbmouosG9os4ia3qbbzDBHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.3 110/197] scsi: sd: Ignore a failure to sync cache due to lack of authorization
Date:   Sun, 27 Oct 2019 22:00:28 +0100
Message-Id: <20191027203357.686595342@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 21e3d6c81179bbdfa279efc8de456c34b814cfd2 upstream.

I've got a report about a UAS drive enclosure reporting back Sense: Logical
unit access not authorized if the drive it holds is password protected.
While the drive is obviously unusable in that state as a mass storage
device, it still exists as a sd device and when the system is asked to
perform a suspend of the drive, it will be sent a SYNCHRONIZE CACHE. If
that fails due to password protection, the error must be ignored.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190903101840.16483-1-oneukum@suse.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/sd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1655,7 +1655,8 @@ static int sd_sync_cache(struct scsi_dis
 		/* we need to evaluate the error return  */
 		if (scsi_sense_valid(sshdr) &&
 			(sshdr->asc == 0x3a ||	/* medium not present */
-			 sshdr->asc == 0x20))	/* invalid command */
+			 sshdr->asc == 0x20 ||	/* invalid command */
+			 (sshdr->asc == 0x74 && sshdr->ascq == 0x71)))	/* drive is password locked */
 				/* this is no error here */
 				return 0;
 



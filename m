Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84E55E68D5
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730692AbfJ0Vcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:32:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730496AbfJ0VOm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:14:42 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41D6C214AF;
        Sun, 27 Oct 2019 21:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210880;
        bh=xd57e78IOUAHKpYpwT2IGQZpvJCvLZa8IEjkNyMJC4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HAoVomn1oDb6n7cHen5nD0AyxtuMlplAGbzHU7CbiTQQ52sO9PbICaq+Zogww/G5T
         oQeL7QZSa/3ClERVES9jrQ9H9ZJzHcl1Me58XQalQI+UI9uoJvALULJbywDK/03ZpP
         QOVSGBeKWmalFnynKR0gteObZzAjtKn9q8dIQaIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 49/93] scsi: sd: Ignore a failure to sync cache due to lack of authorization
Date:   Sun, 27 Oct 2019 22:01:01 +0100
Message-Id: <20191027203300.557463261@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
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
@@ -1646,7 +1646,8 @@ static int sd_sync_cache(struct scsi_dis
 		/* we need to evaluate the error return  */
 		if (scsi_sense_valid(sshdr) &&
 			(sshdr->asc == 0x3a ||	/* medium not present */
-			 sshdr->asc == 0x20))	/* invalid command */
+			 sshdr->asc == 0x20 ||	/* invalid command */
+			 (sshdr->asc == 0x74 && sshdr->ascq == 0x71)))	/* drive is password locked */
 				/* this is no error here */
 				return 0;
 



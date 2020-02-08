Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C84FC1566A9
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbgBHSgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:36:12 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33916 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727809AbgBHS3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:41 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrH-0003dm-Gi; Sat, 08 Feb 2020 18:29:35 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrG-000CMI-94; Sat, 08 Feb 2020 18:29:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jens Axboe" <axboe@kernel.dk>, "Ming Lei" <ming.lei@redhat.com>
Date:   Sat, 08 Feb 2020 18:19:47 +0000
Message-ID: <lsq.1581185940.956060623@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 048/148] blk-mq: make sure that line break can be printed
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

commit d2c9be89f8ebe7ebcc97676ac40f8dec1cf9b43a upstream.

8962842ca5ab ("blk-mq: avoid sysfs buffer overflow with too many CPU cores")
avoids sysfs buffer overflow, and reserves one character for line break.
However, the last snprintf() doesn't get correct 'size' parameter passed
in, so fixed it.

Fixes: 8962842ca5ab ("blk-mq: avoid sysfs buffer overflow with too many CPU cores")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 block/blk-mq-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -243,7 +243,7 @@ static ssize_t blk_mq_hw_sysfs_cpus_show
 		pos += ret;
 	}
 
-	ret = snprintf(pos + page, size - pos, "\n");
+	ret = snprintf(pos + page, size + 1 - pos, "\n");
 	return pos + ret;
 }
 


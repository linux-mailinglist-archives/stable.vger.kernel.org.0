Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B10E119B30C
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389186AbgDAQox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:44:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388037AbgDAQow (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:44:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4928A206E9;
        Wed,  1 Apr 2020 16:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759491;
        bh=jD/A6vXxrAuH6HnI+HbC6Unssbw6b5eYu6JLroXNTL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ooLxLdsJmRKYCWKcDrjpsLjTS9nmoL12F/jA0gkYMfMrfquKBheXPX3M9E6+BFWdo
         aJZTHaap/xHLMqt7im+bdjz61xXJS57podehb3LuZ9bjI7Rp2Vfix7Eao7wONW8ZRo
         TPnP1ezGvQ6n0yaBFakBkGHBstnQccJBVbXL+2kw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bryan Gurney <bgurney@redhat.com>,
        Bernhard Sulzer <micraft.b@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 096/148] scsi: sd: Fix optimal I/O size for devices that change reported values
Date:   Wed,  1 Apr 2020 18:18:08 +0200
Message-Id: <20200401161602.116006124@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
References: <20200401161552.245876366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin K. Petersen <martin.petersen@oracle.com>

commit ea697a8bf5a4161e59806fab14f6e4a46dc7dcb0 upstream.

Some USB bridge devices will return a default set of characteristics during
initialization. And then, once an attached drive has spun up, substitute
the actual parameters reported by the drive. According to the SCSI spec,
the device should return a UNIT ATTENTION in case any reported parameters
change. But in this case the change is made silently after a small window
where default values are reported.

Commit a83da8a4509d ("scsi: sd: Optimal I/O size should be a multiple of
physical block size") validated the reported optimal I/O size against the
physical block size to overcome problems with devices reporting nonsensical
transfer sizes. However, this validation did not account for the fact that
aforementioned devices will return default values during a brief window
during spin-up. The subsequent change in reported characteristics would
invalidate the checking that had previously been performed.

Unset a previously configured optimal I/O size should the sanity checking
fail on subsequent revalidate attempts.

Link: https://lore.kernel.org/r/33fb522e-4f61-1b76-914f-c9e6a3553c9b@gmail.com
Cc: Bryan Gurney <bgurney@redhat.com>
Cc: <stable@vger.kernel.org>
Reported-by: Bernhard Sulzer <micraft.b@gmail.com>
Tested-by: Bernhard Sulzer <micraft.b@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/sd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3212,9 +3212,11 @@ static int sd_revalidate_disk(struct gen
 	if (sd_validate_opt_xfer_size(sdkp, dev_max)) {
 		q->limits.io_opt = logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
 		rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
-	} else
+	} else {
+		q->limits.io_opt = 0;
 		rw_max = min_not_zero(logical_to_sectors(sdp, dev_max),
 				      (sector_t)BLK_DEF_MAX_SECTORS);
+	}
 
 	/* Do not exceed controller limit */
 	rw_max = min(rw_max, queue_max_hw_sectors(q));



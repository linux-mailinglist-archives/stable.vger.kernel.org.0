Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAD93119E0D
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbfLJWbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:31:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:51558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728526AbfLJWba (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:31:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11E402073D;
        Tue, 10 Dec 2019 22:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576017089;
        bh=9GYC482xubuw+Sl8xaw1dMPpBuoo/M3QJrbWA1UOpbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c6567TuCruuJZTFduqhFFUdtows7GS1595VvypTQobD7MNovI18102di3OsXhoIv9
         twViFN24x+nQk6FKefyBkgceZYSJbDxSNnqJNFoJ8MuhmcprrnnPEFQq2gVAnSmgVO
         bqaNGufwvtyeYYLpAtvZO4XYHzQJpXEKO/ZmLX98=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Slaby <jslaby@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        linux-ide@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 45/91] ata: sata_mv, avoid trigerrable BUG_ON
Date:   Tue, 10 Dec 2019 17:29:49 -0500
Message-Id: <20191210223035.14270-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210223035.14270-1-sashal@kernel.org>
References: <20191210223035.14270-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit e9f691d899188679746eeb96e6cb520459eda9b4 ]

There are several reports that the BUG_ON on unsupported command in
mv_qc_prep can be triggered under some circumstances:
https://bugzilla.suse.com/show_bug.cgi?id=1110252
https://serverfault.com/questions/888897/raid-problems-after-power-outage
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1652185
https://bugs.centos.org/view.php?id=14998

Let sata_mv handle the failure gracefully: warn about that incl. the
failed command number and return an AC_ERR_INVALID error. We can do that
now thanks to the previous patch.

Remove also the long-standing FIXME.

[v2] use %.2x as commands are defined as hexa.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: linux-ide@vger.kernel.org
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_mv.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 2f32782cea6d9..2ec37a038eda8 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -2111,12 +2111,10 @@ static void mv_qc_prep(struct ata_queued_cmd *qc)
 		 * non-NCQ mode are: [RW] STREAM DMA and W DMA FUA EXT, none
 		 * of which are defined/used by Linux.  If we get here, this
 		 * driver needs work.
-		 *
-		 * FIXME: modify libata to give qc_prep a return value and
-		 * return error here.
 		 */
-		BUG_ON(tf->command);
-		break;
+		ata_port_err(ap, "%s: unsupported command: %.2x\n", __func__,
+				tf->command);
+		return AC_ERR_INVALID;
 	}
 	mv_crqb_pack_cmd(cw++, tf->nsect, ATA_REG_NSECT, 0);
 	mv_crqb_pack_cmd(cw++, tf->hob_lbal, ATA_REG_LBAL, 0);
-- 
2.20.1


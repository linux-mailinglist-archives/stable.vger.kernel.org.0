Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702AB4728A9
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236007AbhLMKOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:14:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240849AbhLMKCp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:02:45 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13DCC08EC36;
        Mon, 13 Dec 2021 01:49:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 48AFFCE0E89;
        Mon, 13 Dec 2021 09:49:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8286C341C5;
        Mon, 13 Dec 2021 09:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388972;
        bh=SjL9jKNQm7cuWYJe9WgTr3/buPaqknUfh+8KLVYYYHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wu/70bcGSEW5OJmNWCRxEM7ErLh0LeHdG7INoEz19PzMlMLgNxooCy9TSU6tTioBR
         018eaw0uOMbQccmIGR0auwQASmiiGVU60OVoqqkNUbTztTnLslBow/eEqwpCRbB8Kj
         UxQb8h5I0YTHX2V1t6vYml3a/UW3M2d1LpEzsWvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 073/132] scsi: scsi_debug: Fix buffer size of REPORT ZONES command
Date:   Mon, 13 Dec 2021 10:30:14 +0100
Message-Id: <20211213092941.619829363@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

commit 7db0e0c8190a086ef92ce5bb960836cde49540aa upstream.

According to ZBC and SPC specifications, the unit of ALLOCATION LENGTH
field of REPORT ZONES command is byte. However, current scsi_debug
implementation handles it as number of zones to calculate buffer size to
report zones. When the ALLOCATION LENGTH has a large number, this results
in too large buffer size and causes memory allocation failure.  Fix the
failure by handling ALLOCATION LENGTH as byte unit.

Link: https://lore.kernel.org/r/20211207010638.124280-1-shinichiro.kawasaki@wdc.com
Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4313,7 +4313,7 @@ static int resp_report_zones(struct scsi
 	rep_max_zones = min((alloc_len - 64) >> ilog2(RZONES_DESC_HD),
 			    max_zones);
 
-	arr = kcalloc(RZONES_DESC_HD, alloc_len, GFP_ATOMIC);
+	arr = kzalloc(alloc_len, GFP_ATOMIC);
 	if (!arr) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
 				INSUFF_RES_ASCQ);



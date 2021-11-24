Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D55445C617
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344668AbhKXOFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:05:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:50840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353604AbhKXOAh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:00:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36E70632E6;
        Wed, 24 Nov 2021 13:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759360;
        bh=9+fEL5bRC2vbzDxSFxZxriKpVHTD61kOjmtxRdEj3xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lwjyrAyk0nnnmQzmKfGYNp7Ur0cQUBq6/hHeyqsCkTZGWHBdemRUCpMe/FDVAPXgk
         cuvP9wtO17E1ei8H0uPmkWZwkkqaaa5QRL1Z0gnT6l/qYRuD7VdtW3bO+9EsFWgvOc
         lvCnAUPX6bc1Z5rcZjHoSFIOnmppXclT6Nxh2r2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Arun Easi <aeasi@marvell.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 215/279] scsi: qla2xxx: Fix mailbox direction flags in qla2xxx_get_adapter_id()
Date:   Wed, 24 Nov 2021 12:58:22 +0100
Message-Id: <20211124115726.176576466@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ewan D. Milne <emilne@redhat.com>

commit 392006871bb26166bcfafa56faf49431c2cfaaa8 upstream.

The SCM changes set the flags in mcp->out_mb instead of mcp->in_mb so the
data was not actually being read into the mcp->mb[] array from the adapter.

Link: https://lore.kernel.org/r/20211108183012.13895-1-emilne@redhat.com
Fixes: 9f2475fe7406 ("scsi: qla2xxx: SAN congestion management implementation")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1695,10 +1695,8 @@ qla2x00_get_adapter_id(scsi_qla_host_t *
 		mcp->in_mb |= MBX_13|MBX_12|MBX_11|MBX_10;
 	if (IS_FWI2_CAPABLE(vha->hw))
 		mcp->in_mb |= MBX_19|MBX_18|MBX_17|MBX_16;
-	if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw)) {
-		mcp->in_mb |= MBX_15;
-		mcp->out_mb |= MBX_7|MBX_21|MBX_22|MBX_23;
-	}
+	if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw))
+		mcp->in_mb |= MBX_15|MBX_21|MBX_22|MBX_23;
 
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F426449BA6
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 19:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235784AbhKHSdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 13:33:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41828 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235702AbhKHSdS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 13:33:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636396233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=J7zHPC1Uvz98lt8Q4KZHHsPhYbhlJHhHtX19XXiFYag=;
        b=gwEtdkcgWt2cKzn0tR5w3CU/edq+wP9uqofuUwOhTnAfiz2NFkjJbnFgud//gjwfR22YDp
        SYhFFN0FCv2YcnNhV59cPUg7shi+1SEuRasOBIYGK4RIGm+WWxb65x98AosMGfW20rfset
        oG9NGPSJPmtXzYa665BncRlNxO+uNGs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-DZjNaKfENKi766IF2MoeKA-1; Mon, 08 Nov 2021 13:30:29 -0500
X-MC-Unique: DZjNaKfENKi766IF2MoeKA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A06315720;
        Mon,  8 Nov 2021 18:30:28 +0000 (UTC)
Received: from emilne.bos.redhat.com (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86FF01007605;
        Mon,  8 Nov 2021 18:30:12 +0000 (UTC)
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     stable@vger.kernel.org, njavali@marvell.com, aeasi@marvell.com
Subject: [PATCH] scsi: qla2xxx: fix mailbox direction flags in qla2xxx_get_adapter_id()
Date:   Mon,  8 Nov 2021 13:30:12 -0500
Message-Id: <20211108183012.13895-1-emilne@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The SCM changes set the flags in mcp->out_mb instead of mcp->in_mb
so the data was not actually being read into the mcp->mb[] array from
the adapter.

Fixes: 9f2475fe7406 ("scsi: qla2xxx: SAN congestion management implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 7811c4952035..a6debeea3079 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1695,10 +1695,8 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16_t *id, uint8_t *al_pa,
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
-- 
2.31.1


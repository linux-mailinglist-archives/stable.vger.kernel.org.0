Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5616D1BFA0A
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 15:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgD3NvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 09:51:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbgD3NvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:51:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 316D02082E;
        Thu, 30 Apr 2020 13:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254668;
        bh=vEhVLLwSFyJhdLX9Pt2w9y/nEjjsIQJj5jJiyTA4d3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZC7Efpt9apFX702Y0V8UEt2Ayn67snqlZjCmjpiQ5NhwQDmOu0XVv03yEVWwV+8/M
         JNZxyou7QX1zUJ0tWYYzlgqHVQRg3q5T0IOsQMtipY5br+Pznqh63lU+ORTtahk9Sf
         dXonyuomrPB7hOFWGyuGLizGQoYwg5OxlZ45AcR8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wu Bo <wubo40@huawei.com>, Douglas Gilbert <dgilbert@interlog.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 21/79] scsi: sg: add sg_remove_request in sg_write
Date:   Thu, 30 Apr 2020 09:49:45 -0400
Message-Id: <20200430135043.19851-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wu Bo <wubo40@huawei.com>

[ Upstream commit 83c6f2390040f188cc25b270b4befeb5628c1aee ]

If the __copy_from_user function failed we need to call sg_remove_request
in sg_write.

Link: https://lore.kernel.org/r/610618d9-e983-fd56-ed0f-639428343af7@huawei.com
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Wu Bo <wubo40@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 9c0ee192f0f9c..20472aaaf630a 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -685,8 +685,10 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	hp->flags = input_size;	/* structure abuse ... */
 	hp->pack_id = old_hdr.pack_id;
 	hp->usr_ptr = NULL;
-	if (copy_from_user(cmnd, buf, cmd_size))
+	if (copy_from_user(cmnd, buf, cmd_size)) {
+		sg_remove_request(sfp, srp);
 		return -EFAULT;
+	}
 	/*
 	 * SG_DXFER_TO_FROM_DEV is functionally equivalent to SG_DXFER_FROM_DEV,
 	 * but is is possible that the app intended SG_DXFER_TO_DEV, because there
-- 
2.20.1


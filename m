Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E416C1D80F1
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729596AbgERRnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:43:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729592AbgERRnc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:43:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACA6E207C4;
        Mon, 18 May 2020 17:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823811;
        bh=QKJKtRoLIqCaEfc6uLGClsCSoy4x2Et0ySrYl6L8788=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=INeDBaNC3eogaRrQA+CcvQLav/Lhr0bBsNqOA+AcecywLWgY2adj5zzjHyQTDRaPZ
         gPSzX+zi6uWL10j6QpJd1R4nRTBn58QARmq9cdM5IMbRxRZlxQw8j4LcwSfws+3zti
         Qd/NwQ9LgqjRWOLkBOuS1s+QRw9/4SxC/8yrcBIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
        Wu Bo <wubo40@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.9 45/90] scsi: sg: add sg_remove_request in sg_write
Date:   Mon, 18 May 2020 19:36:23 +0200
Message-Id: <20200518173500.428520775@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.930655662@linuxfoundation.org>
References: <20200518173450.930655662@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wu Bo <wubo40@huawei.com>

commit 83c6f2390040f188cc25b270b4befeb5628c1aee upstream.

If the __copy_from_user function failed we need to call sg_remove_request
in sg_write.

Link: https://lore.kernel.org/r/610618d9-e983-fd56-ed0f-639428343af7@huawei.com
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Wu Bo <wubo40@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[groeck: Backport to v5.4.y and older kernels]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/sg.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -695,8 +695,10 @@ sg_write(struct file *filp, const char _
 	hp->flags = input_size;	/* structure abuse ... */
 	hp->pack_id = old_hdr.pack_id;
 	hp->usr_ptr = NULL;
-	if (__copy_from_user(cmnd, buf, cmd_size))
+	if (__copy_from_user(cmnd, buf, cmd_size)) {
+		sg_remove_request(sfp, srp);
 		return -EFAULT;
+	}
 	/*
 	 * SG_DXFER_TO_FROM_DEV is functionally equivalent to SG_DXFER_FROM_DEV,
 	 * but is is possible that the app intended SG_DXFER_TO_DEV, because there



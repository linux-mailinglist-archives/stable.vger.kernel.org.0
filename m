Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83081B3F93
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731332AbgDVKim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:38:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729831AbgDVKVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:21:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D2CC20857;
        Wed, 22 Apr 2020 10:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550903;
        bh=Xiz+dEZ9779N4+AdXfprVfeVCFAdhf6PfQCMpYw4OaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghqOZYKxHCQnuEjaoN7NDvciruNIdZluCP5amwO2Cu5YxvjW0sOzVnk3evZjxYNP4
         bqWqy2hWiSE0aNGtUKT5yIeD+vFPXRk6zg0JKsyXsO7ZsbIwEUJkEOSgW4kdvFQf4r
         JevhhFn6RI73J/TtIAH9SqXnOLN2Q5MvuKsGi1hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
        Li Bin <huawei.libin@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.6 004/166] scsi: sg: add sg_remove_request in sg_common_write
Date:   Wed, 22 Apr 2020 11:55:31 +0200
Message-Id: <20200422095048.477652819@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Bin <huawei.libin@huawei.com>

commit 849f8583e955dbe3a1806e03ecacd5e71cce0a08 upstream.

If the dxfer_len is greater than 256M then the request is invalid and we
need to call sg_remove_request in sg_common_write.

Link: https://lore.kernel.org/r/1586777361-17339-1-git-send-email-huawei.libin@huawei.com
Fixes: f930c7043663 ("scsi: sg: only check for dxfer_len greater than 256M")
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Li Bin <huawei.libin@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/sg.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -793,8 +793,10 @@ sg_common_write(Sg_fd * sfp, Sg_request
 			"sg_common_write:  scsi opcode=0x%02x, cmd_size=%d\n",
 			(int) cmnd[0], (int) hp->cmd_len));
 
-	if (hp->dxfer_len >= SZ_256M)
+	if (hp->dxfer_len >= SZ_256M) {
+		sg_remove_request(sfp, srp);
 		return -EINVAL;
+	}
 
 	k = sg_start_req(srp, cmnd);
 	if (k) {



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5436A1B3D4B
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbgDVKNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:13:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726398AbgDVKNq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:13:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75F962071E;
        Wed, 22 Apr 2020 10:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550425;
        bh=EczdJwOSH1Flg9d2wPTjMWsHf7BqvRqH92roZ4Bulhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VZ/x/C8reg/kj6eO/+B2nMnZYPQsNYXOVJEE4YmF9HO9BB6Z2KXDmgogCgCX43lMx
         qcWBC9HFPJ3yZiIS1ftpgzFpwtlcOTCEJakVkr985DfUJsT2gQUyleypKqWPMcStSy
         s0hztUpwr2zjtXrA81jbF38ToyQnV5a15jZm7iFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
        Li Bin <huawei.libin@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 03/64] scsi: sg: add sg_remove_request in sg_common_write
Date:   Wed, 22 Apr 2020 11:56:47 +0200
Message-Id: <20200422095012.888605991@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095008.799686511@linuxfoundation.org>
References: <20200422095008.799686511@linuxfoundation.org>
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
@@ -808,8 +808,10 @@ sg_common_write(Sg_fd * sfp, Sg_request
 			"sg_common_write:  scsi opcode=0x%02x, cmd_size=%d\n",
 			(int) cmnd[0], (int) hp->cmd_len));
 
-	if (hp->dxfer_len >= SZ_256M)
+	if (hp->dxfer_len >= SZ_256M) {
+		sg_remove_request(sfp, srp);
 		return -EINVAL;
+	}
 
 	k = sg_start_req(srp, cmnd);
 	if (k) {



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0800A3C55E3
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346097AbhGLIM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:12:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354023AbhGLIDY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B85960698;
        Mon, 12 Jul 2021 07:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076775;
        bh=5v7pvtEmxramajIUD60466c9hCUEwDcpp6R/sNavWag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Guoakp2DKYFNJ+A0muHeE7zEW6oexQBvfQmABGm0M11QYDqcSq0C4VevUK7u8bZd6
         GtpZZbLpibk4RH+CZYqq0W7DDmPizjX0gp2RJmujqM6uTNVZfb2pD1IkakuFV4m75V
         uIVcVVbLsTT5cEH53AS2bsPZR8cxXAk7HI+sRmCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Javed Hasan <jhasan@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.13 787/800] scsi: libfc: Correct the condition check and invalid argument passed
Date:   Mon, 12 Jul 2021 08:13:30 +0200
Message-Id: <20210712061050.535367705@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javed Hasan <jhasan@marvell.com>

commit 8f70328c068f9f5c5db82848724cb276f657b9cd upstream.

Incorrect condition check was leading to data corruption.

Link: https://lore.kernel.org/r/20210603101404.7841-3-jhasan@marvell.com
Fixes: 8fd9efca86d0 ("scsi: libfc: Work around -Warray-bounds warning")
CC: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/libfc/fc_encode.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/scsi/libfc/fc_encode.h
+++ b/drivers/scsi/libfc/fc_encode.h
@@ -166,9 +166,11 @@ static inline int fc_ct_ns_fill(struct f
 static inline void fc_ct_ms_fill_attr(struct fc_fdmi_attr_entry *entry,
 				    const char *in, size_t len)
 {
-	int copied = strscpy(entry->value, in, len);
-	if (copied > 0)
-		memset(entry->value, copied, len - copied);
+	int copied;
+
+	copied = strscpy((char *)&entry->value, in, len);
+	if (copied > 0 && (copied + 1) < len)
+		memset((entry->value + copied + 1), 0, len - copied - 1);
 }
 
 /**



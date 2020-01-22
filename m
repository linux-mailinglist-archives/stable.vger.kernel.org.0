Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C04514507C
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729199AbgAVJqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:46:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:36438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387924AbgAVJno (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:43:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D51D2468B;
        Wed, 22 Jan 2020 09:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686223;
        bh=EwXiR3OAHCKqfa2wQBGY7nZhL1E2myYAN/IcWN8jdxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kENbBnGUo7vbXIQj+1WgW73Ep9ll2xHfEJHCcefaplaEShSe2+Wa7zpYhfN91EMpm
         G6uXxPZq6wEyeQDC95VuJ1lZa8lALqKSwm5m/dj0tbko0y3Pfze106KjFO2RSo0EVQ
         nYwazvvVvfPwyV22AVpei9IFHSx+zL/qdmCOi3Lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 093/103] scsi: esas2r: unlock on error in esas2r_nvram_read_direct()
Date:   Wed, 22 Jan 2020 10:29:49 +0100
Message-Id: <20200122092815.975194637@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 906ca6353ac09696c1bf0892513c8edffff5e0a6 upstream.

This error path is missing an unlock.

Fixes: 26780d9e12ed ("[SCSI] esas2r: ATTO Technology ExpressSAS 6G SAS/SATA RAID Adapter Driver")
Link: https://lore.kernel.org/r/20191022102324.GA27540@mwanda
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/esas2r/esas2r_flash.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/esas2r/esas2r_flash.c
+++ b/drivers/scsi/esas2r/esas2r_flash.c
@@ -1197,6 +1197,7 @@ bool esas2r_nvram_read_direct(struct esa
 	if (!esas2r_read_flash_block(a, a->nvram, FLS_OFFSET_NVR,
 				     sizeof(struct esas2r_sas_nvram))) {
 		esas2r_hdebug("NVRAM read failed, using defaults");
+		up(&a->nvram_semaphore);
 		return false;
 	}
 



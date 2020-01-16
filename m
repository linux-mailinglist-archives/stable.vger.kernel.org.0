Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7716213FD31
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731586AbgAPXXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:23:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:51244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733288AbgAPXXJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:23:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E94A206D9;
        Thu, 16 Jan 2020 23:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216988;
        bh=9yg2XFAEugW75gx4rtI3GuDpK2t+9yooFbQKApOyZy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FnyU69FTWagzpcS+cdD3EAquad9YAFBvH3ZzXTK/4TiEEbD3GaQ+qda/u6LE5lpdt
         ZjEPYsSego4LsAA0IydezaWnvCXUYOorDsDQfV4XlHTis8PHCcM3N5IOcwFotMyTfX
         eZ2dZiAY1QPvJIZDO9rO7nZOmg6NdFghmpHB/RiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 086/203] scsi: sd: Clear sdkp->protection_type if disk is reformatted without PI
Date:   Fri, 17 Jan 2020 00:16:43 +0100
Message-Id: <20200116231753.019415714@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

commit 465f4edaecc6c37f81349233e84d46246bcac11a upstream.

If an attached disk with protection information enabled is reformatted
to Type 0 the revalidation code does not clear the original protection
type and subsequent accesses will keep setting RDPROTECT/WRPROTECT.

Set the protection type to 0 if the disk reports PROT_EN=0 in READ
CAPACITY(16).

[mkp: commit desc]

Fixes: fe542396da73 ("[SCSI] sd: Ensure we correctly disable devices with unknown protection type")
Link: https://lore.kernel.org/r/1578532344-101668-1-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/sd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2192,8 +2192,10 @@ static int sd_read_protection_type(struc
 	u8 type;
 	int ret = 0;
 
-	if (scsi_device_protection(sdp) == 0 || (buffer[12] & 1) == 0)
+	if (scsi_device_protection(sdp) == 0 || (buffer[12] & 1) == 0) {
+		sdkp->protection_type = 0;
 		return ret;
+	}
 
 	type = ((buffer[12] >> 1) & 7) + 1; /* P_TYPE 0 = Type 1 */
 



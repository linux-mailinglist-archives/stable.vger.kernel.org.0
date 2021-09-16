Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAC640E629
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346031AbhIPRSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:18:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343575AbhIPRQG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:16:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D806C61BBE;
        Thu, 16 Sep 2021 16:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810417;
        bh=2xJEJpfSoyORzGxGTI3s7ieeq25y1kEm0yKthuAsI48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fr5GS6IKl7iRlP1CBo3IyJNjwsZdfwohHYleENJYjjEnKde75OUVOXkMqmxTSxkDy
         kSKDpoHJvesTkzVgDAL2UbWj41pvZrLpD83hl3h4V0aelg3NEjalR3sBQgkMMz/c9m
         1lEsCg7Ju/Ix2ekHoQLdoZYbzhgOh6KmU/+fSjoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 091/432] scsi: ufs: Fix memory corruption by ufshcd_read_desc_param()
Date:   Thu, 16 Sep 2021 17:57:20 +0200
Message-Id: <20210916155813.863232564@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit d3d9c4570285090b533b00946b72647361f0345b ]

If param_offset > buff_len then the memcpy() statement in
ufshcd_read_desc_param() corrupts memory since it copies 256 + buff_len -
param_offset bytes into a buffer with size buff_len.  Since param_offset <
256 this results in writing past the bound of the output buffer.

Link: https://lore.kernel.org/r/20210722033439.26550-2-bvanassche@acm.org
Fixes: cbe193f6f093 ("scsi: ufs: Fix potential NULL pointer access during memcpy")
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Daejun Park <daejun7.park@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 708b3b62fc4d..179227180961 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3419,9 +3419,11 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 
 	if (is_kmalloc) {
 		/* Make sure we don't copy more data than available */
-		if (param_offset + param_size > buff_len)
-			param_size = buff_len - param_offset;
-		memcpy(param_read_buf, &desc_buf[param_offset], param_size);
+		if (param_offset >= buff_len)
+			ret = -EINVAL;
+		else
+			memcpy(param_read_buf, &desc_buf[param_offset],
+			       min_t(u32, param_size, buff_len - param_offset));
 	}
 out:
 	if (is_kmalloc)
-- 
2.30.2




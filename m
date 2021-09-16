Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B78540E23B
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242066AbhIPQft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:35:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242904AbhIPQdr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:33:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E82161268;
        Thu, 16 Sep 2021 16:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809241;
        bh=Y6gcQ6S1Li5VneBqUA57docK1hmgK19P/JMU+yw4syc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xpNr2n0dBEH2C+NmJypOk2Z6yYSTdfxS3KyoV6n+YIxOAAkDC21rd3wY3+pRIJ24J
         fHf2ILvRU1XbvODpeC4uX/pdUxUvNFPR0HAu3g1zJE0X9q6qWShVaT7ErVjH0QJP5w
         zxqZ59xQxkUEFTXiiNzptCYrgPpsmnJQOxEINx44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 083/380] scsi: ufs: Fix memory corruption by ufshcd_read_desc_param()
Date:   Thu, 16 Sep 2021 17:57:20 +0200
Message-Id: <20210916155806.855421309@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
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
index 72fd41bfbd54..90837e54c2fe 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3326,9 +3326,11 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 
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




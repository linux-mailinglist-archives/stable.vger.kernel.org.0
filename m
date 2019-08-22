Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3B4099DA8
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388867AbfHVRoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:44:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403937AbfHVRXY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:23:24 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8E3023402;
        Thu, 22 Aug 2019 17:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494603;
        bh=uxZkgyh2XRlpGrbfErOZ3RRf3skFrk/YeROxyq9d8A0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l4bPDoiFULV0lRcgW9vqNzJaR60Oqbn1Zx/571f+bUBQ8MR/uhPzAh248e0ZDfG1V
         AbW8po0RzIQN4pNi8bNNiSaZF/omn2Dxa1fJca6FqZIC/hxx4kchYLenRhMDQpG9lb
         M3wirE8eokAiG3lS5RuEQAqOd49ygToLDfyjmZ8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junxiao Bi <junxiao.bi@oracle.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 026/103] scsi: megaraid_sas: fix panic on loading firmware crashdump
Date:   Thu, 22 Aug 2019 10:18:14 -0700
Message-Id: <20190822171729.910717938@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171728.445189830@linuxfoundation.org>
References: <20190822171728.445189830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3b5f307ef3cb5022bfe3c8ca5b8f2114d5bf6c29 ]

While loading fw crashdump in function fw_crash_buffer_show(), left bytes
in one dma chunk was not checked, if copying size over it, overflow access
will cause kernel panic.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 5b1c37e3913cd..d90693b2767fd 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2847,6 +2847,7 @@ megasas_fw_crash_buffer_show(struct device *cdev,
 	u32 size;
 	unsigned long buff_addr;
 	unsigned long dmachunk = CRASH_DMA_BUF_SIZE;
+	unsigned long chunk_left_bytes;
 	unsigned long src_addr;
 	unsigned long flags;
 	u32 buff_offset;
@@ -2872,6 +2873,8 @@ megasas_fw_crash_buffer_show(struct device *cdev,
 	}
 
 	size = (instance->fw_crash_buffer_size * dmachunk) - buff_offset;
+	chunk_left_bytes = dmachunk - (buff_offset % dmachunk);
+	size = (size > chunk_left_bytes) ? chunk_left_bytes : size;
 	size = (size >= PAGE_SIZE) ? (PAGE_SIZE - 1) : size;
 
 	src_addr = (unsigned long)instance->crash_buf[buff_offset / dmachunk] +
-- 
2.20.1




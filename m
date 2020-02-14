Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90E5715EBE4
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391238AbgBNRXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:23:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:33798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391259AbgBNQJZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:09:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F80A24685;
        Fri, 14 Feb 2020 16:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696565;
        bh=BOAuucgOG9GcK1LGryZaUi2poccOqBLsVdu3ZCwoLF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jknQbfVidVLYqpFb9ZSSg7Qjo9nuJESPr7Ip/rJxaszOkYODO9zPiTND8CG8fz3/T
         6NwY+94NGk5tKxbQQ99grPBEWznK8V1CpxEFnbqP/Af+vBh7exCNYiNCL0h+wfh76S
         ZdfL5iXxDR3t9gGjvvUGq5eo835mH5oC4A72WGEU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 355/459] cmd64x: potential buffer overflow in cmd64x_program_timings()
Date:   Fri, 14 Feb 2020 11:00:05 -0500
Message-Id: <20200214160149.11681-355-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 117fcc3053606d8db5cef8821dca15022ae578bb ]

The "drive->dn" value is a u8 and it is controlled by root only, but
it could be out of bounds here so let's check.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ide/cmd64x.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ide/cmd64x.c b/drivers/ide/cmd64x.c
index a1898e11b04e6..943bf944bf722 100644
--- a/drivers/ide/cmd64x.c
+++ b/drivers/ide/cmd64x.c
@@ -66,6 +66,9 @@ static void cmd64x_program_timings(ide_drive_t *drive, u8 mode)
 	struct ide_timing t;
 	u8 arttim = 0;
 
+	if (drive->dn >= ARRAY_SIZE(drwtim_regs))
+		return;
+
 	ide_timing_compute(drive, mode, &t, T, 0);
 
 	/*
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B47451498
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344110AbhKOUKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:10:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344824AbhKOTZe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1928636D3;
        Mon, 15 Nov 2021 19:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003102;
        bh=TcJ7AiaNecV+3m7Jzk2zabrpiQ4cAPopNcGnF4w6h9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TIqUMYdHFABOqEUXnfPiz5BdPpjqdNm9Yf8rhBm08EKhfEqLJn9vAzB3bnpYHP0ss
         DfhvmhREM11Qjat5ILJtF5W52gzxBhO7XAG3rXaa9v3g3G7lpI4KXgjNErDtmYixiq
         19vy9CkqjT1lQ1PgPV3hQ8Bwm11oeRNS77R9L7dI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        Jackie Liu <liuyun01@kylinos.cn>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 779/917] scsi: bsg: Fix errno when scsi_bsg_register_queue() fails
Date:   Mon, 15 Nov 2021 18:04:34 +0100
Message-Id: <20211115165455.353020514@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jackie Liu <liuyun01@kylinos.cn>

[ Upstream commit 5f7cf82c1d7373fcf9e1062f5654efd5fa2b9211 ]

When the value of error is printed, it will always be 0. We should print
the correct error code when scsi_bsg_register_queue() fails.

Link: https://lore.kernel.org/r/20211022010201.426746-1-liu.yun@linux.dev
Fixes: ead09dd3aed5 ("scsi: bsg: Simplify device registration")
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index a35841b34bfd9..8bb79ccc9a8b5 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1388,6 +1388,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 			 * We're treating error on bsg register as non-fatal, so
 			 * pretend nothing went wrong.
 			 */
+			error = PTR_ERR(sdev->bsg_dev);
 			sdev_printk(KERN_INFO, sdev,
 				    "Failed to register bsg queue, errno=%d\n",
 				    error);
-- 
2.33.0




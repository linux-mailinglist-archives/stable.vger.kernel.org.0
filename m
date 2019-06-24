Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E10C50728
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbfFXKE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:04:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729047AbfFXKE4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:04:56 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2644208E3;
        Mon, 24 Jun 2019 10:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370695;
        bh=VgWhUrVJchQpsFI0+NHb7ob7Q1OZC/5JE8+uJDsX3fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNsWcQ6+qnlpYAewQG2/bf2IiiAVmvwIMNU5Z/6pTMChOsAY1hrvJ1nmY28YrYhQR
         pOCegVquPtqQlNFJwAwYkZaDJhmJPKNEK/4RoREYB/54QJ35thCQs96D/v4xuLcnC5
         3CFDUhyGD3mQ3/koBH5lMWlg6pxj+SQRBYdaXJPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        Minwoo Im <minwoo.im.dev@gmail.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 58/90] nvmet: fix data_len to 0 for bdev-backed write_zeroes
Date:   Mon, 24 Jun 2019 17:56:48 +0800
Message-Id: <20190624092317.912727803@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3562f5d9f21e7779ae442a45197fed6cb247fd22 ]

The WRITE ZEROES command has no data transfer so that we need to
initialize the struct (nvmet_req *req)->data_len to 0x0.  While
(nvmet_req *req)->transfer_len is initialized in nvmet_req_init(),
data_len will be initialized by nowhere which might cause the failure
with status code NVME_SC_SGL_INVALID_DATA | NVME_SC_DNR randomly.  It's
because nvmet_req_execute() checks like:

	if (unlikely(req->data_len != req->transfer_len)) {
		req->error_loc = offsetof(struct nvme_common_command, dptr);
		nvmet_req_complete(req, NVME_SC_SGL_INVALID_DATA | NVME_SC_DNR);
	} else
		req->execute(req);

This patch fixes req->data_len not to be a randomly assigned by
initializing it to 0x0 when preparing the command in
nvmet_bdev_parse_io_cmd().

nvmet_file_parse_io_cmd() which is for file-backed I/O has already
initialized the data_len field to 0x0, though.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Signed-off-by: Minwoo Im <minwoo.im.dev@gmail.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/io-cmd-bdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 7bc9f6240432..1096dd01ca22 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -239,6 +239,7 @@ u16 nvmet_bdev_parse_io_cmd(struct nvmet_req *req)
 		return 0;
 	case nvme_cmd_write_zeroes:
 		req->execute = nvmet_bdev_execute_write_zeroes;
+		req->data_len = 0;
 		return 0;
 	default:
 		pr_err("unhandled cmd %d on qid %d\n", cmd->common.opcode,
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF891A90C8
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389946AbfIDSLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:11:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388806AbfIDSLk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:11:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31163206B8;
        Wed,  4 Sep 2019 18:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620699;
        bh=ScpewfHPSZ83E08AM4jG+abwOpaZQZLHQlnlmK+lkto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kljMIKQi0HP4IJxYjAOrCPnqEJWXME/PG+CgvruqbYIXxZik19vK6rP2AzK5P5Ifx
         mW34IVvvSgwn5MLu9IZFuJl3QyDhBvSp01yeTRR3zCJDFDGH2cwhlb9R41AMeKoFkb
         ijDiB7OLUvz8gbNEcTlNp6LSu0r3oikDdsPVI+ag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 011/143] nvmet-file: fix nvmet_file_flush() always returning an error
Date:   Wed,  4 Sep 2019 19:52:34 +0200
Message-Id: <20190904175314.554285195@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit cfc1a1af56200362d1508b82b9a3cc3acb2eae0c ]

Presently, nvmet_file_flush() always returns a call to
errno_to_nvme_status() but that helper doesn't take into account the
case when errno=0. So nvmet_file_flush() always returns an error code.

All other callers of errno_to_nvme_status() check for success before
calling it.

To fix this, ensure errno_to_nvme_status() returns success if the
errno is zero. This should prevent future mistakes like this from
happening.

Fixes: c6aa3542e010 ("nvmet: add error log support for file backend")
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index e4db9a4411681..396cbc7ea3532 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -43,6 +43,9 @@ inline u16 errno_to_nvme_status(struct nvmet_req *req, int errno)
 	u16 status;
 
 	switch (errno) {
+	case 0:
+		status = NVME_SC_SUCCESS;
+		break;
 	case -ENOSPC:
 		req->error_loc = offsetof(struct nvme_rw_command, length);
 		status = NVME_SC_CAP_EXCEEDED | NVME_SC_DNR;
-- 
2.20.1




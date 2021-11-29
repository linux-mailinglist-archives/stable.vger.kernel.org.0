Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA094462531
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbhK2WgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbhK2Wf0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:35:26 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9D6C1A3CBC;
        Mon, 29 Nov 2021 10:40:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 113CACE1411;
        Mon, 29 Nov 2021 18:40:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B423AC53FC7;
        Mon, 29 Nov 2021 18:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211202;
        bh=DF2cNF3PfJ9YKyAma77/cMsHJPAFDRIz2cD5PSDh7iM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XxEJERF21P6f/sTqs6C21QtwJVmq2V7fm2dYCXyPZeQe3bE3IZ1iPd1zDhz57sRh9
         DkyxgeJawkvxVPO6w6TPeF6LQtr4AkTrTGEhPYgpmJvZ4DAXp3+fiPAxsa4N46H5eP
         nPXW52AAJE5A7zY6JvhDjfqHSBsy035uGazHD3vY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maurizio Lombardi <mlombard@redhat.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/179] nvmet: use IOCB_NOWAIT only if the filesystem supports it
Date:   Mon, 29 Nov 2021 19:18:53 +0100
Message-Id: <20211129181723.524243962@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit c024b226a417c4eb9353ff500b1c823165d4d508 ]

Submit I/O requests with the IOCB_NOWAIT flag set only if
the underlying filesystem supports it.

Fixes: 50a909db36f2 ("nvmet: use IOCB_NOWAIT for file-ns buffered I/O")
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/io-cmd-file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index 1dd1a0fe2e819..df7e033dd2732 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -8,6 +8,7 @@
 #include <linux/uio.h>
 #include <linux/falloc.h>
 #include <linux/file.h>
+#include <linux/fs.h>
 #include "nvmet.h"
 
 #define NVMET_MAX_MPOOL_BVEC		16
@@ -266,7 +267,8 @@ static void nvmet_file_execute_rw(struct nvmet_req *req)
 
 	if (req->ns->buffered_io) {
 		if (likely(!req->f.mpool_alloc) &&
-				nvmet_file_execute_io(req, IOCB_NOWAIT))
+		    (req->ns->file->f_mode & FMODE_NOWAIT) &&
+		    nvmet_file_execute_io(req, IOCB_NOWAIT))
 			return;
 		nvmet_file_submit_buffered_io(req);
 	} else
-- 
2.33.0




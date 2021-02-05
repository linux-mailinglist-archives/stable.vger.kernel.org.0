Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E0C311436
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbhBEWB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:01:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232072AbhBEOyd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:54:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C161D6500B;
        Fri,  5 Feb 2021 14:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534239;
        bh=gH0/SydLCp5UUqUHkOONSasTZq/pbxF7IpgE89cUa0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HmhII6f5BAO5XhKV6xH90UShGMfT0VMl6ygYfiJpKTDxrDuY8mhoDUH99di8cikfy
         vSXKW1Q8iiU7aUZOb+PwHQFa04l0DgwCLKyC3DhvpZ8CcHN7OASZ9gZg99W2A/LAw8
         /VKqOD3mLpdqYlwMTnlSymOW0ylr97sMaDWmI/18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Revanth Rajashekar <revanth.rajashekar@intel.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 39/57] nvme: check the PRINFO bit before deciding the host buffer length
Date:   Fri,  5 Feb 2021 15:07:05 +0100
Message-Id: <20210205140657.649424015@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Revanth Rajashekar <revanth.rajashekar@intel.com>

[ Upstream commit 4d6b1c95b974761c01cbad92321b82232b66d2a2 ]

According to NVMe spec v1.4, section 8.3.1, the PRINFO bit and
the metadata size play a vital role in deteriming the host buffer size.

If PRIFNO bit is set and MS==8, the host doesn't add the metadata buffer,
instead the controller adds it.

Signed-off-by: Revanth Rajashekar <revanth.rajashekar@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 34cb59b2fcd67..4ec5f05dabe1d 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1489,8 +1489,21 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 	}
 
 	length = (io.nblocks + 1) << ns->lba_shift;
-	meta_len = (io.nblocks + 1) * ns->ms;
-	metadata = nvme_to_user_ptr(io.metadata);
+
+	if ((io.control & NVME_RW_PRINFO_PRACT) &&
+	    ns->ms == sizeof(struct t10_pi_tuple)) {
+		/*
+		 * Protection information is stripped/inserted by the
+		 * controller.
+		 */
+		if (nvme_to_user_ptr(io.metadata))
+			return -EINVAL;
+		meta_len = 0;
+		metadata = NULL;
+	} else {
+		meta_len = (io.nblocks + 1) * ns->ms;
+		metadata = nvme_to_user_ptr(io.metadata);
+	}
 
 	if (ns->features & NVME_NS_EXT_LBAS) {
 		length += meta_len;
-- 
2.27.0




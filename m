Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E968332174E
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbhBVMqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:46:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:53774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231588AbhBVMn0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:43:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72C8A64E2E;
        Mon, 22 Feb 2021 12:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997650;
        bh=6ftuQTxLxOEPCiJuscYs+/yZHriIRkYgTWBYaNMX1ZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gWe3A8y1sXHv6P4KEF1zrRvb5NtZzTcOM3inxWzVDgUL87yaVLvi9gj+xedE0Oue9
         bjJlb613CqFvvAOWw7anmOSFkogtgIjhBGqUnCGt9zQRxCRkjI/RGBhybPbXxBOA61
         +yIFiEOTfzmMwqZK5ACsl0r6EMkDwsRY5HJSfrsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.9 03/49] remoteproc: qcom_q6v5_mss: Validate MBA firmware size before load
Date:   Mon, 22 Feb 2021 13:36:01 +0100
Message-Id: <20210222121023.011821363@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121022.546148341@linuxfoundation.org>
References: <20210222121022.546148341@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sibi Sankar <sibis@codeaurora.org>

commit e013f455d95add874f310dc47c608e8c70692ae5 upstream

The following mem abort is observed when the mba firmware size exceeds
the allocated mba region. MBA firmware size is restricted to a maximum
size of 1M and remaining memory region is used by modem debug policy
firmware when available. Hence verify whether the MBA firmware size lies
within the allocated memory region and is not greater than 1M before
loading.

Err Logs:
Unable to handle kernel paging request at virtual address
Mem abort info:
...
Call trace:
  __memcpy+0x110/0x180
  rproc_start+0x40/0x218
  rproc_boot+0x5b4/0x608
  state_store+0x54/0xf8
  dev_attr_store+0x44/0x60
  sysfs_kf_write+0x58/0x80
  kernfs_fop_write+0x140/0x230
  vfs_write+0xc4/0x208
  ksys_write+0x74/0xf8
  __arm64_sys_write+0x24/0x30
...

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Fixes: 051fb70fd4ea4 ("remoteproc: qcom: Driver for the self-authenticating Hexagon v5")
Cc: stable@vger.kernel.org
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Link: https://lore.kernel.org/r/20200722201047.12975-2-sibis@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
[sudip: manual backport to old file path]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/qcom_q6v5_pil.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/remoteproc/qcom_q6v5_pil.c
+++ b/drivers/remoteproc/qcom_q6v5_pil.c
@@ -193,6 +193,12 @@ static int q6v5_load(struct rproc *rproc
 {
 	struct q6v5 *qproc = rproc->priv;
 
+	/* MBA is restricted to a maximum size of 1M */
+	if (fw->size > qproc->mba_size || fw->size > SZ_1M) {
+		dev_err(qproc->dev, "MBA firmware load failed\n");
+		return -EINVAL;
+	}
+
 	memcpy(qproc->mba_region, fw->data, fw->size);
 
 	return 0;



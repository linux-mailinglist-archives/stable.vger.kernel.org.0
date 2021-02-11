Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D36318E79
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbhBKP1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:27:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:53518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230433AbhBKPWi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:22:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B58B64E92;
        Thu, 11 Feb 2021 15:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613056038;
        bh=SLwc77TFFMJcOP+AJWiuTTF5RNE/y47+UVh4py5mNUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xCa46gGiHYgqKKsqAU/75ch+UhWYKd8AbDgZO9eyce6XjmDv4qhSyWPSQpYz/qVfV
         xejUELv4CJqapCBCrrCizFLwVpJYaOZCOLkMtMKn3uLPOGmSzXyH2aAEj1AtBVpzqV
         b+djEEpGlBZ9G1CXIopq8EJR4D9QkDtLAg0gmS/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.19 04/24] remoteproc: qcom_q6v5_mss: Validate modem blob firmware size before load
Date:   Thu, 11 Feb 2021 16:02:38 +0100
Message-Id: <20210211150147.944349082@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150147.743660073@linuxfoundation.org>
References: <20210211150147.743660073@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sibi Sankar <sibis@codeaurora.org>

commit 135b9e8d1cd8ba5ac9ad9bcf24b464b7b052e5b8 upstream

The following mem abort is observed when one of the modem blob firmware
size exceeds the allocated mpss region. Fix this by restricting the copy
size to segment size using request_firmware_into_buf before load.

Err Logs:
Unable to handle kernel paging request at virtual address
Mem abort info:
...
Call trace:
  __memcpy+0x110/0x180
  rproc_start+0xd0/0x190
  rproc_boot+0x404/0x550
  state_store+0x54/0xf8
  dev_attr_store+0x44/0x60
  sysfs_kf_write+0x58/0x80
  kernfs_fop_write+0x140/0x230
  vfs_write+0xc4/0x208
  ksys_write+0x74/0xf8
...

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Fixes: 051fb70fd4ea4 ("remoteproc: qcom: Driver for the self-authenticating Hexagon v5")
Cc: stable@vger.kernel.org
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Link: https://lore.kernel.org/r/20200722201047.12975-3-sibis@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
[sudip: manual backport to old file path]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/qcom_q6v5_pil.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/remoteproc/qcom_q6v5_pil.c
+++ b/drivers/remoteproc/qcom_q6v5_pil.c
@@ -739,14 +739,13 @@ static int q6v5_mpss_load(struct q6v5 *q
 
 		if (phdr->p_filesz) {
 			snprintf(seg_name, sizeof(seg_name), "modem.b%02d", i);
-			ret = request_firmware(&seg_fw, seg_name, qproc->dev);
+			ret = request_firmware_into_buf(&seg_fw, seg_name, qproc->dev,
+							ptr, phdr->p_filesz);
 			if (ret) {
 				dev_err(qproc->dev, "failed to load %s\n", seg_name);
 				goto release_firmware;
 			}
 
-			memcpy(ptr, seg_fw->data, seg_fw->size);
-
 			release_firmware(seg_fw);
 		}
 



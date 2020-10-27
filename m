Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D5F29C487
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460345AbgJ0ORg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:17:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2900917AbgJ0ORd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:17:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DC6B2076A;
        Tue, 27 Oct 2020 14:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808253;
        bh=nMiF1lKpcngVdHRPcUz0KtDMqUpQA3P+mK8wD6eK9UE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oLGE9wsmFoJD/vRZ1NZ5kgL7nYOiCJtbDg0AeomgISGHm1G5cL7Nn1to1CNbdyYfi
         8AZaEvSLOTV8BfyKWloyYGCSQUvGS2Mim2pLCTsEGpGyvohw83nlMlzhEgn2IwKrWB
         JcUZv5A0XL5xERq1N8d617ZZSibDta7WmiuFZfgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Defang Bo <bodefang@126.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 022/264] nfc: Ensure presence of NFC_ATTR_FIRMWARE_NAME attribute in nfc_genl_fw_download()
Date:   Tue, 27 Oct 2020 14:51:20 +0100
Message-Id: <20201027135431.698419319@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Defang Bo <bodefang@126.com>

[ Upstream commit 280e3ebdafb863b3cb50d5842f056267e15bf40c ]

Check that the NFC_ATTR_FIRMWARE_NAME attributes are provided by
the netlink client prior to accessing them.This prevents potential
unhandled NULL pointer dereference exceptions which can be triggered
by malicious user-mode programs, if they omit one or both of these
attributes.

Similar to commit a0323b979f81 ("nfc: Ensure presence of required attributes in the activate_target handler").

Fixes: 9674da8759df ("NFC: Add firmware upload netlink command")
Signed-off-by: Defang Bo <bodefang@126.com>
Link: https://lore.kernel.org/r/1603107538-4744-1-git-send-email-bodefang@126.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1235,7 +1235,7 @@ static int nfc_genl_fw_download(struct s
 	u32 idx;
 	char firmware_name[NFC_FIRMWARE_NAME_MAXSIZE + 1];
 
-	if (!info->attrs[NFC_ATTR_DEVICE_INDEX])
+	if (!info->attrs[NFC_ATTR_DEVICE_INDEX] || !info->attrs[NFC_ATTR_FIRMWARE_NAME])
 		return -EINVAL;
 
 	idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);



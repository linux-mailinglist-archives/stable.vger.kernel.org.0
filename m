Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E5E247084
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388519AbgHQSKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:10:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388419AbgHQQHi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:07:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57A05207FF;
        Mon, 17 Aug 2020 16:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680457;
        bh=FUZwdoJcDyZhXonX3b0z2SZLVlmKS7j3/PGP0+6wo7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oArvwCu7tEQIHn3efikmZRz87dPRck+GtURZyTvToJk7FzuAGLLgPh8hnNEQaWJ9O
         aQraMMPLKokaf+bUO7jzu9hP6zblipMggc55CpRS+2Uu6cU/Hcbm0VQ+E+yl8vQkTP
         xpwpFqNT9nSjoEmmsjpHjIjY6eV3xhECxmxrb7JE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ruslan Bilovol <ruslan.bilovol@gmail.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 164/270] usb: gadget: f_uac2: fix AC Interface Header Descriptor wTotalLength
Date:   Mon, 17 Aug 2020 17:16:05 +0200
Message-Id: <20200817143804.005922078@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ruslan Bilovol <ruslan.bilovol@gmail.com>

[ Upstream commit a9cf8715180b18c62addbfe6f6267b8101903119 ]

As per UAC2 spec (ch. 4.7.2), wTotalLength of AC Interface
Header Descriptor "includes the combined length of this
descriptor header and all Clock Source, Unit and Terminal
descriptors."

Thus add its size to its wTotalLength.

Also after recent changes wTotalLength is calculated
dynamically, update static definition of uac2_ac_header_descriptor
accordingly

Fixes: 132fcb460839 ("usb: gadget: Add Audio Class 2.0 Driver")
Signed-off-by: Ruslan Bilovol <ruslan.bilovol@gmail.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_uac2.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
index db2d4980cb354..3633df6d7610f 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -215,10 +215,7 @@ static struct uac2_ac_header_descriptor ac_hdr_desc = {
 	.bDescriptorSubtype = UAC_MS_HEADER,
 	.bcdADC = cpu_to_le16(0x200),
 	.bCategory = UAC2_FUNCTION_IO_BOX,
-	.wTotalLength = cpu_to_le16(sizeof in_clk_src_desc
-			+ sizeof out_clk_src_desc + sizeof usb_out_it_desc
-			+ sizeof io_in_it_desc + sizeof usb_in_ot_desc
-			+ sizeof io_out_ot_desc),
+	/* .wTotalLength = DYNAMIC */
 	.bmControls = 0,
 };
 
@@ -501,7 +498,7 @@ static void setup_descriptor(struct f_uac2_opts *opts)
 	as_in_hdr_desc.bTerminalLink = usb_in_ot_desc.bTerminalID;
 
 	iad_desc.bInterfaceCount = 1;
-	ac_hdr_desc.wTotalLength = 0;
+	ac_hdr_desc.wTotalLength = cpu_to_le16(sizeof(ac_hdr_desc));
 
 	if (EPIN_EN(opts)) {
 		u16 len = le16_to_cpu(ac_hdr_desc.wTotalLength);
-- 
2.25.1




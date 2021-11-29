Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3848E4627A4
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236546AbhK2XIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:08:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236494AbhK2XHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:07:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4594C144FE1;
        Mon, 29 Nov 2021 10:33:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0A359CE13DE;
        Mon, 29 Nov 2021 18:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A828BC53FCD;
        Mon, 29 Nov 2021 18:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210827;
        bh=GulHi1YwWbYKSoO1RvTO0kOtsafo4XxM0G0tqyBxGlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AkgAHvWyDRuUqGojekkih+Ov+iClZ2QsEFYku6Np61YAAYbUkKh0mtPTmB7MpO4wI
         Ok2+HYKi7M2D0Ii0lqvsXnyITPlAhTP/8bUSbmU8maQFOxTqZZfeWOdy0S0UgW1gkR
         B+jNo65qWWWiuBlHExZ+0ThQ/7yhnffnIuCIhJsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 001/179] scsi: sd: Fix sd_do_mode_sense() buffer length handling
Date:   Mon, 29 Nov 2021 19:16:35 +0100
Message-Id: <20211129181718.964384555@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit c749301ebee82eb5e97dec14b6ab31a4aabe37a6 upstream.

For devices that explicitly asked for MODE SENSE(10) use, make sure that
scsi_mode_sense() is called with a buffer of at least 8 bytes so that the
sense header fits.

Link: https://lore.kernel.org/r/20210820070255.682775-4-damien.lemoal@wdc.com
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sd.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2607,6 +2607,13 @@ sd_do_mode_sense(struct scsi_disk *sdkp,
 		 unsigned char *buffer, int len, struct scsi_mode_data *data,
 		 struct scsi_sense_hdr *sshdr)
 {
+	/*
+	 * If we must use MODE SENSE(10), make sure that the buffer length
+	 * is at least 8 bytes so that the mode sense header fits.
+	 */
+	if (sdkp->device->use_10_for_ms && len < 8)
+		len = 8;
+
 	return scsi_mode_sense(sdkp->device, dbd, modepage, buffer, len,
 			       SD_TIMEOUT, sdkp->max_retries, data,
 			       sshdr);



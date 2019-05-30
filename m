Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1082F4E9
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbfE3DMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:12:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728094AbfE3DMK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:10 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5C86244F1;
        Thu, 30 May 2019 03:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185929;
        bh=o3Ygkgj+RVPapNwx8da6R0BOzSHKC8ADFuftMiEDxZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sw42Ufqb3NkX91KO2wE2K4LtvPJCxzehRl9IM+DIWpgRGSasng3govbJpxF8d1geC
         y/cxbinlK8iJDyMBTIAtn9H1KftOxsceLTXWwFdNdmSA3RAZNBhhh5L8h5MVYgQ2x0
         N7vZ/+Vf5H7tcwqZh5c7XvVw48S2jOxpTiM4mr2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 287/405] media: wl128x: prevent two potential buffer overflows
Date:   Wed, 29 May 2019 20:04:45 -0700
Message-Id: <20190530030555.395369139@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9c2ccc324b3a6cbc865ab8b3e1a09e93d3c8ade9 ]

Smatch marks skb->data as untrusted so it warns that "evt_hdr->dlen"
can copy up to 255 bytes and we only have room for two bytes.  Even
if this comes from the firmware and we trust it, the new policy
generally is just to fix it as kernel hardenning.

I can't test this code so I tried to be very conservative.  I considered
not allowing "evt_hdr->dlen == 1" because it doesn't initialize the
whole variable but in the end I decided to allow it and manually
initialized "asic_id" and "asic_ver" to zero.

Fixes: e8454ff7b9a4 ("[media] drivers:media:radio: wl128x: FM Driver Common sources")

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/radio/wl128x/fmdrv_common.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index 3c8987af37725..ac5706b4cab84 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -489,7 +489,8 @@ int fmc_send_cmd(struct fmdev *fmdev, u8 fm_op, u16 type, void *payload,
 		return -EIO;
 	}
 	/* Send response data to caller */
-	if (response != NULL && response_len != NULL && evt_hdr->dlen) {
+	if (response != NULL && response_len != NULL && evt_hdr->dlen &&
+	    evt_hdr->dlen <= payload_len) {
 		/* Skip header info and copy only response data */
 		skb_pull(skb, sizeof(struct fm_event_msg_hdr));
 		memcpy(response, skb->data, evt_hdr->dlen);
@@ -583,6 +584,8 @@ static void fm_irq_handle_flag_getcmd_resp(struct fmdev *fmdev)
 		return;
 
 	fm_evt_hdr = (void *)skb->data;
+	if (fm_evt_hdr->dlen > sizeof(fmdev->irq_info.flag))
+		return;
 
 	/* Skip header info and copy only response data */
 	skb_pull(skb, sizeof(struct fm_event_msg_hdr));
@@ -1308,7 +1311,7 @@ static int load_default_rx_configuration(struct fmdev *fmdev)
 static int fm_power_up(struct fmdev *fmdev, u8 mode)
 {
 	u16 payload;
-	__be16 asic_id, asic_ver;
+	__be16 asic_id = 0, asic_ver = 0;
 	int resp_len, ret;
 	u8 fw_name[50];
 
-- 
2.20.1




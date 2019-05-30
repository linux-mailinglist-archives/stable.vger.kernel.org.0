Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 342742EC7D
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730939AbfE3DVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:21:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732506AbfE3DVR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:21:17 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC2D3249DA;
        Thu, 30 May 2019 03:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186476;
        bh=hqO8khmazp4lM1KFVi1BgHAUrnclTL+xalaZPhEo3hE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sJZB6USRY6akt0L/eQxxtQieUapVRk+ihKYWvePGeYTu/gN1arVyDKTzQBqoGX4aH
         pRc/zhtWOK5GVwFWdSVGc2OsDzPx8zuFEaMrBAkshuYc2rq5xp1MUmqeSk3rRzgeYY
         Ad/jJ9uZQ/CvCkXxSA7V+rSTYTbeGMaNC+vNL2E0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 110/128] media: wl128x: prevent two potential buffer overflows
Date:   Wed, 29 May 2019 20:07:22 -0700
Message-Id: <20190530030454.354971883@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
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
index 642b89c66bcb9..c1457cf466981 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -494,7 +494,8 @@ int fmc_send_cmd(struct fmdev *fmdev, u8 fm_op, u16 type, void *payload,
 		return -EIO;
 	}
 	/* Send response data to caller */
-	if (response != NULL && response_len != NULL && evt_hdr->dlen) {
+	if (response != NULL && response_len != NULL && evt_hdr->dlen &&
+	    evt_hdr->dlen <= payload_len) {
 		/* Skip header info and copy only response data */
 		skb_pull(skb, sizeof(struct fm_event_msg_hdr));
 		memcpy(response, skb->data, evt_hdr->dlen);
@@ -590,6 +591,8 @@ static void fm_irq_handle_flag_getcmd_resp(struct fmdev *fmdev)
 		return;
 
 	fm_evt_hdr = (void *)skb->data;
+	if (fm_evt_hdr->dlen > sizeof(fmdev->irq_info.flag))
+		return;
 
 	/* Skip header info and copy only response data */
 	skb_pull(skb, sizeof(struct fm_event_msg_hdr));
@@ -1315,7 +1318,7 @@ static int load_default_rx_configuration(struct fmdev *fmdev)
 static int fm_power_up(struct fmdev *fmdev, u8 mode)
 {
 	u16 payload;
-	__be16 asic_id, asic_ver;
+	__be16 asic_id = 0, asic_ver = 0;
 	int resp_len, ret;
 	u8 fw_name[50];
 
-- 
2.20.1




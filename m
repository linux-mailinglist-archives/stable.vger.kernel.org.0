Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD78291B6D
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732262AbgJRTaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:30:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732118AbgJRT1c (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:27:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C427522273;
        Sun, 18 Oct 2020 19:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049251;
        bh=1hl3tSGkMvAO2zttaOP20rG5Ux1kiz5ts/NfBrKhXiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kpoh1Unmrw6GQEX9d5000y3nxRH44vRyBkMBX5YWlvEggAHJm6+8MOt0ahwt0sg0C
         cdl6IMaHdLdpaTWeUnO2MJHq5AGOovJKBllm/zgWlCcB9GSQR1Sx8DWUWCauULw0Ed
         1K/cCd7SuZp33Vv/aqnnIP8WTOLQg+60SypDsjGg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        syzbot+998261c2ae5932458f6c@syzkaller.appspotmail.com,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 02/33] media: ati_remote: sanity check for both endpoints
Date:   Sun, 18 Oct 2020 15:26:57 -0400
Message-Id: <20201018192728.4056577-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192728.4056577-1-sashal@kernel.org>
References: <20201018192728.4056577-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit a8be80053ea74bd9c3f9a3810e93b802236d6498 ]

If you do sanity checks, you should do them for both endpoints.
Hence introduce checking for endpoint type for the output
endpoint, too.

Reported-by: syzbot+998261c2ae5932458f6c@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/ati_remote.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index a35631891cc00..3c3f4c4f6be40 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -843,6 +843,10 @@ static int ati_remote_probe(struct usb_interface *interface,
 		err("%s: endpoint_in message size==0? \n", __func__);
 		return -ENODEV;
 	}
+	if (!usb_endpoint_is_int_out(endpoint_out)) {
+		err("%s: Unexpected endpoint_out\n", __func__);
+		return -ENODEV;
+	}
 
 	ati_remote = kzalloc(sizeof (struct ati_remote), GFP_KERNEL);
 	rc_dev = rc_allocate_device();
-- 
2.25.1


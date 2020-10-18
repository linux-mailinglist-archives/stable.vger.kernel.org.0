Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59533291CBF
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730737AbgJRTYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:24:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730732AbgJRTYX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:24:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77BFB207DE;
        Sun, 18 Oct 2020 19:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049063;
        bh=uShSwgWGEs5x0bqB2yLBn4qSmflObXXmwLUKWYkG47k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5eKJp9k1YvyaY9Qv271HSmOetNpBrZvj4knnl+wQ+/SwevnbtNx6D1BpQcZnCVqN
         OdvHUqHWeP7B7GQmEz6kuwA+wUaG++53531+kfO5+x8XEfBKW7M6TF3ZmqolZMWaqR
         rSG4SLbGkKXwrQxHsr2pUa9kMadI9MPoawGgX4KM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        syzbot+998261c2ae5932458f6c@syzkaller.appspotmail.com,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/56] media: ati_remote: sanity check for both endpoints
Date:   Sun, 18 Oct 2020 15:23:25 -0400
Message-Id: <20201018192417.4055228-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192417.4055228-1-sashal@kernel.org>
References: <20201018192417.4055228-1-sashal@kernel.org>
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
index 8e82610ffaad5..01c82da8e9aa2 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -845,6 +845,10 @@ static int ati_remote_probe(struct usb_interface *interface,
 		err("%s: endpoint_in message size==0? \n", __func__);
 		return -ENODEV;
 	}
+	if (!usb_endpoint_is_int_out(endpoint_out)) {
+		err("%s: Unexpected endpoint_out\n", __func__);
+		return -ENODEV;
+	}
 
 	ati_remote = kzalloc(sizeof (struct ati_remote), GFP_KERNEL);
 	rc_dev = rc_allocate_device(RC_DRIVER_SCANCODE);
-- 
2.25.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D6229AEF6
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754592AbgJ0OGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:06:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754577AbgJ0OGB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:06:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 068E322263;
        Tue, 27 Oct 2020 14:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807561;
        bh=jHv1IA6LQU7+/SPx/H7AeHePLNsVE4JaFt4uu2TZIe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z6kx3B9neLTbU9yg+IHyC5LMKcoRl0kn9e6P+k3Yhz/xwmt19XqtPZLR2EdyCthHl
         otl5N+AMSOR+O76R2cfQnyGQE8wjmx1FLAkJYf3eZxzUR73YyTYr+K2nTKkn73JXYF
         FulW/Bisc4lgtYbThnqsUwFCjvUahiF3majCX2KM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+998261c2ae5932458f6c@syzkaller.appspotmail.com,
        Oliver Neukum <oneukum@suse.com>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 096/139] media: ati_remote: sanity check for both endpoints
Date:   Tue, 27 Oct 2020 14:49:50 +0100
Message-Id: <20201027134906.689490365@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134902.130312227@linuxfoundation.org>
References: <20201027134902.130312227@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 9f5b59706741c..7f98db4bc0277 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -850,6 +850,10 @@ static int ati_remote_probe(struct usb_interface *interface,
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




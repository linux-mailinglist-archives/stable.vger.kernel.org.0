Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9543020DF43
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbgF2Udx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:33:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732324AbgF2TZQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9005325412;
        Mon, 29 Jun 2020 15:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445361;
        bh=nP8oIgmJpbzfY6b3GAwgSxttlTlWjyHWpqt+kc6asSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=046m34ygQnu7kbIAQPZP6WiLGdSLtAFBZe/Qyfg5KQt0poBnXwk5cxvSRokT+KwOR
         nZ9splUDImmECVymS6I6tA1vCbGnbg7F5qLjyim0K2av4P3W2obLwo80P6pCB+DCMj
         MqzndbpWF9K0SZsS9rhSEMBx9izK+3xx03n9nX30=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 118/191] media: dvb_frontend: fix return error code
Date:   Mon, 29 Jun 2020 11:38:54 -0400
Message-Id: <20200629154007.2495120-119-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

commit 330dada5957e3ca0c8811b14c45e3ac42c694651 upstream

The correct error code when a function is not defined is
-ENOTSUPP. It was typoed wrong as -EOPNOTSUPP, with,
unfortunately, exists, but it is not used by the DVB core.

Thanks-to: Geert Uytterhoeven <geert@linux-m68k.org>
Thanks-to: Arnd Bergmann <arnd@arndb.de>

To make me revisit this code.

Fixes: a9cb97c3e628 ("media: dvb_frontend: be sure to init dvb_frontend_handle_ioctl() return code")
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 740dedf033616..cd45b38946616 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2265,7 +2265,7 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int i, err = -EOPNOTSUPP;
+	int i, err = -ENOTSUPP;
 
 	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
-- 
2.25.1


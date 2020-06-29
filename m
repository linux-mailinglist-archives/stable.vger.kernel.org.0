Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73E020DF4C
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732148AbgF2UeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:34:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731826AbgF2TZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A83B253FD;
        Mon, 29 Jun 2020 15:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445347;
        bh=UponP9uN0FZddsIhE5IxvCzsuffNzGdTbdtmDVu3vF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZ6J3+jImw7z/fN9eqUIJFpKwYr7XEDwBE1J36PogTVuyfypIXPY1pwmyPF3XvGet
         SpAC0KWFTwU/V9ve9UQAlPi/TvuApWrp4+cvHGVAop91QIleqpXren6E3ZnuOoqT+2
         9q/2pkO8AL2D+VFwsqG/m7aUyllgIYtgy2f36frs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 105/191] media: friio-fe: get rid of set_property()
Date:   Mon, 29 Jun 2020 11:38:41 -0400
Message-Id: <20200629154007.2495120-106-sashal@kernel.org>
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

commit b2c41ca9632e686e79f6c9db9c5f75666d37926e upstream

This callback is not actually doing anything but making it to
return an error depending on the DTV frontend command. Well,
that could break userspace for no good reason, and, if needed,
should be implemented, instead, at set_frontend() callback.

So, get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/dvb-usb/friio-fe.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/friio-fe.c b/drivers/media/usb/dvb-usb/friio-fe.c
index 979f05b4b87ca..237f12f9a7f24 100644
--- a/drivers/media/usb/dvb-usb/friio-fe.c
+++ b/drivers/media/usb/dvb-usb/friio-fe.c
@@ -261,28 +261,6 @@ static int jdvbt90502_read_signal_strength(struct dvb_frontend *fe,
 	return 0;
 }
 
-
-/* filter out un-supported properties to notify users */
-static int jdvbt90502_set_property(struct dvb_frontend *fe,
-				   struct dtv_property *tvp)
-{
-	int r = 0;
-
-	switch (tvp->cmd) {
-	case DTV_DELIVERY_SYSTEM:
-		if (tvp->u.data != SYS_ISDBT)
-			r = -EINVAL;
-		break;
-	case DTV_CLEAR:
-	case DTV_TUNE:
-	case DTV_FREQUENCY:
-		break;
-	default:
-		r = -EINVAL;
-	}
-	return r;
-}
-
 static int jdvbt90502_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
@@ -457,8 +435,6 @@ static struct dvb_frontend_ops jdvbt90502_ops = {
 	.init = jdvbt90502_init,
 	.write = _jdvbt90502_write,
 
-	.set_property = jdvbt90502_set_property,
-
 	.set_frontend = jdvbt90502_set_frontend,
 
 	.read_status = jdvbt90502_read_status,
-- 
2.25.1


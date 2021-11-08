Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC37E44A226
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240853AbhKIBQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:16:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:44174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242876AbhKIBO2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:14:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41B7F61A8B;
        Tue,  9 Nov 2021 01:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419951;
        bh=25jiBG1ykyFIvh1S9ZIFgDtxICbjEu2CanOLhX6GUrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NiSbVvUFoRUT+LONNG4P6tcZ/QXq0Qpw2ezjcmRArOvioeV45Vkxtsw+muD1KU4kE
         MmUfhOmlaU9aG3NqWBvNixJ3iecsB4z/oX206Jemj0NxWoRL0MyQT9awe70hEJrbCq
         o2obED/HFnDoCq1LQosMRExRdEA9c0ybJkdF0Yo8fjhaGgti0PnlrNhIUV0s2QUkI0
         yJFds7BBI8jYvfUlHT1S7F7096O1uGIrYkl54/4ihGx2IMjsygsQvRnFhjPkdMOs2A
         G9//kjwvmRimSXhQFEx3HOgDBHH0v26a58NUsGLgweulLKQmdhlqCw0qOBe18RaEFh
         FnuJgDKwgolfg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rajat Asthana <rajatasthana4@gmail.com>,
        syzbot+4d3749e9612c2cfab956@syzkaller.appspotmail.com,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 20/47] media: mceusb: return without resubmitting URB in case of -EPROTO error.
Date:   Mon,  8 Nov 2021 12:50:04 -0500
Message-Id: <20211108175031.1190422-20-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108175031.1190422-1-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rajat Asthana <rajatasthana4@gmail.com>

[ Upstream commit 476db72e521983ecb847e4013b263072bb1110fc ]

Syzkaller reported a warning called "rcu detected stall in dummy_timer".

The error seems to be an error in mceusb_dev_recv(). In the case of
-EPROTO error, the routine immediately resubmits the URB. Instead it
should return without resubmitting URB.

Reported-by: syzbot+4d3749e9612c2cfab956@syzkaller.appspotmail.com
Signed-off-by: Rajat Asthana <rajatasthana4@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/mceusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 845583e2af4d5..cf4bcf7c62f2e 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1323,6 +1323,7 @@ static void mceusb_dev_recv(struct urb *urb)
 	case -ECONNRESET:
 	case -ENOENT:
 	case -EILSEQ:
+	case -EPROTO:
 	case -ESHUTDOWN:
 		usb_unlink_urb(urb);
 		return;
-- 
2.33.0


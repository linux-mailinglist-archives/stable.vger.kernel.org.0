Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97B044A2B5
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241949AbhKIBT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:19:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:46484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241845AbhKIBRw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:17:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A1DF6105A;
        Tue,  9 Nov 2021 01:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420039;
        bh=aS48cdu/g7cxpO4hT84SWpmFYddKWPbxux5idUI8kbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lEy7lr82aFXIZ9M+u+mCcxN5HBFXbbR9CxqBlPCHxU9Td6SO9zeXCdC661H0WnxJR
         liO4LBPWwHUrF6jdrr3D7KUd3YMlDUB8EGYedtEa9fF0y+Uyos1dxNDZcV36R7ja+M
         hEGIiPXJlsgfjFK91pkcTaQYNUQiAt0WEMSWqRVLG56DL8TZ4SFKO50OVdv8NpNyq8
         Ci1i0Us22bJO9lp4CGaQD1BihF7scKTemhUyEmStQ6qqtev7RvmAJo+vIziEYMOzpb
         1dBOgEOnJM7e19XRL2IBv7JlKggvqNBbJL54/3DYOqSDSnvNGJmZmipnEoS7gwIxnh
         HavIaPF+zPbmg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rajat Asthana <rajatasthana4@gmail.com>,
        syzbot+4d3749e9612c2cfab956@syzkaller.appspotmail.com,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 17/39] media: mceusb: return without resubmitting URB in case of -EPROTO error.
Date:   Mon,  8 Nov 2021 20:06:27 -0500
Message-Id: <20211109010649.1191041-17-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010649.1191041-1-sashal@kernel.org>
References: <20211109010649.1191041-1-sashal@kernel.org>
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
index bbbbfd697f9c4..035b2455b26aa 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1080,6 +1080,7 @@ static void mceusb_dev_recv(struct urb *urb)
 	case -ECONNRESET:
 	case -ENOENT:
 	case -EILSEQ:
+	case -EPROTO:
 	case -ESHUTDOWN:
 		usb_unlink_urb(urb);
 		return;
-- 
2.33.0


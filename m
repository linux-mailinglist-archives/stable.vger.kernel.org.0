Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 883644526A9
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239368AbhKPCJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:09:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:40726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238089AbhKORym (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:54:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2DB16327E;
        Mon, 15 Nov 2021 17:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997573;
        bh=CaENJ6ArXgaoAx/3ZZd9sL+dCs/vCIBBdf053UZN8DU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VaHtmkEuvCQktKQFVWbqGxme8L+BPNOYK6i4xVBCktlCj4C8OL2VKwMtIylTSjH7F
         pANJ1a5spXd6vlyzx1ddRavebcTt2D/15sUnvun/kWMvYMwvKFAksY++GiXpZxICAw
         ROIvWLeTxBh4dzWhP6UZsoBJD7A4l1/7GM62tyu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+4d3749e9612c2cfab956@syzkaller.appspotmail.com,
        Rajat Asthana <rajatasthana4@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 198/575] media: mceusb: return without resubmitting URB in case of -EPROTO error.
Date:   Mon, 15 Nov 2021 17:58:43 +0100
Message-Id: <20211115165350.557049534@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5642595a057ec..8870c4e6c5f44 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1386,6 +1386,7 @@ static void mceusb_dev_recv(struct urb *urb)
 	case -ECONNRESET:
 	case -ENOENT:
 	case -EILSEQ:
+	case -EPROTO:
 	case -ESHUTDOWN:
 		usb_unlink_urb(urb);
 		return;
-- 
2.33.0




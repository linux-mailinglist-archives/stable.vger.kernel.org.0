Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 689C945B9EF
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239376AbhKXMGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:06:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:33112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242136AbhKXMF6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:05:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87DB160FDC;
        Wed, 24 Nov 2021 12:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755369;
        bh=ajKFuw6OzkumHocnwxV/0XnlPlwEXcr5Ee7zwODGrmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bsJzsPUT+aJJ4JMRY9pOLVcWxqjpipwJxW8jHKq0Umg+//As/4yObwvNdO6QmFjxR
         r8UlaDo9ZM7SRSfMhpV80cLaWnzsjyLX+UEH2bPc0bK5FG+XezJ6NItjUvgIaJJr2I
         eHtU1n0gBSUu4Nl5ICRUtTW+1DOK+754TLHJ54Uw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+4d3749e9612c2cfab956@syzkaller.appspotmail.com,
        Rajat Asthana <rajatasthana4@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 053/162] media: mceusb: return without resubmitting URB in case of -EPROTO error.
Date:   Wed, 24 Nov 2021 12:55:56 +0100
Message-Id: <20211124115700.056106984@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
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
index 0fba4a2c16028..7b9800d3446cf 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1079,6 +1079,7 @@ static void mceusb_dev_recv(struct urb *urb)
 	case -ECONNRESET:
 	case -ENOENT:
 	case -EILSEQ:
+	case -EPROTO:
 	case -ESHUTDOWN:
 		usb_unlink_urb(urb);
 		return;
-- 
2.33.0




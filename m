Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8BDF44A38F
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243323AbhKIB1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:27:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:50182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244265AbhKIBZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:25:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CDFD61B46;
        Tue,  9 Nov 2021 01:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420182;
        bh=ajKFuw6OzkumHocnwxV/0XnlPlwEXcr5Ee7zwODGrmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZHBAXA75WCJBHl06bKayByqXggDZVF7EBTfh1a0HkcK9Voj+RgP1dv/c7HQN+VfpZ
         srX+63hzLFR90Xw527iFBxL20Y8uAftW+USsHtNfVJ5TugX1MtP2myfE3zfJNW22+a
         7nWNr9krdfASTw7GJ40Y0D75dyE+h5XgLlJLu2EjfbxAwe7FFiHlESkqEfbT4dyd2V
         MyOsSziMNFgleJt98EwBYyGqHTWfFTICjEQDkuCbJluCDHOi2Q91dWALDFCn4e03Ce
         4iyHed5CA4xDpTI+iG1rmKa5JG+OK78/9W0LHVbko7YxqHAWC3DvHhFF6e9/20zIwD
         9ak7vTvlvsOug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rajat Asthana <rajatasthana4@gmail.com>,
        syzbot+4d3749e9612c2cfab956@syzkaller.appspotmail.com,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 13/30] media: mceusb: return without resubmitting URB in case of -EPROTO error.
Date:   Mon,  8 Nov 2021 20:09:01 -0500
Message-Id: <20211109010918.1192063-13-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010918.1192063-1-sashal@kernel.org>
References: <20211109010918.1192063-1-sashal@kernel.org>
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC0944A339
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242839AbhKIB0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:26:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:47860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242860AbhKIBVe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:21:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB06661B1E;
        Tue,  9 Nov 2021 01:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420112;
        bh=Xvip36oCyCXhVCDD2f1axnCfsa43jG9xmFBr55XnKVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fbVwTR+p9gFT4yYizPw0HcpBB0rrSEiFjICZBew9RenI0ERLXHknPIf/BmZuVZUPa
         AWOL1GC0ULbyg+HTwko1DAcBCjeS8Bqps4jbplFT+Oz9ATw4loz2glh34r/z7s29OK
         7nO2OCctTYeC32KTcOYP4687HpkpYw4wBa9nmQR6fJkC2TVEgmdwhwhijLPQIVzOYa
         9a/N4/1kabqT3tT1UuZS970PtyBcXr/CT4p3Zt24RxJJ9WUrrS0D24WgtZXsy/aV6b
         4gWjXdeDo9L7Sv2AW4qpgRwoht+utj+0MXmIpNM8YDZasMUhPR7bY3dg7eobxsUUIK
         bv27gsJK9hCbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rajat Asthana <rajatasthana4@gmail.com>,
        syzbot+4d3749e9612c2cfab956@syzkaller.appspotmail.com,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 14/33] media: mceusb: return without resubmitting URB in case of -EPROTO error.
Date:   Mon,  8 Nov 2021 20:07:48 -0500
Message-Id: <20211109010807.1191567-14-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010807.1191567-1-sashal@kernel.org>
References: <20211109010807.1191567-1-sashal@kernel.org>
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
index d9f88a4a96bd1..b78d70685b1c3 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1090,6 +1090,7 @@ static void mceusb_dev_recv(struct urb *urb)
 	case -ECONNRESET:
 	case -ENOENT:
 	case -EILSEQ:
+	case -EPROTO:
 	case -ESHUTDOWN:
 		usb_unlink_urb(urb);
 		return;
-- 
2.33.0


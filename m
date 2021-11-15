Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E7945278D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238340AbhKPC0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:26:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:47402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236826AbhKORU5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:20:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44BBB63244;
        Mon, 15 Nov 2021 17:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996522;
        bh=iuyJNY5U6N1jnZT+DaqZYh6NnGPNuqZnalEfVca8L/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wndepRrWgmLyhFDz2o2pLQPLFh43gldK9CpWdEDEhcPh924AKW91b597mKwnPvHcn
         rTAtakU736nGlgPFQAcXmU5C1Y3+IwkDYQ8abSwKqhzFcr2glxCL0PABaq5m2TFMJM
         zV19SJ58lYCpGdDY1brCnJ1itSxQCBIGA/iuIvCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+4d3749e9612c2cfab956@syzkaller.appspotmail.com,
        Rajat Asthana <rajatasthana4@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 138/355] media: mceusb: return without resubmitting URB in case of -EPROTO error.
Date:   Mon, 15 Nov 2021 18:01:02 +0100
Message-Id: <20211115165318.260942604@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
index c68e52c17ae13..31e56f4f34791 100644
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75252452418
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354049AbhKPBgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:36:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:46046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242564AbhKOSiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:38:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73203632E0;
        Mon, 15 Nov 2021 18:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999402;
        bh=CaENJ6ArXgaoAx/3ZZd9sL+dCs/vCIBBdf053UZN8DU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FcM0dHuI+odKP9W9Yks+G5+jydWVydjJUT1uExMDMST/L+6URuMh9fprhi8HBWDP+
         Re2VLXhfCU8iaJ8l2aPpKCQGOX9qnrodAMnmh/n+KSO7cIOMz7g4RuTvm7UZ0FPtFy
         DNtKG21wufLYHWZqpg4d0C/8BHgsl82YWQpGAl9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+4d3749e9612c2cfab956@syzkaller.appspotmail.com,
        Rajat Asthana <rajatasthana4@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 251/849] media: mceusb: return without resubmitting URB in case of -EPROTO error.
Date:   Mon, 15 Nov 2021 17:55:34 +0100
Message-Id: <20211115165428.700852059@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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




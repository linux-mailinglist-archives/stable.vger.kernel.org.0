Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEAF38AA3E
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239607AbhETLLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:11:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240255AbhETLJg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:09:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA5B161D38;
        Thu, 20 May 2021 10:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505203;
        bh=+a7wLmhsn1Ba8Q7V1xVSuyTg7cXW3/lZZGu66B9ZRzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zawMvMo0aFtaxJgoPRnHneIa3kRny6l7YCqlZVe/5F1MzTV+LypBoiWN7K5fhx2Zs
         KKLsbb2r0j6DdnLAaK7jQ8OgN1Ed/pGLBI7vtYyt55S/mgrq40UJ+IJ+BwFRZdk0IE
         eOSV7kMKnljFsSVOFUV/QwtD/Sz7py97bDkwMjf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+889397c820fa56adf25d@syzkaller.appspotmail.com,
        Muhammad Usama Anjum <musamaanjum@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 028/190] media: em28xx: fix memory leak
Date:   Thu, 20 May 2021 11:21:32 +0200
Message-Id: <20210520092103.103072078@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muhammad Usama Anjum <musamaanjum@gmail.com>

[ Upstream commit 0ae10a7dc8992ee682ff0b1752ff7c83d472eef1 ]

If some error occurs, URB buffers should also be freed. If they aren't
freed with the dvb here, the em28xx_dvb_fini call doesn't frees the URB
buffers as dvb is set to NULL. The function in which error occurs should
do all the cleanup for the allocations it had done.

Tested the patch with the reproducer provided by syzbot. This patch
fixes the memleak.

Reported-by: syzbot+889397c820fa56adf25d@syzkaller.appspotmail.com
Signed-off-by: Muhammad Usama Anjum <musamaanjum@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 5502a0fb94fd..a19c89009bf3 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1757,6 +1757,7 @@ ret:
 	return result;
 
 out_free:
+	em28xx_uninit_usb_xfer(dev, EM28XX_DIGITAL_MODE);
 	kfree(dvb);
 	dev->dvb = NULL;
 	goto ret;
-- 
2.30.2




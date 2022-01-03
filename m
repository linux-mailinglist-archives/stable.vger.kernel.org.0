Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D504832A6
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbiACOaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:30:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58480 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbiACO2N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:28:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC8D961126;
        Mon,  3 Jan 2022 14:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42A6C36AED;
        Mon,  3 Jan 2022 14:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220092;
        bh=D7vziGM8fAztn7Lvyb1hUN6jVVq9j/merOsMjP6rLf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gvpXW4IUb5te3WkqLsA1pAIsvVzIPx1vd7RPkJX/Kucbn9DioKyzKsyAkjWeUw8cZ
         IqUnB2H3Yl3kSHMX121Oo92cNn5ovHnoM84naKmetqP3jg21e8D4+sBdhdga+2U1Ae
         znNX4vx4SYbVzp9vMwt5MXY3a06urFK5T2pckDuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        syzbot+e417648b303855b91d8a@syzkaller.appspotmail.com
Subject: [PATCH 5.4 24/37] i2c: validate user data in compat ioctl
Date:   Mon,  3 Jan 2022 15:24:02 +0100
Message-Id: <20220103142052.623863257@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142051.883166998@linuxfoundation.org>
References: <20220103142051.883166998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit bb436283e25aaf1533ce061605d23a9564447bdf ]

Wrong user data may cause warning in i2c_transfer(), ex: zero msgs.
Userspace should not be able to trigger warnings, so this patch adds
validation checks for user data in compact ioctl to prevent reported
warnings

Reported-and-tested-by: syzbot+e417648b303855b91d8a@syzkaller.appspotmail.com
Fixes: 7d5cb45655f2 ("i2c compat ioctls: move to ->compat_ioctl()")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index c9ae1895cd48a..7da6ca26a5f56 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -536,6 +536,9 @@ static long compat_i2cdev_ioctl(struct file *file, unsigned int cmd, unsigned lo
 				   sizeof(rdwr_arg)))
 			return -EFAULT;
 
+		if (!rdwr_arg.msgs || rdwr_arg.nmsgs == 0)
+			return -EINVAL;
+
 		if (rdwr_arg.nmsgs > I2C_RDWR_IOCTL_MAX_MSGS)
 			return -EINVAL;
 
-- 
2.34.1




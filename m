Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D789C483223
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbiACOZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbiACOZU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:25:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9548C061394;
        Mon,  3 Jan 2022 06:25:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6321DCE1103;
        Mon,  3 Jan 2022 14:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187DDC36AF5;
        Mon,  3 Jan 2022 14:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219916;
        bh=i6YmX2xftQcZWyIrcrMfPg39KVEsUySyqA2Ym9bMw4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1117XD8NAlb+OkOxOpgZi1Kp89/yOYUDsk4XNWvbaqIAZTOiw3zA8R7FM6nRq/Qez
         imN1e6VYL//F+VHMql8iuRBK9cFMz3Ddx1fxFO3Jf/UBOSaOONWtbhn4ulG4hpIRBp
         3dzbfqkch5JZsKUDnOni2yfvZMkGxXxRLlQr/SXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        syzbot+e417648b303855b91d8a@syzkaller.appspotmail.com
Subject: [PATCH 4.19 17/27] i2c: validate user data in compat ioctl
Date:   Mon,  3 Jan 2022 15:23:57 +0100
Message-Id: <20220103142052.730848150@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142052.162223000@linuxfoundation.org>
References: <20220103142052.162223000@linuxfoundation.org>
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
index 57aece8098416..140dd074fdee5 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -544,6 +544,9 @@ static long compat_i2cdev_ioctl(struct file *file, unsigned int cmd, unsigned lo
 				   sizeof(rdwr_arg)))
 			return -EFAULT;
 
+		if (!rdwr_arg.msgs || rdwr_arg.nmsgs == 0)
+			return -EINVAL;
+
 		if (rdwr_arg.nmsgs > I2C_RDWR_IOCTL_MAX_MSGS)
 			return -EINVAL;
 
-- 
2.34.1




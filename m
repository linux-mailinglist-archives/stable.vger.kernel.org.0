Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6EA3CDB1B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244602AbhGSOk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:40:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343936AbhGSOjv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:39:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C945761002;
        Mon, 19 Jul 2021 15:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707997;
        bh=rQGy8cqcvQFQWXICBxVU7vxBghpZ8ulbRgzAOF6P3BY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TRa2csLCC8KsPJ1+RLRLCeJEp2eyx4b12DlwpzD6B1B3av07dTwruaaipLlHuBpA1
         BzMc/qZtoJvYMo87krX1IJTgb5sCb5Cpb5paQ8isI75OB+ee1rSu4AseLXLH3IcOeK
         2QVhi8elDJJrSeQ+uS2wiUxYQOSM4eCzQ0gCSciA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 138/315] Input: hil_kbd - fix error return code in hil_dev_connect()
Date:   Mon, 19 Jul 2021 16:50:27 +0200
Message-Id: <20210719144947.430578947@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit d9b576917a1d0efa293801a264150a1b37691617 ]

Return error code -EINVAL rather than '0' when the combo devices are not
supported.

Fixes: fa71c605c2bb ("Input: combine hil_kbd and hil_ptr drivers")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20210515030053.6824-1-thunder.leizhen@huawei.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/hil_kbd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/keyboard/hil_kbd.c b/drivers/input/keyboard/hil_kbd.c
index bb29a7c9a1c0..54afb38601b9 100644
--- a/drivers/input/keyboard/hil_kbd.c
+++ b/drivers/input/keyboard/hil_kbd.c
@@ -512,6 +512,7 @@ static int hil_dev_connect(struct serio *serio, struct serio_driver *drv)
 		    HIL_IDD_NUM_AXES_PER_SET(*idd)) {
 			printk(KERN_INFO PREFIX
 				"combo devices are not supported.\n");
+			error = -EINVAL;
 			goto bail1;
 		}
 
-- 
2.30.2




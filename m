Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937383C4F3E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243009AbhGLHXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:23:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242566AbhGLHWZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:22:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D722D61004;
        Mon, 12 Jul 2021 07:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074375;
        bh=rQGy8cqcvQFQWXICBxVU7vxBghpZ8ulbRgzAOF6P3BY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eKYy5wvPpnQGgBVUbVzpfToKo6c0O3vxtdaQLv0VsUwJrpJ+QFJnXr38I/E3rJgUn
         XkmExFiNbcfRZtF5eXaCUCPLD3mFIe3/Zqtmz5WlNTiPs/O12DEjS/oQsr7Zn01dAD
         saSX7fBc5e/i+r204MFpEiSgL1Z7unWBok3Bwxjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 559/700] Input: hil_kbd - fix error return code in hil_dev_connect()
Date:   Mon, 12 Jul 2021 08:10:42 +0200
Message-Id: <20210712061035.685792078@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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




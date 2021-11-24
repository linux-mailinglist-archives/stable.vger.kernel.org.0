Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F186145BD10
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243494AbhKXMfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:35:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:48574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245610AbhKXMbW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:31:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94496611B0;
        Wed, 24 Nov 2021 12:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756378;
        bh=McNWQySjmbqTpzoI/yucNrWGksWbLX7pdR8n0lDL/Ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CMFpDJlWYzkcH7nnLYOD7VYVOOM04A6AMW38oYBI5yrIPIAL1iQquuGOu6C/RlXdr
         ueG2pxkriassvPNDVz/BEEiV6rPq+HIqNIbT4RLGQKlh1Sl60284yYubwMe9PHlSRh
         zM8XyHYT69uE81BTGggCo97hHJiF9NRu8GrpFRI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.14 064/251] pinctrl: core: fix possible memory leak in pinctrl_enable()
Date:   Wed, 24 Nov 2021 12:55:06 +0100
Message-Id: <20211124115712.466073347@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit c7892ae13e461ed20154321eb792e07ebe38f5b3 upstream.

I got memory leak as follows when doing fault injection test:

unreferenced object 0xffff888020a7a680 (size 64):
  comm "i2c-mcp23018-41", pid 23090, jiffies 4295160544 (age 8.680s)
  hex dump (first 32 bytes):
    00 48 d3 1e 80 88 ff ff 00 1a 56 c1 ff ff ff ff  .H........V.....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000083c79b35>] kmem_cache_alloc_trace+0x16d/0x360
    [<0000000051803c95>] pinctrl_init_controller+0x6ed/0xb70
    [<0000000064346707>] pinctrl_register+0x27/0x80
    [<0000000029b0e186>] devm_pinctrl_register+0x5b/0xe0
    [<00000000391f5a3e>] mcp23s08_probe_one+0x968/0x118a [pinctrl_mcp23s08]
    [<000000006112c039>] mcp230xx_probe+0x266/0x560 [pinctrl_mcp23s08_i2c]

If pinctrl_claim_hogs() fails, the 'pindesc' allocated in pinctrl_register_one_pin()
need be freed.

Cc: stable@vger.kernel.org
Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 950b0d91dc10 ("pinctrl: core: Fix regression caused by delayed work for hogs")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20211022014323.1156924-1-yangyingliang@huawei.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -2061,6 +2061,8 @@ int pinctrl_enable(struct pinctrl_dev *p
 	if (error) {
 		dev_err(pctldev->dev, "could not claim hogs: %i\n",
 			error);
+		pinctrl_free_pindescs(pctldev, pctldev->desc->pins,
+				      pctldev->desc->npins);
 		mutex_destroy(&pctldev->mutex);
 		kfree(pctldev);
 



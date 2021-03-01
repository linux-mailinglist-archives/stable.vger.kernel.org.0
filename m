Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD3F32906A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242903AbhCAUIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:08:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:59346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237746AbhCATzL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:55:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E6E86537A;
        Mon,  1 Mar 2021 17:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621321;
        bh=pQqOCYq2Fyc2CKfnDSBP8L+afUTaVhUpEEHMrvRZRhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jl4hAShOHF3A5oKud2rpOUQ8Ge6XJNNP3vkDFpguZ/tBgLRpN2VqlS5DlUHVuB/M2
         c/I9ks7+Iuiqo2QHEvYou/ciusGmj9L07hOWM58iNJNfqJpt3CyOwK6r+KLJSMvqco
         gFud+hNYPdFHDQrSMCRAE+a89ADG/4RYQL3vr9yo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 474/775] Input: zinitix - fix return type of zinitix_init_touch()
Date:   Mon,  1 Mar 2021 17:10:42 +0100
Message-Id: <20210301161224.967204646@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 836f308cb5c72d48e2dff8d3e64c3adb94f4710d ]

zinitix_init_touch() returns error code or 0 for success and therefore
return type must be int, not bool.

Fixes: 26822652c85e ("Input: add zinitix touchscreen driver")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Link: https://lore.kernel.org/r/YC8z2bXc3Oy8pABa@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/zinitix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/zinitix.c b/drivers/input/touchscreen/zinitix.c
index a3e3adbabc673..b1548971d683e 100644
--- a/drivers/input/touchscreen/zinitix.c
+++ b/drivers/input/touchscreen/zinitix.c
@@ -190,7 +190,7 @@ static int zinitix_write_cmd(struct i2c_client *client, u16 reg)
 	return 0;
 }
 
-static bool zinitix_init_touch(struct bt541_ts_data *bt541)
+static int zinitix_init_touch(struct bt541_ts_data *bt541)
 {
 	struct i2c_client *client = bt541->client;
 	int i;
-- 
2.27.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A49CB66CCEF
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234807AbjAPRbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234742AbjAPRak (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:30:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB38C3FF1E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:07:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BEA561058
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BDFC433EF;
        Mon, 16 Jan 2023 17:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888864;
        bh=U0hDkqDvlSWQMSbMce3Rrw5v7j5Whp3Gj6vYDLA2gzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b21swiINpIsk/0w28EOIZvNfTcFvsp/Ao0mjW/nREH35ArkJipz+EhBcnt5K5Pfno
         ZG15awU8HwZ0/ON26MO9+rMQ4IbqhJqU/iuLyJkZzNW48d6KYFkvy0oMV7aC3ocrqE
         fjtYn3dmSZ7JXHyq/UUmkJswpKYf/zCBk9owqplU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, ruanjinjie <ruanjinjie@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 168/338] misc: tifm: fix possible memory leak in tifm_7xx1_switch_media()
Date:   Mon, 16 Jan 2023 16:50:41 +0100
Message-Id: <20230116154828.219696109@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ruanjinjie <ruanjinjie@huawei.com>

[ Upstream commit fd2c930cf6a5b9176382c15f9acb1996e76e25ad ]

If device_register() returns error in tifm_7xx1_switch_media(),
name of kobject which is allocated in dev_set_name() called in device_add()
is leaked.

Never directly free @dev after calling device_register(), even
if it returned an error! Always use put_device() to give up the
reference initialized.

Fixes: 2428a8fe2261 ("tifm: move common device management tasks from tifm_7xx1 to tifm_core")
Signed-off-by: ruanjinjie <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/r/20221117064725.3478402-1-ruanjinjie@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/tifm_7xx1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/tifm_7xx1.c b/drivers/misc/tifm_7xx1.c
index e5f108713dd8..2afb96598f61 100644
--- a/drivers/misc/tifm_7xx1.c
+++ b/drivers/misc/tifm_7xx1.c
@@ -194,7 +194,7 @@ static void tifm_7xx1_switch_media(struct work_struct *work)
 				spin_unlock_irqrestore(&fm->lock, flags);
 			}
 			if (sock)
-				tifm_free_device(&sock->dev);
+				put_device(&sock->dev);
 		}
 		spin_lock_irqsave(&fm->lock, flags);
 	}
-- 
2.35.1




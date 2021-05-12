Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F3237C97B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235406AbhELQTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:19:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236464AbhELQLY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:11:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF0E061D43;
        Wed, 12 May 2021 15:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834048;
        bh=rDz5qRjYABQPyzkZ6kCJ1PTvOVlV8a368VrTFVLSgRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Q6uWfWu9SHOknjUCacJe7PbHcOb0ABzAEH7/qaViFwni+uhF8Met1Sy4soFBYY/i
         N6Z5ULceivV/2zHCY6wf46Z7weWOVvgxiI1pZovcmq1cGLLgRhIDi4XG7R6J5qmsCh
         DwlEKJ2NDVEXFvVwL1VWfG2GPEqYSO4nmtfueM40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 388/601] drivers/block/null_blk/main: Fix a double free in null_init.
Date:   Wed, 12 May 2021 16:47:45 +0200
Message-Id: <20210512144840.583050110@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit 72ce11ddfa4e9e1879103581a60b7e34547eaa0a ]

In null_init, null_add_dev(dev) is called.
In null_add_dev, it calls null_free_zoned_dev(dev) to free dev->zones
via kvfree(dev->zones) in out_cleanup_zone branch and returns err.
Then null_init accept the err code and then calls null_free_dev(dev).

But in null_free_dev(dev), dev->zones is freed again by
null_free_zoned_dev().

My patch set dev->zones to NULL in null_free_zoned_dev() after
kvfree(dev->zones) is called, to avoid the double free.

Fixes: 2984c8684f962 ("nullb: factor disk parameters")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Link: https://lore.kernel.org/r/20210426143229.7374-1-lyl2019@mail.ustc.edu.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/zoned.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index fce0a54df0e5..8e0656964f1c 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -180,6 +180,7 @@ int null_register_zoned_dev(struct nullb *nullb)
 void null_free_zoned_dev(struct nullb_device *dev)
 {
 	kvfree(dev->zones);
+	dev->zones = NULL;
 }
 
 int null_report_zones(struct gendisk *disk, sector_t sector,
-- 
2.30.2




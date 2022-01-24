Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D727499979
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455479AbiAXVf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:35:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47554 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452996AbiAXV1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:27:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1F60614C9;
        Mon, 24 Jan 2022 21:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4271C340E4;
        Mon, 24 Jan 2022 21:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059654;
        bh=UND6nXt7n9+NZjYujgAg5y31VQ9oBzFhCxZj4nu5wWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4X6EQXZ0QFlxeNo3KxFYdrpLTVICAO7xlufT3AQ0lqIWKlit9/5Zu6yytPWiTGUO
         0BOrz7lG6b6en7S7WzqQACHmZG4CIL0iIWfvplZKfsz2znRFf2jANvhdRpV7jFFQB/
         KBLZmuY3IUMQU9p8jWoLw3BIJR8WYJo9c10Q1k78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, wangyangbo <wangyangbo@uniontech.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0687/1039] block: check minor range in device_add_disk()
Date:   Mon, 24 Jan 2022 19:41:16 +0100
Message-Id: <20220124184148.446317970@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

[ Upstream commit e338924bd05d6e71574bc13e310c89e10e49a8a5 ]

ioctl(fd, LOOP_CTL_ADD, 1048576) causes

  sysfs: cannot create duplicate filename '/dev/block/7:0'

message because such request is treated as if ioctl(fd, LOOP_CTL_ADD, 0)
due to MINORMASK == 1048575. Verify that all minor numbers for that device
fit in the minor range.

Reported-by: wangyangbo <wangyangbo@uniontech.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/b1b19379-23ee-5379-0eb5-94bf5f79f1b4@i-love.sakura.ne.jp
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index 596e43764846b..5308e0920fa6f 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -425,6 +425,8 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 				DISK_MAX_PARTS);
 			disk->minors = DISK_MAX_PARTS;
 		}
+		if (disk->first_minor + disk->minors > MINORMASK + 1)
+			return -EINVAL;
 	} else {
 		if (WARN_ON(disk->minors))
 			return -EINVAL;
-- 
2.34.1




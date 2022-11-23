Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA1963556D
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237440AbiKWJTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237305AbiKWJTO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:19:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD5E2B25B
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:19:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CA16B81EEB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C74EC433D6;
        Wed, 23 Nov 2022 09:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195151;
        bh=N/Asc+ng/E5TIeoHflsTOYUgjf/lNvHFivHxZ5Itzlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2DhtyQARDMlG4vETYQbYTsmGvBnezBfhpKtvam/W85eB+sYq8DxEWnzI5yXTWtAUO
         xkOzb0aOxsG9aSXf4xmlZUI+5/HCZLXJVUGRjchGjcz0F7qWAh2xqlDb7hWtV9rfW4
         WExPfefqyBRD18w9V4p2+1UAK/IpT6AVTU+xkyJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot <syzbot+4dd880c1184280378821@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 132/156] Input: iforce - invert valid length check when fetching device IDs
Date:   Wed, 23 Nov 2022 09:51:29 +0100
Message-Id: <20221123084602.696467327@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit b8ebf250997c5fb253582f42bfe98673801ebebd upstream.

syzbot is reporting uninitialized value at iforce_init_device() [1], for
commit 6ac0aec6b0a6 ("Input: iforce - allow callers supply data buffer
when fetching device IDs") is checking that valid length is shorter than
bytes to read. Since iforce_get_id_packet() stores valid length when
returning 0, the caller needs to check that valid length is longer than or
equals to bytes to read.

Reported-by: syzbot <syzbot+4dd880c1184280378821@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: 6ac0aec6b0a6 ("Input: iforce - allow callers supply data buffer when fetching device IDs")
Link: https://lore.kernel.org/r/531fb432-7396-ad37-ecba-3e42e7f56d5c@I-love.SAKURA.ne.jp
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/iforce/iforce-main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/input/joystick/iforce/iforce-main.c
+++ b/drivers/input/joystick/iforce/iforce-main.c
@@ -273,22 +273,22 @@ int iforce_init_device(struct device *pa
  * Get device info.
  */
 
-	if (!iforce_get_id_packet(iforce, 'M', buf, &len) || len < 3)
+	if (!iforce_get_id_packet(iforce, 'M', buf, &len) && len >= 3)
 		input_dev->id.vendor = get_unaligned_le16(buf + 1);
 	else
 		dev_warn(&iforce->dev->dev, "Device does not respond to id packet M\n");
 
-	if (!iforce_get_id_packet(iforce, 'P', buf, &len) || len < 3)
+	if (!iforce_get_id_packet(iforce, 'P', buf, &len) && len >= 3)
 		input_dev->id.product = get_unaligned_le16(buf + 1);
 	else
 		dev_warn(&iforce->dev->dev, "Device does not respond to id packet P\n");
 
-	if (!iforce_get_id_packet(iforce, 'B', buf, &len) || len < 3)
+	if (!iforce_get_id_packet(iforce, 'B', buf, &len) && len >= 3)
 		iforce->device_memory.end = get_unaligned_le16(buf + 1);
 	else
 		dev_warn(&iforce->dev->dev, "Device does not respond to id packet B\n");
 
-	if (!iforce_get_id_packet(iforce, 'N', buf, &len) || len < 2)
+	if (!iforce_get_id_packet(iforce, 'N', buf, &len) && len >= 2)
 		ff_effects = buf[1];
 	else
 		dev_warn(&iforce->dev->dev, "Device does not respond to id packet N\n");



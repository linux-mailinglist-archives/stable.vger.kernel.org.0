Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E6865845C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235339AbiL1Q5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235290AbiL1Q4h (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:56:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE20A1DA51
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:52:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96E82B816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12143C433D2;
        Wed, 28 Dec 2022 16:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246350;
        bh=IerjXX365DYcnfR/jRen1Q0ECeyCt0UxU7/9wvV6y34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0luQvoaX9S209V5zQs453r4KNO7CREew5j2YlUJ16kqicuOHgIhCuQiLM49i5o3D/
         fCYcm7o//MEH/FZawR6Q7pI72I6iyBnnCBDQ7BGlzDyjA4yO7ar9Q0hLcp2iYZSTJr
         7Ptoeu94u2o5HoMoPpQ+J065O/ShFjKkCShwWUs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot <syzbot+25bdb7b1703639abd498@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 6.0 1054/1073] fbdev: fbcon: release buffer when fbcon_do_set_font() failed
Date:   Wed, 28 Dec 2022 15:44:02 +0100
Message-Id: <20221228144356.853980106@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

commit 3c3bfb8586f848317ceba5d777e11204ba3e5758 upstream.

syzbot is reporting memory leak at fbcon_do_set_font() [1], for
commit a5a923038d70 ("fbdev: fbcon: Properly revert changes when
vc_resize() failed") missed that the buffer might be newly allocated
by fbcon_set_font().

Link: https://syzkaller.appspot.com/bug?extid=25bdb7b1703639abd498 [1]
Reported-by: syzbot <syzbot+25bdb7b1703639abd498@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: syzbot <syzbot+25bdb7b1703639abd498@syzkaller.appspotmail.com>
Fixes: a5a923038d70 ("fbdev: fbcon: Properly revert changes when vc_resize() failed")
CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2450,7 +2450,8 @@ err_out:
 
 	if (userfont) {
 		p->userfont = old_userfont;
-		REFCOUNT(data)--;
+		if (--REFCOUNT(data) == 0)
+			kfree(data - FONT_EXTRA_WORDS * sizeof(int));
 	}
 
 	vc->vc_font.width = old_width;



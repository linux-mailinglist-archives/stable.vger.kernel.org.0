Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBD5657F67
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbiL1QEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234317AbiL1QE3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:04:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CF519027
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:04:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A31F76156E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8EE5C433EF;
        Wed, 28 Dec 2022 16:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243467;
        bh=0M/OPwvmJP+Idq8AfkXKDErqkYJNV34deQ165lkVVlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sbj2h6HyPokToy4hUFsh0cymMnVVaVVkE12bmRYL3r6291hDVggpcfIoeis5zibvc
         +c6oMctnmsIVzz7pY3JG0xwjZNYMpfm1qF+C/24GUV+Wg1FqsAPtT0BCthSuib2fRt
         hON8GSiotmVuY6qjZWMrHgpoytNWxkb25QsmwHGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot <syzbot+25bdb7b1703639abd498@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 724/731] fbdev: fbcon: release buffer when fbcon_do_set_font() failed
Date:   Wed, 28 Dec 2022 15:43:51 +0100
Message-Id: <20221228144317.431290532@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
@@ -2462,7 +2462,8 @@ err_out:
 
 	if (userfont) {
 		p->userfont = old_userfont;
-		REFCOUNT(data)--;
+		if (--REFCOUNT(data) == 0)
+			kfree(data - FONT_EXTRA_WORDS * sizeof(int));
 	}
 
 	vc->vc_font.width = old_width;



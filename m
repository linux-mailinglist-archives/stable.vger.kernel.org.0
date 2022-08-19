Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEBE9599F2F
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350198AbiHSPso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349918AbiHSPrZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:47:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5124313F64;
        Fri, 19 Aug 2022 08:47:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91917616D5;
        Fri, 19 Aug 2022 15:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966C2C433D6;
        Fri, 19 Aug 2022 15:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924027;
        bh=xiETIeoHQ+5PvRfu22IMJsts+TQDJtrJiMNFQMjmY/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jHv220vru0XZ1ZOhJIk/s6gGt9AY0CzEkBPjQGm9gnGUMYfYALoQPIFvPRtr5pgor
         ztfdY5DO7+PNMC0EHl6l+21GnKDM5nPjiJRVFAYNxRbwIwqMfiEVsq2pHOgLnkBxaS
         z7Qgi6YCMVKYq+SQiztbU9J6IsF8hGDIPSCr53JA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+31a641689d43387f05d3@syzkaller.appspotmail.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 5.10 031/545] tty: vt: initialize unicode screen buffer
Date:   Fri, 19 Aug 2022 17:36:41 +0200
Message-Id: <20220819153830.589119680@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit af77c56aa35325daa2bc2bed5c2ebf169be61b86 upstream.

syzbot reports kernel infoleak at vcs_read() [1], for buffer can be read
immediately after resize operation. Initialize buffer using kzalloc().

  ----------
  #include <fcntl.h>
  #include <unistd.h>
  #include <sys/ioctl.h>
  #include <linux/fb.h>

  int main(int argc, char *argv[])
  {
    struct fb_var_screeninfo var = { };
    const int fb_fd = open("/dev/fb0", 3);
    ioctl(fb_fd, FBIOGET_VSCREENINFO, &var);
    var.yres = 0x21;
    ioctl(fb_fd, FBIOPUT_VSCREENINFO, &var);
    return read(open("/dev/vcsu", O_RDONLY), &var, sizeof(var)) == -1;
  }
  ----------

Link: https://syzkaller.appspot.com/bug?extid=31a641689d43387f05d3 [1]
Cc: stable <stable@vger.kernel.org>
Reported-by: syzbot <syzbot+31a641689d43387f05d3@syzkaller.appspotmail.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Link: https://lore.kernel.org/r/4ef053cf-e796-fb5e-58b7-3ae58242a4ad@I-love.SAKURA.ne.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -344,7 +344,7 @@ static struct uni_screen *vc_uniscr_allo
 	/* allocate everything in one go */
 	memsize = cols * rows * sizeof(char32_t);
 	memsize += rows * sizeof(char32_t *);
-	p = vmalloc(memsize);
+	p = vzalloc(memsize);
 	if (!p)
 		return NULL;
 



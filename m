Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2605E59DED2
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353452AbiHWKRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353489AbiHWKPO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:15:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD2E72EF9;
        Tue, 23 Aug 2022 02:00:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB101B81C3E;
        Tue, 23 Aug 2022 09:00:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7D6C433C1;
        Tue, 23 Aug 2022 09:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245233;
        bh=7Jj2tH95KOIwaTxARlYh01f+IroJdOrakoNNAcv34J0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDcuwA7P/P5n2iGb8kkb6kdG7iUtXDJcueIqgNXpyhEI1uwHP3Cv2+fI+Yyyeq7gY
         3XMT8GIfO6q9uqABLkuQaaf7VjQ5FDO2wsNJg7bJ5eOB2+N75hzGe7d0LfNdqNWCPV
         aL/gYcPojc4GOfSxbvh6DlvcZDZ46VI7rdJq5Tlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+31a641689d43387f05d3@syzkaller.appspotmail.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 4.19 014/287] tty: vt: initialize unicode screen buffer
Date:   Tue, 23 Aug 2022 10:23:03 +0200
Message-Id: <20220823080100.754328246@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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
@@ -351,7 +351,7 @@ static struct uni_screen *vc_uniscr_allo
 	/* allocate everything in one go */
 	memsize = cols * rows * sizeof(char32_t);
 	memsize += rows * sizeof(char32_t *);
-	p = vmalloc(memsize);
+	p = vzalloc(memsize);
 	if (!p)
 		return NULL;
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3636354CE
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237150AbiKWJJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:09:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237105AbiKWJJk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:09:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8303A19026
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:09:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D3A361B14
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D71C433D6;
        Wed, 23 Nov 2022 09:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194578;
        bh=Evs66yjHslM39+nI5Y1DpjlTKYID5kPPfKRBFM/MeIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VNtSRBIhWqFO9QbUsQlnfZPaGhN2Hm3RnAaa525dVOE5NzLCNUicCuQUAebTVrihV
         /6tmNBUcXbTmrPK9pyA5v51titfkRfvxo1kjQTWruWga9LxU6Q2vLeFxRArIF2IjSf
         7gOrg5uZ4LEwuwRswTl9C5qFSRdG7j14iB9iezU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot <syzbot+8b41a1365f1106fd0f33@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 4.19 110/114] 9p/trans_fd: always use O_NONBLOCK read/write
Date:   Wed, 23 Nov 2022 09:51:37 +0100
Message-Id: <20221123084556.070626002@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
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

commit ef575281b21e9a34dfae544a187c6aac2ae424a9 upstream.

syzbot is reporting hung task at p9_fd_close() [1], for p9_mux_poll_stop()
 from p9_conn_destroy() from p9_fd_close() is failing to interrupt already
started kernel_read() from p9_fd_read() from p9_read_work() and/or
kernel_write() from p9_fd_write() from p9_write_work() requests.

Since p9_socket_open() sets O_NONBLOCK flag, p9_mux_poll_stop() does not
need to interrupt kernel_read()/kernel_write(). However, since p9_fd_open()
does not set O_NONBLOCK flag, but pipe blocks unless signal is pending,
p9_mux_poll_stop() needs to interrupt kernel_read()/kernel_write() when
the file descriptor refers to a pipe. In other words, pipe file descriptor
needs to be handled as if socket file descriptor.

We somehow need to interrupt kernel_read()/kernel_write() on pipes.

A minimal change, which this patch is doing, is to set O_NONBLOCK flag
 from p9_fd_open(), for O_NONBLOCK flag does not affect reading/writing
of regular files. But this approach changes O_NONBLOCK flag on userspace-
supplied file descriptors (which might break userspace programs), and
O_NONBLOCK flag could be changed by userspace. It would be possible to set
O_NONBLOCK flag every time p9_fd_read()/p9_fd_write() is invoked, but still
remains small race window for clearing O_NONBLOCK flag.

If we don't want to manipulate O_NONBLOCK flag, we might be able to
surround kernel_read()/kernel_write() with set_thread_flag(TIF_SIGPENDING)
and recalc_sigpending(). Since p9_read_work()/p9_write_work() works are
processed by kernel threads which process global system_wq workqueue,
signals could not be delivered from remote threads when p9_mux_poll_stop()
 from p9_conn_destroy() from p9_fd_close() is called. Therefore, calling
set_thread_flag(TIF_SIGPENDING)/recalc_sigpending() every time would be
needed if we count on signals for making kernel_read()/kernel_write()
non-blocking.

Link: https://lkml.kernel.org/r/345de429-a88b-7097-d177-adecf9fed342@I-love.SAKURA.ne.jp
Link: https://syzkaller.appspot.com/bug?extid=8b41a1365f1106fd0f33 [1]
Reported-by: syzbot <syzbot+8b41a1365f1106fd0f33@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: syzbot <syzbot+8b41a1365f1106fd0f33@syzkaller.appspotmail.com>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
[Dominique: add comment at Christian's suggestion]
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/9p/trans_fd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -836,11 +836,14 @@ static int p9_fd_open(struct p9_client *
 		goto out_free_ts;
 	if (!(ts->rd->f_mode & FMODE_READ))
 		goto out_put_rd;
+	/* prevent workers from hanging on IO when fd is a pipe */
+	ts->rd->f_flags |= O_NONBLOCK;
 	ts->wr = fget(wfd);
 	if (!ts->wr)
 		goto out_put_rd;
 	if (!(ts->wr->f_mode & FMODE_WRITE))
 		goto out_put_wr;
+	ts->wr->f_flags |= O_NONBLOCK;
 
 	client->trans = ts;
 	client->status = Connected;



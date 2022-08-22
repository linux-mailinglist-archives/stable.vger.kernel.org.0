Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B30F59BB8A
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 10:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233974AbiHVIYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 04:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233979AbiHVIY0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 04:24:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4FB1EEE7
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 01:23:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 711046102F
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 08:23:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75994C433D6;
        Mon, 22 Aug 2022 08:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661156632;
        bh=JE722GOfTdwT8v3BCyblGWBdUf650mS3SaPR4YeoNIM=;
        h=Subject:To:Cc:From:Date:From;
        b=k21mhVyrbqUPesUDedv9jEDdR43XH9yZowiB43tbsjRyzOTnuhvd5N3W/SBqSeP13
         flnSdXlLbm7YqH+4l9eClexiFBErJohP3tkK2P4jAeIRYoDg1+qAcgOpODgFjJjkXl
         nR7mfP1i1lhbTkVLLbV+fOCAD9KFSkqXOvEDMcE4=
Subject: FAILED: patch "[PATCH] selftests: mptcp: make sendfile selftest work" failed to apply to 5.10-stable tree
To:     fw@strlen.de, davem@davemloft.net,
        mathew.j.martineau@linux.intel.com, xmu@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 10:23:42 +0200
Message-ID: <16611566225860@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From df9e03aec3b14970df05b72d54f8ac9da3ab29e1 Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Thu, 4 Aug 2022 17:21:27 -0700
Subject: [PATCH] selftests: mptcp: make sendfile selftest work

When the selftest got added, sendfile() on mptcp sockets returned
-EOPNOTSUPP, so running 'mptcp_connect.sh -m sendfile' failed
immediately.

This is no longer the case, but the script fails anyway due to timeout.
Let the receiver know once the sender has sent all data, just like
with '-m mmap' mode.

v2: need to respect cfg_wait too, as pm_userspace.sh relied
on -m sendfile to keep the connection open (Mat Martineau)

Fixes: 048d19d444be ("mptcp: add basic kselftest for mptcp")
Reported-by: Xiumei Mu <xmu@redhat.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
index e2ea6c126c99..24d4e9cb617e 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -553,6 +553,18 @@ static void set_nonblock(int fd, bool nonblock)
 		fcntl(fd, F_SETFL, flags & ~O_NONBLOCK);
 }
 
+static void shut_wr(int fd)
+{
+	/* Close our write side, ev. give some time
+	 * for address notification and/or checking
+	 * the current status
+	 */
+	if (cfg_wait)
+		usleep(cfg_wait);
+
+	shutdown(fd, SHUT_WR);
+}
+
 static int copyfd_io_poll(int infd, int peerfd, int outfd, bool *in_closed_after_out)
 {
 	struct pollfd fds = {
@@ -630,14 +642,7 @@ static int copyfd_io_poll(int infd, int peerfd, int outfd, bool *in_closed_after
 					/* ... and peer also closed already */
 					break;
 
-				/* ... but we still receive.
-				 * Close our write side, ev. give some time
-				 * for address notification and/or checking
-				 * the current status
-				 */
-				if (cfg_wait)
-					usleep(cfg_wait);
-				shutdown(peerfd, SHUT_WR);
+				shut_wr(peerfd);
 			} else {
 				if (errno == EINTR)
 					continue;
@@ -767,7 +772,7 @@ static int copyfd_io_mmap(int infd, int peerfd, int outfd,
 		if (err)
 			return err;
 
-		shutdown(peerfd, SHUT_WR);
+		shut_wr(peerfd);
 
 		err = do_recvfile(peerfd, outfd);
 		*in_closed_after_out = true;
@@ -791,6 +796,9 @@ static int copyfd_io_sendfile(int infd, int peerfd, int outfd,
 		err = do_sendfile(infd, peerfd, size);
 		if (err)
 			return err;
+
+		shut_wr(peerfd);
+
 		err = do_recvfile(peerfd, outfd);
 		*in_closed_after_out = true;
 	}


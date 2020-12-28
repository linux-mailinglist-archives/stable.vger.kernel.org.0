Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150942E403F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391871AbgL1OTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:19:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:54352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389652AbgL1OTp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:19:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 244872242A;
        Mon, 28 Dec 2020 14:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165169;
        bh=kZ1mYGXt4f9WR07xBZZ6MIxoL8Gmdi84ljdP2tHSCQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P2aYRs5HxNtXVDwGukwRUh+BC32aLF0P47JSUXzuxI2WmTCT55M0taNCm86w+Ksph
         kmhXCveLj2U2GPf4kW5tXYj45IMYJYiGCwQRHPGotQbS4NJKrK3Su0mj1KftlYT044
         gj0Q3PBMDcksVyCQ4u6EVn5FzLXyKJuZyYrL2Y0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 436/717] um: chan_xterm: Fix fd leak
Date:   Mon, 28 Dec 2020 13:47:14 +0100
Message-Id: <20201228125041.861027871@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anton Ivanov <anton.ivanov@cambridgegreys.com>

[ Upstream commit 9431f7c199ab0d02da1482d62255e0b4621cb1b5 ]

xterm serial channel was leaking a fd used in setting up the
port helper

This bug is prehistoric - it predates switching to git. The "fixes"
header here is really just to mark all the versions we would like this to
apply to which is "Anything from the Cretaceous period onwards".

No dinosaurs were harmed in fixing this bug.

Fixes: b40997b872cd ("um: drivers/xterm.c: fix a file descriptor leak")
Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/xterm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/um/drivers/xterm.c b/arch/um/drivers/xterm.c
index fc7f1e7467032..87ca4a47cd66e 100644
--- a/arch/um/drivers/xterm.c
+++ b/arch/um/drivers/xterm.c
@@ -18,6 +18,7 @@
 struct xterm_chan {
 	int pid;
 	int helper_pid;
+	int chan_fd;
 	char *title;
 	int device;
 	int raw;
@@ -33,6 +34,7 @@ static void *xterm_init(char *str, int device, const struct chan_opts *opts)
 		return NULL;
 	*data = ((struct xterm_chan) { .pid 		= -1,
 				       .helper_pid 	= -1,
+				       .chan_fd		= -1,
 				       .device 		= device,
 				       .title 		= opts->xterm_title,
 				       .raw  		= opts->raw } );
@@ -149,6 +151,7 @@ static int xterm_open(int input, int output, int primary, void *d,
 		goto out_kill;
 	}
 
+	data->chan_fd = fd;
 	new = xterm_fd(fd, &data->helper_pid);
 	if (new < 0) {
 		err = new;
@@ -206,6 +209,8 @@ static void xterm_close(int fd, void *d)
 		os_kill_process(data->helper_pid, 0);
 	data->helper_pid = -1;
 
+	if (data->chan_fd != -1)
+		os_close_file(data->chan_fd);
 	os_close_file(fd);
 }
 
-- 
2.27.0




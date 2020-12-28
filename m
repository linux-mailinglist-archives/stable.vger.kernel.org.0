Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13DA2E4338
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408294AbgL1PeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:34:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:52086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406366AbgL1Num (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:50:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0F3A20738;
        Mon, 28 Dec 2020 13:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163427;
        bh=kZ1mYGXt4f9WR07xBZZ6MIxoL8Gmdi84ljdP2tHSCQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MUzaMTtvbomRQAF13ePW2GH0WaWCoCmqyldHyHgfsF1mqFj5wyJjIQRlyIWda0hay
         bFgXDg5GbWmB33WETM8puPwLU7DhyC0c+rrEKB2s/wSzqPMDxzq1AlyoLC6UCNv7c8
         tr2ndCWpWY5ikNrYmY4ieCBhi1ce5PK3Aw2aUSWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 283/453] um: chan_xterm: Fix fd leak
Date:   Mon, 28 Dec 2020 13:48:39 +0100
Message-Id: <20201228124950.829312151@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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




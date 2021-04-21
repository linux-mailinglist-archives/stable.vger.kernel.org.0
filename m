Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A1F366BDE
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 15:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241298AbhDUNIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 09:08:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240139AbhDUNHC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Apr 2021 09:07:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55C6561457;
        Wed, 21 Apr 2021 13:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619010388;
        bh=JohFeQwR6jXzApbZjK7P2q6uFpDFGfiGCYI+5rIdurw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FnXYLLpPZTowsQEu3H2ZvxmvHSgkKaPUiOmIR2uznkcT/3cHSyVDhBV3HEOigVwDB
         1Oa6Hh4aacYxef9vUlWp8W+7RneC2zmGLnsj+FOoSf87uQk1n3xhbe7V2VYLQ/GJsV
         ciacU7mW32zLoRCnjjtghKoFj1YfVxI9Y1jD4QSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, stable <stable@vger.kernel.org>
Subject: [PATCH 119/190] Revert "tty: mxs-auart: fix a potential NULL pointer dereference"
Date:   Wed, 21 Apr 2021 14:59:54 +0200
Message-Id: <20210421130105.1226686-120-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 6734330654dac550f12e932996b868c6d0dcb421.

Commits from @umn.edu addresses have been found to be submitted in "bad
faith" to try to test the kernel community's ability to review "known
malicious" changes.  The result of these submissions can be found in a
paper published at the 42nd IEEE Symposium on Security and Privacy
entitled, "Open Source Insecurity: Stealthily Introducing
Vulnerabilities via Hypocrite Commits" written by Qiushi Wu (University
of Minnesota) and Kangjie Lu (University of Minnesota).

Because of this, all submissions from this group must be reverted from
the kernel tree and will need to be re-reviewed again to determine if
they actually are a valid fix.  Until that work is complete, remove this
change to ensure that no problems are being introduced into the
codebase.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: stable <stable@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/mxs-auart.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
index f414d6acad69..edad6ebbdfd5 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -1644,10 +1644,6 @@ static int mxs_auart_probe(struct platform_device *pdev)
 
 	s->port.mapbase = r->start;
 	s->port.membase = ioremap(r->start, resource_size(r));
-	if (!s->port.membase) {
-		ret = -ENOMEM;
-		goto out_disable_clks;
-	}
 	s->port.ops = &mxs_auart_ops;
 	s->port.iotype = UPIO_MEM;
 	s->port.fifosize = MXS_AUART_FIFO_SIZE;
-- 
2.31.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA0E366BE4
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 15:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241361AbhDUNIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 09:08:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240772AbhDUNHI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Apr 2021 09:07:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE36961440;
        Wed, 21 Apr 2021 13:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619010394;
        bh=V8cl84AGiB+lKu2uhDRDqIV9Oc8ljKG6mDuqEQcyutA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ggTp6AISyYgRykBV8V2ctRKZeUWittQJSlJN1zLM871TqY3ZJ83rzfIPPMOgHPrKn
         J9PQCeUUTvI0G7ghD0ZO1TbSzZIlVEOEcYaOrsb5CVKywBqNfv6VzMhbE763ALCs0G
         nuA9qJ4qS6p1Z8GoMjxP42DE1id1P8UQT//dhK+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aditya Pakki <pakki001@umn.edu>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 121/190] Revert "serial: mvebu-uart: Fix to avoid a potential NULL pointer dereference"
Date:   Wed, 21 Apr 2021 14:59:56 +0200
Message-Id: <20210421130105.1226686-122-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 32f47179833b63de72427131169809065db6745e.

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

Cc: Aditya Pakki <pakki001@umn.edu>
Cc: stable <stable@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/mvebu-uart.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/tty/serial/mvebu-uart.c b/drivers/tty/serial/mvebu-uart.c
index e0c00a1b0763..51b0ecabf2ec 100644
--- a/drivers/tty/serial/mvebu-uart.c
+++ b/drivers/tty/serial/mvebu-uart.c
@@ -818,9 +818,6 @@ static int mvebu_uart_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	if (!match)
-		return -ENODEV;
-
 	/* Assume that all UART ports have a DT alias or none has */
 	id = of_alias_get_id(pdev->dev.of_node, "serial");
 	if (!pdev->dev.of_node || id < 0)
-- 
2.31.1


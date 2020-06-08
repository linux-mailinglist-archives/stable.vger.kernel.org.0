Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13EB1F2D2E
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730057AbgFIAbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:31:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730077AbgFHXPi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B48FF2068D;
        Mon,  8 Jun 2020 23:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658138;
        bh=t8vOL3Aq72gto865Kj5owwFGecqLiL7Bqf7dMNF16rI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=msnsXpxrIpeRsIg5xTgfVw+Yb9SipGD4mqBbz5NceKy/AerLP/MdsnMzXqwOosPNO
         L4TOi4km4lBV0EBIZZ4ZArxN0gvB9Jd6JEGk5O5r8t2kSEWx21OumH9usSCliUDI2b
         DszYjfI4d6xMQ+GhzGx7/k1/ORG1dle8T7bYWtRc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oscar Carter <oscar.carter@gmx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        greybus-dev@lists.linaro.org, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.6 172/606] staging: greybus: Fix uninitialized scalar variable
Date:   Mon,  8 Jun 2020 19:04:57 -0400
Message-Id: <20200608231211.3363633-172-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oscar Carter <oscar.carter@gmx.com>

commit 34625c1931f8204c234c532b446b9f53c69f4b68 upstream.

In the "gb_tty_set_termios" function the "newline" variable is declared
but not initialized. So the "flow_control" member is not initialized and
the OR / AND operations with itself results in an undefined value in
this member.

The purpose of the code is to set the flow control type, so remove the
OR / AND self operator and set the value directly.

Addresses-Coverity-ID: 1374016 ("Uninitialized scalar variable")
Fixes: e55c25206d5c9 ("greybus: uart: Handle CRTSCTS flag in termios")
Signed-off-by: Oscar Carter <oscar.carter@gmx.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200510101426.23631-1-oscar.carter@gmx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/greybus/uart.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/greybus/uart.c b/drivers/staging/greybus/uart.c
index 55c51143bb09..4ffb334cd5cd 100644
--- a/drivers/staging/greybus/uart.c
+++ b/drivers/staging/greybus/uart.c
@@ -537,9 +537,9 @@ static void gb_tty_set_termios(struct tty_struct *tty,
 	}
 
 	if (C_CRTSCTS(tty) && C_BAUD(tty) != B0)
-		newline.flow_control |= GB_SERIAL_AUTO_RTSCTS_EN;
+		newline.flow_control = GB_SERIAL_AUTO_RTSCTS_EN;
 	else
-		newline.flow_control &= ~GB_SERIAL_AUTO_RTSCTS_EN;
+		newline.flow_control = 0;
 
 	if (memcmp(&gb_tty->line_coding, &newline, sizeof(newline))) {
 		memcpy(&gb_tty->line_coding, &newline, sizeof(newline));
-- 
2.25.1


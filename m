Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42887420DD0
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236229AbhJDNTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:19:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236151AbhJDNRz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:17:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C70E61409;
        Mon,  4 Oct 2021 13:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352837;
        bh=jcRBK8EomAPjn5aI+Arc7e/MeSBMdj8wu2+Bk1uCW4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PDmMCWbudmc9WDI5nYdoSmtLQQ1SJLr2UC0bOtpk3Kjvm1VM0FiH7sPkCn2b3fsr1
         k9dj9NBePwIq9gPt1pX4G9tRHhac8BUiAOd/E1yC0kAYQTq5thtD29S1rhSrUlGRQx
         uMqYLPdcfWltrwsEBlmZ3NpnPvNWiryRZrSwHyZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrej Shadura <andrew.shadura@collabora.co.uk>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.4 44/56] HID: u2fzero: ignore incomplete packets without data
Date:   Mon,  4 Oct 2021 14:53:04 +0200
Message-Id: <20211004125031.394431314@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125030.002116402@linuxfoundation.org>
References: <20211004125030.002116402@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrej Shadura <andrew.shadura@collabora.co.uk>

commit 22d65765f211cc83186fd8b87521159f354c0da9 upstream.

Since the actual_length calculation is performed unsigned, packets
shorter than 7 bytes (e.g. packets without data or otherwise truncated)
or non-received packets ("zero" bytes) can cause buffer overflow.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=214437
Fixes: 42337b9d4d958("HID: add driver for U2F Zero built-in LED and RNG")
Signed-off-by: Andrej Shadura <andrew.shadura@collabora.co.uk>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-u2fzero.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-u2fzero.c
+++ b/drivers/hid/hid-u2fzero.c
@@ -198,7 +198,9 @@ static int u2fzero_rng_read(struct hwrng
 	}
 
 	ret = u2fzero_recv(dev, &req, &resp);
-	if (ret < 0)
+
+	/* ignore errors or packets without data */
+	if (ret < offsetof(struct u2f_hid_msg, init.data))
 		return 0;
 
 	/* only take the minimum amount of data it is safe to take */



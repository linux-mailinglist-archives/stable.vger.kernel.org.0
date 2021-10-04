Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A2D421049
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238433AbhJDNmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:42:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238431AbhJDNk0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:40:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5EA461A58;
        Mon,  4 Oct 2021 13:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353519;
        bh=jcRBK8EomAPjn5aI+Arc7e/MeSBMdj8wu2+Bk1uCW4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tnqQXafshT+uFu0tf/16mpEd+ZvZw2a9fOb1K72jWXNM805wRqAQQbBZqFMQsqRtN
         dS92fz1LBjGii2tQ+cWBprUPINXWzEHAM2HpDUg2iqeauKUMEH4HCTxIjCOnSRjvUF
         +w5z88B8QWQt0UYK1/uG6+xI9WtDaOt3Gu0DNuJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrej Shadura <andrew.shadura@collabora.co.uk>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.14 159/172] HID: u2fzero: ignore incomplete packets without data
Date:   Mon,  4 Oct 2021 14:53:29 +0200
Message-Id: <20211004125050.101297885@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
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



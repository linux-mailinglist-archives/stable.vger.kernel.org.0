Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F65B29AECB
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754078AbgJ0OEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:04:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439370AbgJ0OEC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:04:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 212412222C;
        Tue, 27 Oct 2020 14:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807441;
        bh=uAs3Ht4Ek8SYorqswv2DW7G4JynwCwldIaT1HrkNS5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nfv1ImPketOj1KgYE/HbKvXFnnH8WGYGyBy5rU4JtxLcBkVh8RPZWhCOZdEHVpCjA
         xoM15Z/dWAi6FXfyCyZjJREICG7RtpP5sh7UWoEGRyWRtodPoTLmebL0j8j4D8Y4VM
         QbMn31gARSun16NVOQQqOa9n/H309TCeVr+67tuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 054/139] mwifiex: fix double free
Date:   Tue, 27 Oct 2020 14:49:08 +0100
Message-Id: <20201027134904.693141841@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134902.130312227@linuxfoundation.org>
References: <20201027134902.130312227@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 53708f4fd9cfe389beab5c8daa763bcd0e0b4aef ]

clang static analysis reports this problem:

sdio.c:2403:3: warning: Attempt to free released memory
        kfree(card->mpa_rx.buf);
        ^~~~~~~~~~~~~~~~~~~~~~~

When mwifiex_init_sdio() fails in its first call to
mwifiex_alloc_sdio_mpa_buffer, it falls back to calling it
again.  If the second alloc of mpa_tx.buf fails, the error
handler will try to free the old, previously freed mpa_rx.buf.
Reviewing the code, it looks like a second double free would
happen with mwifiex_cleanup_sdio().

So set both pointers to NULL when they are freed.

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201004131931.29782-1-trix@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 486b8c75cd1f9..679cc0035514e 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -2049,6 +2049,8 @@ static int mwifiex_alloc_sdio_mpa_buffers(struct mwifiex_adapter *adapter,
 		kfree(card->mpa_rx.buf);
 		card->mpa_tx.buf_size = 0;
 		card->mpa_rx.buf_size = 0;
+		card->mpa_tx.buf = NULL;
+		card->mpa_rx.buf = NULL;
 	}
 
 	return ret;
-- 
2.25.1




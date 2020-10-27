Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7D629C4AF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901281AbgJ0R4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:56:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758616AbgJ0OV7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:21:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FBBC206F7;
        Tue, 27 Oct 2020 14:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808519;
        bh=uVlj2QS4ZmYStc0bNFiuZVa0mCI5AwUF7VFU9+emLAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LG1jZEZm5wTYStjzAP0rygS8zyxQI4YMirfmLZ/ifoqCO2LOon63rImGsxRhc4jMr
         u/zBzj+ADdzssKjMJaKpxUNOBIv3HZcZMjIdowcqjYjL3232lP0j1JE/9VWazNrUTG
         UHATklycDFfFOybaaW63mhlr9f7NyA+HwiCArV5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 123/264] mwifiex: fix double free
Date:   Tue, 27 Oct 2020 14:53:01 +0100
Message-Id: <20201027135436.466209712@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
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
index bfbe3aa058d93..0773d81072aa1 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -1985,6 +1985,8 @@ static int mwifiex_alloc_sdio_mpa_buffers(struct mwifiex_adapter *adapter,
 		kfree(card->mpa_rx.buf);
 		card->mpa_tx.buf_size = 0;
 		card->mpa_rx.buf_size = 0;
+		card->mpa_tx.buf = NULL;
+		card->mpa_rx.buf = NULL;
 	}
 
 	return ret;
-- 
2.25.1




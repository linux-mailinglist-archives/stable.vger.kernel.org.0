Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2C13A62B7
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbhFNLDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:03:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234378AbhFNLBk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:01:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 003C461864;
        Mon, 14 Jun 2021 10:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667411;
        bh=YV5/Yb7PaY3u2uKpCLqzCY3uL8Md7KaRVh0jHHSiMRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1SLH8iNX/5D6Dt1L7Dd5ZxeXAIc2trZCyiKv5eEdj6pci5WfDVPC0qha1SB51l383
         zpBKrCNdtWUz6A7EUCblHi5uzsIB+xrUARdThlJTvBPpUyoDtjqP17emzwt3qGkvVc
         xfQ5LpxfQW+LjuhMwckcbC1xVJ4zSrxPIQeq9E3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>,
        Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>,
        Xiao Ni <xni@redhat.com>, Song Liu <song@kernel.org>
Subject: [PATCH 5.10 060/131] async_xor: check src_offs is not NULL before updating it
Date:   Mon, 14 Jun 2021 12:27:01 +0200
Message-Id: <20210614102655.053157239@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiao Ni <xni@redhat.com>

commit 9be148e408df7d361ec5afd6299b7736ff3928b0 upstream.

When PAGE_SIZE is greater than 4kB, multiple stripes may share the same
page. Thus, src_offs is added to async_xor_offs() with array of offsets.
However, async_xor() passes NULL src_offs to async_xor_offs(). In such
case, src_offs should not be updated. Add a check before the update.

Fixes: ceaf2966ab08(async_xor: increase src_offs when dropping destination page)
Cc: stable@vger.kernel.org # v5.10+
Reported-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>
Tested-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/async_tx/async_xor.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -233,7 +233,8 @@ async_xor_offs(struct page *dest, unsign
 		if (submit->flags & ASYNC_TX_XOR_DROP_DST) {
 			src_cnt--;
 			src_list++;
-			src_offs++;
+			if (src_offs)
+				src_offs++;
 		}
 
 		/* wait for any prerequisite operations */



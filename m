Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F52145C626
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351354AbhKXOFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:05:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:48818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353828AbhKXOCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:02:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4541E61A7D;
        Wed, 24 Nov 2021 13:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759422;
        bh=4Ddr2Pg8ko9IRGiSEa7LXYq3vtOzD2i+EY9k/d1xxbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OZV+GCvrN/OjMss0Ok9Fnz3PPyTUyCpxS2/91q1DXaZ+VfJsEwbfLz0S8NlreYFFN
         ynlz8zzjj6sCY3cbWHGgDB1IIkeH5kRiAjr6ec/VfTiO/rffJSpEheCNCzzjbP/zHM
         Qqlhp5b8l1Vd3FCaDwysdCR01HHAZCISqT/D+HNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sid Hayn <sidhayn@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.15 237/279] mac80211: fix radiotap header generation
Date:   Wed, 24 Nov 2021 12:58:44 +0100
Message-Id: <20211124115726.928675328@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit c033a38a81bc539d6c0db8c5387e0b14d819a0cf upstream.

In commit 8c89f7b3d3f2 ("mac80211: Use flex-array for radiotap header
bitmap") we accidentally pointed the position to the wrong place, so
we overwrite a present bitmap, and thus cause all kinds of trouble.

To see the issue, note that the previous code read:

  pos = (void *)(it_present + 1);

The requirement now is that we need to calculate pos via it_optional,
to not trigger the compiler hardening checks, as:

  pos = (void *)&rthdr->it_optional[...];

Rewriting the original expression, we get (obviously, since that just
adds "+ x - x" terms):

  pos = (void *)(it_present + 1 + rthdr->it_optional - rthdr->it_optional)

and moving the "+ rthdr->it_optional" outside to be used as an array:

  pos = (void *)&rthdr->it_optional[it_present + 1 - rthdr->it_optional];

The original is off by one, fix it.

Cc: stable@vger.kernel.org
Fixes: 8c89f7b3d3f2 ("mac80211: Use flex-array for radiotap header bitmap")
Reported-by: Sid Hayn <sidhayn@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Tested-by: Sid Hayn <sidhayn@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20211109100203.c61007433ed6.I1dade57aba7de9c4f48d68249adbae62636fd98c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -364,7 +364,7 @@ ieee80211_add_rx_radiotap_header(struct
 	 * the compiler to think we have walked past the end of the
 	 * struct member.
 	 */
-	pos = (void *)&rthdr->it_optional[it_present - rthdr->it_optional];
+	pos = (void *)&rthdr->it_optional[it_present + 1 - rthdr->it_optional];
 
 	/* the order of the following fields is important */
 



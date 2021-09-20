Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32545412530
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349277AbhITSmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:42:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382301AbhITSkR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:40:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8664C63331;
        Mon, 20 Sep 2021 17:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159064;
        bh=aU5jjJkB3VmCgVUlzT1/mI1oGjuuEmcURWIZ7K3uIXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YMSXFpJCFUtIsI8/2tMDZdWO8ODqISSpU9YOdEYZeovecwpOSS7CsjDVGoJVX9Fv0
         Ed9W2WB/mFLMUNti0PnJmgB/IGu1NKTjU5zwrqOExp0FLKL4xfsKZiRhCbWnnFYOZf
         vz/u14aQjSXbFDfhZg/M3r7gHKM2XudLPJeVONEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 058/168] net: ipa: initialize all filter table slots
Date:   Mon, 20 Sep 2021 18:43:16 +0200
Message-Id: <20210920163923.548389478@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

commit b5c102238cea985d8126b173d06b9e1de88037ee upstream.

There is an off-by-one problem in ipa_table_init_add(), when
initializing filter tables.

In that function, the number of filter table entries is determined
based on the number of set bits in the filter map.  However that
count does *not* include the extra "slot" in the filter table that
holds the filter map itself.  Meanwhile, ipa_table_addr() *does*
include the filter map in the memory it returns, but because the
count it's provided doesn't include it, it includes one too few
table entries.

Fix this by including the extra slot for the filter map in the count
computed in ipa_table_init_add().

Note: ipa_filter_reset_table() does not have this problem; it resets
filter table entries one by one, but does not overwrite the filter
bitmap.

Fixes: 2b9feef2b6c2 ("soc: qcom: ipa: filter and routing tables")
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ipa/ipa_table.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -430,7 +430,8 @@ static void ipa_table_init_add(struct gs
 	 * table region determines the number of entries it has.
 	 */
 	if (filter) {
-		count = hweight32(ipa->filter_map);
+		/* Include one extra "slot" to hold the filter map itself */
+		count = 1 + hweight32(ipa->filter_map);
 		hash_count = hash_mem->size ? count : 0;
 	} else {
 		count = mem->size / sizeof(__le64);



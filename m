Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7465C4123ED
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348660AbhITS2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:28:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378765AbhITS0W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:26:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB8DB6126A;
        Mon, 20 Sep 2021 17:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158743;
        bh=T6bfA4lJXrzJMqxed6cF3AHuqdBRgfj7i1mn/NlkoqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FCpB672a7YyyitjttkBem9uvfSCAmYDHK2JohTODJFYia858+XeMcCPy/6jYKu1Vh
         Cw8TuQbBqp4Bg2MPBIfi6gJ/VLtHpqu1/DDJWOk4vv3fkg880o1FE8eXPVoJKIFciy
         8mGUjroBav2tXItX6goMUKY3gqWHNEUhaDY6bBc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 036/122] net: ipa: initialize all filter table slots
Date:   Mon, 20 Sep 2021 18:43:28 +0200
Message-Id: <20210920163916.975682498@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
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
@@ -451,7 +451,8 @@ static void ipa_table_init_add(struct gs
 	 * table region determines the number of entries it has.
 	 */
 	if (filter) {
-		count = hweight32(ipa->filter_map);
+		/* Include one extra "slot" to hold the filter map itself */
+		count = 1 + hweight32(ipa->filter_map);
 		hash_count = hash_mem->size ? count : 0;
 	} else {
 		count = mem->size / IPA_TABLE_ENTRY_SIZE;



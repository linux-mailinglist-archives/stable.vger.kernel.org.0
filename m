Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8636B49A318
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2364869AbiAXXtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:49:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47494 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455232AbiAXVfD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:35:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55991B8105C;
        Mon, 24 Jan 2022 21:34:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E888C340E4;
        Mon, 24 Jan 2022 21:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060098;
        bh=C1j676FUP8iWuGVMyB82H13nsJjOvitU5NC+K+waxcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/2Xr4gJqLYRpWTah8xtQIR0nqDKldX6fyJKow1kK2XmArf7Zj8fGx/UKOHvzMx7u
         zdqwG/9ciH6zgot3gbs/9bHpegkFLQab65YIA012cdPFBa2sq5ATdXA2Ux9BK5/PEH
         D+VmhkKecnnr+GAsFMIUx+YL0NhyMapFv6r1qyDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Nicolas Pitre <npitre@baylibre.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0795/1039] i3c/master/mipi-i3c-hci: Fix a potentially infinite loop in hci_dat_v1_get_index()
Date:   Mon, 24 Jan 2022 19:43:04 +0100
Message-Id: <20220124184152.025168739@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 3f43926f271287fb1744c9ac9ae1122497f2b0c2 ]

The code in 'hci_dat_v1_get_index()' really looks like a hand coded version
of 'for_each_set_bit()', except that a +1 is missing when searching for the
next set bit.

This really looks odd and it seems that it will loop until 'dat_w0_read()'
returns the expected result.

So use 'for_each_set_bit()' instead. It is less verbose and should be more
correct.

Fixes: 9ad9a52cce28 ("i3c/master: introduce the mipi-i3c-hci driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Nicolas Pitre <npitre@baylibre.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/0cdf3cb10293ead1acd271fdb8a70369c298c082.1637186628.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/dat_v1.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/dat_v1.c b/drivers/i3c/master/mipi-i3c-hci/dat_v1.c
index 783e551a2c85a..97bb49ff5b53b 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dat_v1.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dat_v1.c
@@ -160,9 +160,7 @@ static int hci_dat_v1_get_index(struct i3c_hci *hci, u8 dev_addr)
 	unsigned int dat_idx;
 	u32 dat_w0;
 
-	for (dat_idx = find_first_bit(hci->DAT_data, hci->DAT_entries);
-	     dat_idx < hci->DAT_entries;
-	     dat_idx = find_next_bit(hci->DAT_data, hci->DAT_entries, dat_idx)) {
+	for_each_set_bit(dat_idx, hci->DAT_data, hci->DAT_entries) {
 		dat_w0 = dat_w0_read(dat_idx);
 		if (FIELD_GET(DAT_0_DYNAMIC_ADDRESS, dat_w0) == dev_addr)
 			return dat_idx;
-- 
2.34.1




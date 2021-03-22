Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95D83442AB
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbhCVMoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:44:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232409AbhCVMmc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:42:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDDF6619B8;
        Mon, 22 Mar 2021 12:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416807;
        bh=FKq6rZ2Ke0ICL1Ru4IhqBy/idzzVBl+D9H6u8T9JoC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cqkWztkjqDUhEoJEPcz5MyGRf9WQ6tKDINIAOH9qSeSgfrCzMKKsdQyqN80McJtDk
         1USlq+ipNL47EoZaIvr9H5uMAOPZjclnVvdibizX6pPHzboly0Z5pXabuTNUKRvMPR
         RovTiWw0IW8I6Zm8yoBWxkQ4Jd1/eddsR54i3aKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 129/157] iio: adc: ab8500-gpadc: Fix off by 10 to 3
Date:   Mon, 22 Mar 2021 13:28:06 +0100
Message-Id: <20210322121937.846954561@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit 4f5434086d9223f20b3128a7dc78b35271e76655 upstream.

Fix an off by three orders of magnitude error in the AB8500
GPADC driver. Luckily it showed up quite quickly when trying
to make use of it. The processed reads were returning
microvolts, microamperes and microcelsius instead of millivolts,
milliamperes and millicelsius as advertised.

Cc: stable@vger.kernel.org
Fixes: 07063bbfa98e ("iio: adc: New driver for the AB8500 GPADC")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20201224011700.1059659-1-linus.walleij@linaro.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ab8500-gpadc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ab8500-gpadc.c
+++ b/drivers/iio/adc/ab8500-gpadc.c
@@ -918,7 +918,7 @@ static int ab8500_gpadc_read_raw(struct
 			return processed;
 
 		/* Return millivolt or milliamps or millicentigrades */
-		*val = processed * 1000;
+		*val = processed;
 		return IIO_VAL_INT;
 	}
 



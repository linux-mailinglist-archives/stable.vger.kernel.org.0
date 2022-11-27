Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9F69639B3E
	for <lists+stable@lfdr.de>; Sun, 27 Nov 2022 15:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiK0OIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Nov 2022 09:08:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiK0OIe (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 27 Nov 2022 09:08:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C11CBF53
        for <Stable@vger.kernel.org>; Sun, 27 Nov 2022 06:08:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4421B80ADD
        for <Stable@vger.kernel.org>; Sun, 27 Nov 2022 14:08:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2285C433D6;
        Sun, 27 Nov 2022 14:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669558111;
        bh=2DrKf72EzdGYz+cBQA2HP92GfKLVqt/xQllwMTseEKc=;
        h=Subject:To:From:Date:From;
        b=lTwKLzwFbOu2Cs4sk+Ky/hUJqrVCDJGwU79zgV7MogprDVhYpOb3k59QwmQNxr0CY
         Lhn7KudAnc4VeOivG+izTg5gD6E+abekPsD8b6PBRlRRHooDB6Tuv7wcmV3jmcoaUH
         e8I9kPQX1PRAwIrjB7PQcuh7gWojowTAAO7RKqGA=
Subject: patch "iio: addac: ad74413r: fix integer promotion bug in" added to char-misc-next
To:     linux@rasmusvillemoes.dk, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, nuno.sa@analog.com
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Nov 2022 14:49:27 +0100
Message-ID: <166955696722139@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: addac: ad74413r: fix integer promotion bug in

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 980389d06d08442fad0139874bff455c76125e47 Mon Sep 17 00:00:00 2001
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date: Fri, 18 Nov 2022 13:32:08 +0100
Subject: iio: addac: ad74413r: fix integer promotion bug in
 ad74413_get_input_current_offset()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The constant AD74413R_ADC_RESULT_MAX is defined via GENMASK, so its
type is "unsigned long".

Hence in the expression voltage_offset * AD74413R_ADC_RESULT_MAX,
voltage_offset is first promoted to unsigned long, and since it may be
negative, that results in a garbage value. For example, when range is
AD74413R_ADC_RANGE_5V_BI_DIR, voltage_offset is -2500 and
voltage_range is 5000, so the RHS of this assignment is, depending on
sizeof(long), either 826225UL or 3689348814709142UL, which after
truncation to int then results in either 826225 or 1972216214 being
the output from in_currentX_offset.

Casting to int avoids that promotion and results in the correct -32767
output.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Fixes: fea251b6a5db (iio: addac: add AD74413R driver)
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20221118123209.1658420-1-linux@rasmusvillemoes.dk
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/addac/ad74413r.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/addac/ad74413r.c b/drivers/iio/addac/ad74413r.c
index 899bcd83f40b..e0e130ba9d3e 100644
--- a/drivers/iio/addac/ad74413r.c
+++ b/drivers/iio/addac/ad74413r.c
@@ -691,7 +691,7 @@ static int ad74413_get_input_current_offset(struct ad74413r_state *st,
 	if (ret)
 		return ret;
 
-	*val = voltage_offset * AD74413R_ADC_RESULT_MAX / voltage_range;
+	*val = voltage_offset * (int)AD74413R_ADC_RESULT_MAX / voltage_range;
 
 	return IIO_VAL_INT;
 }
-- 
2.38.1



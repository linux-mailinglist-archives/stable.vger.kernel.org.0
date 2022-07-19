Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1CD579BB2
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbiGSMbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240642AbiGSM3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:29:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0017E691F9;
        Tue, 19 Jul 2022 05:11:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD62BB81B32;
        Tue, 19 Jul 2022 12:11:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8E3C341CF;
        Tue, 19 Jul 2022 12:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232685;
        bh=HpRZwYpGGp11YRHRT9z7MzDiIt7YNlvkO80tr+oVew8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e9qZniKmRC3UzYZlLKzgd4Njv09lWr5yR0eY7ynWvYqcjwG2k1qQhm0rmnIbY9lqY
         A1+jpwdobmbHyyC91OaLSddQfZOCsUVKVQD+jxu/VmJp03a4USktFJmenaWG9q2l3u
         gCh9EZh9Zy4gwSmYZVxTrRFcS0IWdP+MqIWUvhRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/167] reset: Fix devm bulk optional exclusive control getter
Date:   Tue, 19 Jul 2022 13:52:42 +0200
Message-Id: <20220719114659.674929709@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit a57f68ddc8865d59a19783080cc52fb4a11dc209 ]

Most likely due to copy-paste mistake the device managed version of the
denoted reset control getter has been implemented with invalid semantic,
which can be immediately spotted by having "WARN_ON(shared && acquired)"
warning in the system log as soon as the method is called. Anyway let's
fix it by altering the boolean arguments passed to the
__devm_reset_control_bulk_get() method from
- shared = true, optional = false, acquired = true
to
+ shared = false, optional = true, acquired = true
That's what they were supposed to be in the first place (see the non-devm
version of the same method: reset_control_bulk_get_optional_exclusive()).

Fixes: 48d71395896d ("reset: Add reset_control_bulk API")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://lore.kernel.org/r/20220624141853.7417-2-Sergey.Semin@baikalelectronics.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/reset.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/reset.h b/include/linux/reset.h
index db0e6115a2f6..7bb583737528 100644
--- a/include/linux/reset.h
+++ b/include/linux/reset.h
@@ -711,7 +711,7 @@ static inline int __must_check
 devm_reset_control_bulk_get_optional_exclusive(struct device *dev, int num_rstcs,
 					       struct reset_control_bulk_data *rstcs)
 {
-	return __devm_reset_control_bulk_get(dev, num_rstcs, rstcs, true, false, true);
+	return __devm_reset_control_bulk_get(dev, num_rstcs, rstcs, false, true, true);
 }
 
 /**
-- 
2.35.1




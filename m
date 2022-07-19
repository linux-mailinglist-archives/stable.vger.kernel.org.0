Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFDE579DBA
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241868AbiGSMyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242085AbiGSMxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:53:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F244D818;
        Tue, 19 Jul 2022 05:21:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B18C5CE1BE6;
        Tue, 19 Jul 2022 12:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CF2C341C6;
        Tue, 19 Jul 2022 12:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233266;
        bh=YQIHXmKH+az7sis9wuVVKnBmB7cfCuc3yl8zuNYlzrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lWFeGcmr1rjViBvfdCtkn/wuasm1uFb0zZL98MUnF4Jqaep49NMTY3xyib/VAQCAh
         zjn/qIvxjMIX/lFxMZhsMhEzSxYb4rzG5IurDWOOFvOlPPnw7IZCpN9V9bTY0TEO/9
         mWidC19hvgfjBT/Ae5M3kyK3vROiOmzZ3lpvsfT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 035/231] reset: Fix devm bulk optional exclusive control getter
Date:   Tue, 19 Jul 2022 13:52:00 +0200
Message-Id: <20220719114717.105423059@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
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
index 8a21b5756c3e..514ddf003efc 100644
--- a/include/linux/reset.h
+++ b/include/linux/reset.h
@@ -731,7 +731,7 @@ static inline int __must_check
 devm_reset_control_bulk_get_optional_exclusive(struct device *dev, int num_rstcs,
 					       struct reset_control_bulk_data *rstcs)
 {
-	return __devm_reset_control_bulk_get(dev, num_rstcs, rstcs, true, false, true);
+	return __devm_reset_control_bulk_get(dev, num_rstcs, rstcs, false, true, true);
 }
 
 /**
-- 
2.35.1




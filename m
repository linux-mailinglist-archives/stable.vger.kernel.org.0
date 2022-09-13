Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09CD55B733A
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235098AbiIMPFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235369AbiIMPEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:04:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7032F64E;
        Tue, 13 Sep 2022 07:29:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE74FB80FA0;
        Tue, 13 Sep 2022 14:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E60C4314E;
        Tue, 13 Sep 2022 14:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079386;
        bh=3iWgK3pNJMPaywnNeNspWA6vxh5BEbVggat3fdhcvNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQR1FSWOyWg2cFeYbrDyma7JDmQ43aC9Xau3AwpkkvBK1bOWNxiL+cSz78TqCYi6J
         Y3jF2cVW8pUaNsvvprASopIu/EG+ME6WcGCd0v/n2ZduSEowwqSpsq+fKu928Ptr55
         zmeVeSuuYJt0bX5KhPqc9f5rrjBGAznOfs+EmJkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Halaney <ahalaney@redhat.com>,
        Douglas Anderson <dianders@chromium.org>,
        Brian Masney <bmasney@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/108] regulator: core: Clean up on enable failure
Date:   Tue, 13 Sep 2022 16:07:01 +0200
Message-Id: <20220913140357.487443955@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140353.549108748@linuxfoundation.org>
References: <20220913140353.549108748@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Halaney <ahalaney@redhat.com>

[ Upstream commit c32f1ebfd26bece77141257864ed7b4720da1557 ]

If regulator_enable() fails, enable_count is incremented still.
A consumer, assuming no matching regulator_disable() is necessary on
failure, will then get this error message upon regulator_put()
since enable_count is non-zero:

    [    1.277418] WARNING: CPU: 3 PID: 1 at drivers/regulator/core.c:2304 _regulator_put.part.0+0x168/0x170

The consumer could try to fix this in their driver by cleaning up on
error from regulator_enable() (i.e. call regulator_disable()), but that
results in the following since regulator_enable() failed and didn't
increment user_count:

    [    1.258112] unbalanced disables for vreg_l17c
    [    1.262606] WARNING: CPU: 4 PID: 1 at drivers/regulator/core.c:2899 _regulator_disable+0xd4/0x190

Fix this by decrementing enable_count upon failure to enable.

With this in place, just the reason for failure to enable is printed
as expected and developers can focus on the root cause of their issue
instead of thinking their usage of the regulator consumer api is
incorrect. For example, in my case:

    [    1.240426] vreg_l17c: invalid input voltage found

Fixes: 5451781dadf8 ("regulator: core: Only count load for enabled consumers")
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Link: https://lore.kernel.org/r/20220819194336.382740-1-ahalaney@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index ae2addadb36f2..6ba3f6e7ea4f8 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2486,13 +2486,18 @@ static int _regulator_do_enable(struct regulator_dev *rdev)
  */
 static int _regulator_handle_consumer_enable(struct regulator *regulator)
 {
+	int ret;
 	struct regulator_dev *rdev = regulator->rdev;
 
 	lockdep_assert_held_once(&rdev->mutex.base);
 
 	regulator->enable_count++;
-	if (regulator->uA_load && regulator->enable_count == 1)
-		return drms_uA_update(rdev);
+	if (regulator->uA_load && regulator->enable_count == 1) {
+		ret = drms_uA_update(rdev);
+		if (ret)
+			regulator->enable_count--;
+		return ret;
+	}
 
 	return 0;
 }
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B7360BB23
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbiJXUsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234107AbiJXUrH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:47:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C9E1F617;
        Mon, 24 Oct 2022 11:54:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2C57B818BE;
        Mon, 24 Oct 2022 12:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA92C433D6;
        Mon, 24 Oct 2022 12:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615615;
        bh=XS0Hdfl2pYxATSwpgJxBoi+EwwhRfcxcGSPPYm0CGE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KwTzGaSwDp2I8kJFatyGBsIT4xSCexIWexy6bh2vXMgZeRhuJdSzPOch7b5kytylB
         Ij+hRibHSEdLUaOCgQaqdG/6dhZMWREZ9Yy8TvlgPyWdsIZP7+QB3Wrw2hYNEvd/gU
         mRCqXL4KdjvnUJ+Fy5HRk5Z6ybWB1v9wENc0nh4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Song Liu <song@kernel.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 318/530] md/raid5: Ensure stripe_fill happens on non-read IO with journal
Date:   Mon, 24 Oct 2022 13:31:02 +0200
Message-Id: <20221024113059.422789802@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit e2eed85bc75138a9eeb63863d20f8904ac42a577 ]

When doing degrade/recover tests using the journal a kernel BUG
is hit at drivers/md/raid5.c:4381 in handle_parity_checks5():

  BUG_ON(!test_bit(R5_UPTODATE, &dev->flags));

This was found to occur because handle_stripe_fill() was skipped
for stripes in the journal due to a condition in that function.
Thus blocks were not fetched and R5_UPTODATE was not set when
the code reached handle_parity_checks5().

To fix this, don't skip handle_stripe_fill() unless the stripe is
for read.

Fixes: 07e83364845e ("md/r5cache: shift complex rmw from read path to write path")
Link: https://lore.kernel.org/linux-raid/e05c4239-41a9-d2f7-3cfa-4aa9d2cea8c1@deltatee.com/
Suggested-by: Song Liu <song@kernel.org>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3936,7 +3936,7 @@ static void handle_stripe_fill(struct st
 		 * back cache (prexor with orig_page, and then xor with
 		 * page) in the read path
 		 */
-		if (s->injournal && s->failed) {
+		if (s->to_read && s->injournal && s->failed) {
 			if (test_bit(STRIPE_R5C_CACHING, &sh->state))
 				r5c_make_stripe_write_out(sh);
 			goto out;



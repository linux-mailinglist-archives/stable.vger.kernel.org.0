Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63733608AFA
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 11:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbiJVJSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 05:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbiJVJRn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 05:17:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA95B300732;
        Sat, 22 Oct 2022 01:31:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 095C360B26;
        Sat, 22 Oct 2022 07:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF30C433C1;
        Sat, 22 Oct 2022 07:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425249;
        bh=r7PNaX5jg937K92lGyiHI6AtzHOXbs4MRgqduWtMwJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qvgwAB0oLcKPDLBq5ABvQo3SvJbeqG46i6ijZ43V/auglPliGfimCX5lNerl2xhac
         nuV4m9BFNwNtsRjLMKN6zbi6Iu+xxQInUDJnnu8wsGokNg06W50mdxO7scX1CWIQxP
         ye7dt1M+e2qCT3z00J3KQRKbL8wpx2DCW1Ix05dI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Song Liu <song@kernel.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 440/717] md/raid5: Ensure stripe_fill happens on non-read IO with journal
Date:   Sat, 22 Oct 2022 09:25:19 +0200
Message-Id: <20221022072517.796434253@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 1c1310d539f2..d6cad962669a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3951,7 +3951,7 @@ static void handle_stripe_fill(struct stripe_head *sh,
 		 * back cache (prexor with orig_page, and then xor with
 		 * page) in the read path
 		 */
-		if (s->injournal && s->failed) {
+		if (s->to_read && s->injournal && s->failed) {
 			if (test_bit(STRIPE_R5C_CACHING, &sh->state))
 				r5c_make_stripe_write_out(sh);
 			goto out;
-- 
2.35.1




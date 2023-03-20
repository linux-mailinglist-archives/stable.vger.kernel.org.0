Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D73C6C1932
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbjCTPbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233068AbjCTPbY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:31:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20BF2BF00
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:23:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67F0BB80ED7
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7620C433EF;
        Mon, 20 Mar 2023 15:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325822;
        bh=RTQqVSWx6IE27E7U9ID+JWsW+NdwyRMaZL3l3SDcBLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ycq+nFw9RW9LOTX1EH3vtWzNXFuXDxfhTJyY9cChiS6J5YxSc3TIzKZr3ZHYJ5qch
         vvII/0+TayJuFNMnwLi1ShAzsaCUzXO1EPncSgizy3dBB6BJyDw0SCoYzpMg5UCowB
         /nSu5Af5DezetGonhVqdTJBFlfBTQFGtWS3tZ3bE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        "HeungJun, Kim" <riverful.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        HeungJun@vger.kernel.org
Subject: [PATCH 6.2 107/211] media: m5mols: fix off-by-one loop termination error
Date:   Mon, 20 Mar 2023 15:54:02 +0100
Message-Id: <20230320145517.767465808@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit efbcbb12ee99f750c9f25c873b55ad774871de2a ]

The __find_restype() function loops over the m5mols_default_ffmt[]
array, and the termination condition ends up being wrong: instead of
stopping when the iterator becomes the size of the array it traverses,
it stops after it has already overshot the array.

Now, in practice this doesn't likely matter, because the code will
always find the entry it looks for, and will thus return early and never
hit that last extra iteration.

But it turns out that clang will unroll the loop fully, because it has
only two iterations (well, three due to the off-by-one bug), and then
clang will end up just giving up in the middle of the loop unrolling
when it notices that the code walks past the end of the array.

And that made 'objtool' very unhappy indeed, because the generated code
just falls off the edge of the universe, and ends up falling through to
the next function, causing this warning:

   drivers/media/i2c/m5mols/m5mols.o: warning: objtool: m5mols_set_fmt() falls through to next function m5mols_get_frame_desc()

Fix the loop ending condition.

Reported-by: Jens Axboe <axboe@kernel.dk>
Analyzed-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Analyzed-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/linux-block/CAHk-=wgTSdKYbmB1JYM5vmHMcD9J9UZr0mn7BOYM_LudrP+Xvw@mail.gmail.com/
Fixes: bc125106f8af ("[media] Add support for M-5MOLS 8 Mega Pixel camera ISP")
Cc: HeungJun, Kim <riverful.kim@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/m5mols/m5mols_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index 2b01873ba0db5..5c2336f318d9a 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -488,7 +488,7 @@ static enum m5mols_restype __find_restype(u32 code)
 	do {
 		if (code == m5mols_default_ffmt[type].code)
 			return type;
-	} while (type++ != SIZE_DEFAULT_FFMT);
+	} while (++type != SIZE_DEFAULT_FFMT);
 
 	return 0;
 }
-- 
2.39.2




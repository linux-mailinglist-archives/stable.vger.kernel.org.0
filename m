Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15F4D66497A
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239183AbjAJSWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239213AbjAJSVq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:21:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B66564E6
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:19:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 165BE6182C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:19:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1052CC433F1;
        Tue, 10 Jan 2023 18:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374754;
        bh=Aw66NbHdR3tzqai8la13Xdy3HPRRFqBMPg1ZLoBnsdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YmGGi79X28nn5NnwItIKsE6/SIl5alTnLQco25ji41cC2gy1Wv0kq2bYuzGGYXYrK
         W7iFz2J1uCjIJMsZLb1siVtdErFtriMOn0NZkDFuSnIoq2qI6F6G7qVg0uKnysB5Sa
         jV8Xjc+lpR24JPKDu0o9fySmfkfxyZrGye87WE1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "YoungJun.park" <her0gyugyu@gmail.com>,
        David Gow <davidgow@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 122/159] kunit: alloc_string_stream_fragment error handling bug fix
Date:   Tue, 10 Jan 2023 19:04:30 +0100
Message-Id: <20230110180022.216965718@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: YoungJun.park <her0gyugyu@gmail.com>

[ Upstream commit 93ef83050e597634d2c7dc838a28caf5137b9404 ]

When it fails to allocate fragment, it does not free and return error.
And check the pointer inappropriately.

Fixed merge conflicts with
commit 618887768bb7 ("kunit: update NULL vs IS_ERR() tests")
Shuah Khan <skhan@linuxfoundation.org>

Signed-off-by: YoungJun.park <her0gyugyu@gmail.com>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/string-stream.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/kunit/string-stream.c b/lib/kunit/string-stream.c
index a608746020a9..7aeabe1a3dc5 100644
--- a/lib/kunit/string-stream.c
+++ b/lib/kunit/string-stream.c
@@ -23,8 +23,10 @@ static struct string_stream_fragment *alloc_string_stream_fragment(
 		return ERR_PTR(-ENOMEM);
 
 	frag->fragment = kunit_kmalloc(test, len, gfp);
-	if (!frag->fragment)
+	if (!frag->fragment) {
+		kunit_kfree(test, frag);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	return frag;
 }
-- 
2.35.1




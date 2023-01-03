Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F26465C67C
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 19:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbjACSk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 13:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233780AbjACSkB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 13:40:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04C413F35;
        Tue,  3 Jan 2023 10:39:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64313614DF;
        Tue,  3 Jan 2023 18:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082A1C433F0;
        Tue,  3 Jan 2023 18:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672771192;
        bh=8Umq9Xxnllow9TnRdcVuyzsumvQE9TJSU80rpAx4mmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZBZLOeV1P+JPxPFAILiNI0V2m5VILP42ToLmN7Ldsyr6VnDnTfYKFK876LxfoL2EG
         ejihKDPv3LFj3wl9jevGKW5IAwedb8Nc/Qiu5z1CQVd1opA6hZpgVpG45VPJUj+6pC
         3/1Ov7gLsIokEIwN7ozsBiSIVgSMbNsaC/KSxt+4Px0hW3SDEkyLvoC+WefQKLLmRh
         Sjjb1SwdFTWYytF8mMCxbsBNdD3IbmMZAatmFumUa5G1ObfHIEA7sQtX8s6UeEo87v
         9z5KV4vAxdIusbeXiR5o0KfCuGA/s5KWMnO8TFQrguvMzatq6osVCof9elO1zvCS6o
         8obMs4szsd0lQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "YoungJun.park" <her0gyugyu@gmail.com>,
        David Gow <davidgow@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
Subject: [PATCH AUTOSEL 6.1 08/10] kunit: alloc_string_stream_fragment error handling bug fix
Date:   Tue,  3 Jan 2023 13:39:32 -0500
Message-Id: <20230103183934.2022663-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230103183934.2022663-1-sashal@kernel.org>
References: <20230103183934.2022663-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "YoungJun.park" <her0gyugyu@gmail.com>

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


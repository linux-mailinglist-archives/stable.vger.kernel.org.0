Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E45687485
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 05:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbjBBEo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 23:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjBBEoM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 23:44:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B277A483;
        Wed,  1 Feb 2023 20:43:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 686D7B8241E;
        Thu,  2 Feb 2023 04:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2FCC433EF;
        Thu,  2 Feb 2023 04:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675313030;
        bh=PuhSXXH7ABpQ0zNff3KqR9dMDr71RXa2680XZD99Eus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RY+m7BOtLdJCIQuPIS5UJRKNr7upaEVDxVRIJjOJwcDhsftkCWO24n1rpzjv/CYf/
         CsOcX9wTv1ppYk3aCsRqnVXIW7x9FaCsVYxLhmsV0Jt9RInFx3aMWngbw9BGtBti8R
         TLlFDCyKO4QgUfKGjgOEEcCvOtXBL8EKQVpUknz7GNnfhhiRFg3hNqhQdiNttXr/KZ
         hdqXSFEraVvS1fAXnQaovWuF/aHNkUJ3zXcd2ARlAguZF8ts1yMeU+F+6xh+a2ZSlQ
         0qCJSw2jvhAfhsqO6O+RO5Vvi2KIvNacNBOsk7v39wOSAOLserOBVgQrrwKKXG9k6g
         CVe6Cz9uPqa9w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.4 06/17] hexagon: Fix function name in die()
Date:   Wed,  1 Feb 2023 20:42:44 -0800
Message-Id: <20230202044255.128815-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230202044255.128815-1-ebiggers@kernel.org>
References: <20230202044255.128815-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit 4f0712ccec09c071e221242a2db9a6779a55a949 upstream.

When building ARCH=hexagon defconfig:

arch/hexagon/kernel/traps.c:217:2: error: implicit declaration of
function 'make_dead_task' [-Werror,-Wimplicit-function-declaration]
        make_dead_task(err);
        ^

The function's name is make_task_dead(), change it so there is no more
build error.

Fixes: 0e25498f8cd4 ("exit: Add and use make_task_dead.")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lkml.kernel.org/r/20211227184851.2297759-2-nathan@kernel.org
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/hexagon/kernel/traps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/hexagon/kernel/traps.c b/arch/hexagon/kernel/traps.c
index bfd04a388bcac..f69eae3f32bd2 100644
--- a/arch/hexagon/kernel/traps.c
+++ b/arch/hexagon/kernel/traps.c
@@ -221,7 +221,7 @@ int die(const char *str, struct pt_regs *regs, long err)
 		panic("Fatal exception");
 
 	oops_exit();
-	make_dead_task(err);
+	make_task_dead(err);
 	return 0;
 }
 
-- 
2.39.1


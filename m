Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB402536201
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352647AbiE0MHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 08:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352929AbiE0MFV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 08:05:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133DF14E2E0;
        Fri, 27 May 2022 04:53:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E6B261DCA;
        Fri, 27 May 2022 11:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A31C385A9;
        Fri, 27 May 2022 11:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652432;
        bh=JHeNvVQv+nXpZEwiZAVU/EY4i1gnNMnF72ZktDobAGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pp9ficJaG7tuSNKnvZhFDt2X5T3dWY2dnG6Iy6KuM3iOdO8rYCJdCSraY5NOiTvw4
         qPqpWapasH6tgBWAxtgjsnpoj1A2xDgsaM9kJNaNfEo/2gUkvk51Yx99FdAhOM7dgd
         Y5O4eq8AjhraCxPPQo8DCYtrwcR7Ruyi4ZY+ckpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 154/163] random: use proper return types on get_random_{int,long}_wait()
Date:   Fri, 27 May 2022 10:50:34 +0200
Message-Id: <20220527084849.696938046@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 7c3a8a1db5e03d02cc0abb3357a84b8b326dfac3 upstream.

Before these were returning signed values, but the API is intended to be
used with unsigned values.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/random.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -81,18 +81,18 @@ static inline int get_random_bytes_wait(
 	return ret;
 }
 
-#define declare_get_random_var_wait(var) \
-	static inline int get_random_ ## var ## _wait(var *out) { \
+#define declare_get_random_var_wait(name, ret_type) \
+	static inline int get_random_ ## name ## _wait(ret_type *out) { \
 		int ret = wait_for_random_bytes(); \
 		if (unlikely(ret)) \
 			return ret; \
-		*out = get_random_ ## var(); \
+		*out = get_random_ ## name(); \
 		return 0; \
 	}
-declare_get_random_var_wait(u32)
-declare_get_random_var_wait(u64)
-declare_get_random_var_wait(int)
-declare_get_random_var_wait(long)
+declare_get_random_var_wait(u32, u32)
+declare_get_random_var_wait(u64, u32)
+declare_get_random_var_wait(int, unsigned int)
+declare_get_random_var_wait(long, unsigned long)
 #undef declare_get_random_var
 
 /*



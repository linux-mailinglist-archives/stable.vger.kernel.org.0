Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651156157E7
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbiKBClZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbiKBClY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:41:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCB920999
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:41:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCC15617AD
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AA6C433D7;
        Wed,  2 Nov 2022 02:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356882;
        bh=2GAIB/PyxJZjphJgAZkuovBXHokmNHaueOZSvra7BjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P52DN8Z3ycefG8X93Isio4urBub1Utbjlne/jLi95BHFMK0mqtmOSqVR+xU4iGKv4
         mJ44y4wlwNB1DVTGrVOXfBYX3EVl9hahQaYVzXf3N+p84ySFRDZGl9mSIHIH3QaErF
         PqEgn/d0qsexkUBlzSXnst6/ySxvISM8f3/4pHOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 6.0 076/240] random: use arch_get_random*_early() in random_init()
Date:   Wed,  2 Nov 2022 03:30:51 +0100
Message-Id: <20221102022113.122414627@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

commit f5e4ec155d145002fd9840868453d785fab86d42 upstream.

While reworking the archrandom handling, commit d349ab99eec7 ("random:
handle archrandom with multiple longs") switched to the non-early
archrandom helpers in random_init(), which broke initialization of the
entropy pool from the arm64 random generator.

Indeed at that point the arm64 CPU features, which verify that all CPUs
have compatible capabilities, are not finalized so arch_get_random_seed_longs()
is unsuccessful. Instead random_init() should use the _early functions,
which check only the boot CPU on arm64. On other architectures the
_early functions directly call the normal ones.

Fixes: d349ab99eec7 ("random: handle archrandom with multiple longs")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -793,13 +793,13 @@ int __init random_init(const char *comma
 #endif
 
 	for (i = 0, arch_bits = sizeof(entropy) * 8; i < ARRAY_SIZE(entropy);) {
-		longs = arch_get_random_seed_longs(entropy, ARRAY_SIZE(entropy) - i);
+		longs = arch_get_random_seed_longs_early(entropy, ARRAY_SIZE(entropy) - i);
 		if (longs) {
 			_mix_pool_bytes(entropy, sizeof(*entropy) * longs);
 			i += longs;
 			continue;
 		}
-		longs = arch_get_random_longs(entropy, ARRAY_SIZE(entropy) - i);
+		longs = arch_get_random_longs_early(entropy, ARRAY_SIZE(entropy) - i);
 		if (longs) {
 			_mix_pool_bytes(entropy, sizeof(*entropy) * longs);
 			i += longs;



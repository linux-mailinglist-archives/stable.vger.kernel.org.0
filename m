Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365A564A197
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbiLLNnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232948AbiLLNmh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:42:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22CD1409D
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:41:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99CBCB80D2B
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B80C433F0;
        Mon, 12 Dec 2022 13:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852488;
        bh=c4VZ35ZCVt702xcPRU2p4u3zoSnCAYStqWB1ED/qZbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JM0Eb3SxvB95SGM1/8uBprKk7PphhbIu0veP1T0rBmookOG4LaIu5zeRbBNtSRA31
         ksQfCkDWcDTHWBg6ol1RuHiDHEDIZAU9uRtbeMLExnd3/ROzk+KeBU25Z3iAut32JG
         NT3jjXHBA1mHvfiYy8e59sKqFS9uoDg3x98TOD7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hangbin Liu <liuhangbin@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.0 064/157] selftests/tls: Fix tls selftests dependency to correct algorithm
Date:   Mon, 12 Dec 2022 14:16:52 +0100
Message-Id: <20221212130937.146472438@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

commit 6648eadba8d6b37c8e6cb1b906f68509b3b39385 upstream.

Commit d2825fa9365d ("crypto: sm3,sm4 - move into crypto directory") moves
SM3 and SM4 algorithm implementations from stand-alone library to crypto
API. The corresponding configuration options for the API version (generic)
are CONFIG_CRYPTO_SM3_GENERIC and CONFIG_CRYPTO_SM4_GENERIC, respectively.

Replace option selected in selftests configuration from the library version
to the API version.

Fixes: d2825fa9365d ("crypto: sm3,sm4 - move into crypto directory")
Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: stable@vger.kernel.org # v5.19+
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Link: https://lore.kernel.org/r/20221201131852.38501-1-tianjia.zhang@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/config | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index ead7963b9bf0..bd89198cd817 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -43,5 +43,5 @@ CONFIG_NET_ACT_TUNNEL_KEY=m
 CONFIG_NET_ACT_MIRRED=m
 CONFIG_BAREUDP=m
 CONFIG_IPV6_IOAM6_LWTUNNEL=y
-CONFIG_CRYPTO_SM4=y
+CONFIG_CRYPTO_SM4_GENERIC=y
 CONFIG_AMT=m
-- 
2.38.1




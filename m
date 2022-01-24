Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85340499FAD
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842018AbiAXXAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:00:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835944AbiAXWht (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:37:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A03C0E9BB6;
        Mon, 24 Jan 2022 13:00:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7209360B03;
        Mon, 24 Jan 2022 21:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52773C340E7;
        Mon, 24 Jan 2022 21:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058008;
        bh=ZJHWMUCWg6+N2cEePcY7AEKzfwzAQ9WRJqqZIo2gEFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJjIRKV1uz5AoJ2tLkOM91W9VAyNtNLQhghQ7C+04UeiL3vD1038Fm3td41VcVLvB
         GxmY3ji/I2aE5WzBQcYrlT4eRE1kiIU2hQjnrAhcwZMyI6/Ii2gTcDxyR4ynOd3PvV
         y7OVkqGTsA65SAm5og6G0jW9l0N0uQfMhzHFRZc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Kerr <jk@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0150/1039] mctp/test: Update refcount checking in route fragment tests
Date:   Mon, 24 Jan 2022 19:32:19 +0100
Message-Id: <20220124184130.204931581@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit f6ef47e5bdc6f652176e433b02317fc83049f8d7 ]

In 99ce45d5e, we moved a route refcount decrement from
mctp_do_fragment_route into the caller. This invalidates the assumption
that the route test makes about refcount behaviour, so the route tests
fail.

This change fixes the test case to suit the new refcount behaviour.

Fixes: 99ce45d5e7db ("mctp: Implement extended addressing")
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/test/route-test.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/mctp/test/route-test.c b/net/mctp/test/route-test.c
index 36fac3daf86a4..86ad15abf8978 100644
--- a/net/mctp/test/route-test.c
+++ b/net/mctp/test/route-test.c
@@ -150,11 +150,6 @@ static void mctp_test_fragment(struct kunit *test)
 	rt = mctp_test_create_route(&init_net, NULL, 10, mtu);
 	KUNIT_ASSERT_TRUE(test, rt);
 
-	/* The refcount would usually be incremented as part of a route lookup,
-	 * but we're setting the route directly here.
-	 */
-	refcount_inc(&rt->rt.refs);
-
 	rc = mctp_do_fragment_route(&rt->rt, skb, mtu, MCTP_TAG_OWNER);
 	KUNIT_EXPECT_FALSE(test, rc);
 
-- 
2.34.1




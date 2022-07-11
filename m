Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA8256FA7C
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbiGKJSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbiGKJRo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:17:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B3949B7F;
        Mon, 11 Jul 2022 02:11:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21460611E3;
        Mon, 11 Jul 2022 09:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD73C34115;
        Mon, 11 Jul 2022 09:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530693;
        bh=HSzoByN3zguKFAgIotEhKn7qxv6ee9YgGPcOGUZevy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbdSD1IxazhEyS4kORl+FFpNoGDEw6taFK+enxMrLM9c9VvsTlUnhgWVY9UiqvDST
         Sykzky5kO5yS/l5hyKPeLA0Jqu0XI8IkQ667nJslO1mGgPbZP1y6ZE93AylTUiay6D
         9ssLw6ulm9RLytJED+/vGypZENXiMPESfgYnytuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 27/38] selftests: forwarding: fix error message in learning_test
Date:   Mon, 11 Jul 2022 11:07:09 +0200
Message-Id: <20220711090539.530013137@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090538.722676354@linuxfoundation.org>
References: <20220711090538.722676354@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 83844aacab2015da1dba1df0cc61fc4b4c4e8076 ]

When packets are not received, they aren't received on $host1_if, so the
message talking about the second host not receiving them is incorrect.
Fix it.

Fixes: d4deb01467ec ("selftests: forwarding: Add a test for FDB learning")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/lib.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index b759f7903c06..f190ad58e00d 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -905,7 +905,7 @@ learning_test()
 	tc -j -s filter show dev $host1_if ingress \
 		| jq -e ".[] | select(.options.handle == 101) \
 		| select(.options.actions[0].stats.packets == 1)" &> /dev/null
-	check_fail $? "Packet reached second host when should not"
+	check_fail $? "Packet reached first host when should not"
 
 	$MZ $host1_if -c 1 -p 64 -a $mac -t ip -q
 	sleep 1
-- 
2.35.1




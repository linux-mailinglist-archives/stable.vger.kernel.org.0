Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA8D56FE01
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbiGKKDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234468AbiGKKCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 06:02:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D9D64E39;
        Mon, 11 Jul 2022 02:28:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB58561366;
        Mon, 11 Jul 2022 09:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6896C34115;
        Mon, 11 Jul 2022 09:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531737;
        bh=nRZ2ev52J18zqlSet3uQyM6CKCgYTI5uU0dUwqorEtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uzZ+09J67zVOrwS9GMYgY1ou+obXJ2FP78aYBoyhGZhRV/XYHOtqTKcRM2hpV+ezI
         5Z8fbLVbomEFCFCAqITEuZVqOOz6cp7g08KVJg9N/7UX3knIWBAfkf/h94gJdebby1
         QcmgORfiL8ffia+F6I5xw/PwaPxEloQxbjaynlfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 212/230] selftests: forwarding: fix error message in learning_test
Date:   Mon, 11 Jul 2022 11:07:48 +0200
Message-Id: <20220711090610.116942090@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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
index 0db6ea8d7e05..c9507df9c05b 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1160,7 +1160,7 @@ learning_test()
 	tc -j -s filter show dev $host1_if ingress \
 		| jq -e ".[] | select(.options.handle == 101) \
 		| select(.options.actions[0].stats.packets == 1)" &> /dev/null
-	check_fail $? "Packet reached second host when should not"
+	check_fail $? "Packet reached first host when should not"
 
 	$MZ $host1_if -c 1 -p 64 -a $mac -t ip -q
 	sleep 1
-- 
2.35.1




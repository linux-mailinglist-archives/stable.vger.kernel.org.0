Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D54C4CF936
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239943AbiCGKEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240277AbiCGKAz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:00:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A487EA01;
        Mon,  7 Mar 2022 01:47:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D400E61220;
        Mon,  7 Mar 2022 09:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E1FC340E9;
        Mon,  7 Mar 2022 09:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646434;
        bh=GM+SAC4XwtLdOfovUXNj15UnumA0rmQKcj4iNRK+McQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MbhK3lZynnPCw38EVRT3rBQhG88DSBEemx7jvXW59nWrtEEpyikN8sEAKY1mPwlV9
         oEFfacak9tGiI+8Kw35rB98bAur1/ILBaGdZsDkc4NVvLFAg8ENyKpnxLNa/xSaaxd
         /EiF25OZ/ESyguWLy2AExZE/pNWlWOae5q+sF1mo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Cohen <amcohen@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 242/262] selftests: mlxsw: resource_scale: Fix return value
Date:   Mon,  7 Mar 2022 10:19:46 +0100
Message-Id: <20220307091710.296934597@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

[ Upstream commit 196f9bc050cbc5085b4cbb61cce2efe380bc66d0 ]

The test runs several test cases and is supposed to return an error in
case at least one of them failed.

Currently, the check of the return value of each test case is in the
wrong place, which can result in the wrong return value. For example:

 # TESTS='tc_police' ./resource_scale.sh
 TEST: 'tc_police' [default] 968                                     [FAIL]
         tc police offload count failed
 Error: mlxsw_spectrum: Failed to allocate policer index.
 We have an error talking to the kernel
 Command failed /tmp/tmp.i7Oc5HwmXY:969
 TEST: 'tc_police' [default] overflow 969                            [ OK ]
 ...
 TEST: 'tc_police' [ipv4_max] overflow 969                           [ OK ]

 $ echo $?
 0

Fix this by moving the check to be done after each test case.

Fixes: 059b18e21c63 ("selftests: mlxsw: Return correct error code in resource scale test")
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/drivers/net/mlxsw/spectrum/resource_scale.sh      | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
index 685dfb3478b3..b9b8274643de 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
@@ -50,8 +50,8 @@ for current_test in ${TESTS:-$ALL_TESTS}; do
 			else
 				log_test "'$current_test' [$profile] overflow $target"
 			fi
+			RET_FIN=$(( RET_FIN || RET ))
 		done
-		RET_FIN=$(( RET_FIN || RET ))
 	done
 done
 current_test=""
-- 
2.34.1




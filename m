Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F464CFB33
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbiCGKct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:32:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240101AbiCGK1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:27:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B62B6D4F9;
        Mon,  7 Mar 2022 02:01:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6405AB810C3;
        Mon,  7 Mar 2022 09:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82DAC340E9;
        Mon,  7 Mar 2022 09:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646647009;
        bh=4HZR3FGCDTx2vgRZ0cLmyAQw9TnJRaGdyrSyXvUjbuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NqRUr9OVwyebl2AU4ZOQ21bkyLnnrMFE304nrW+UdwlBQgVHqUA12EANpFP0VX3gT
         rd3fCSwko3Alb2nun1RORl33EuxuEOdyg6IZxzptFxR8rnpe5Y5ov/MS24EjBeR1lA
         9y6S483G9TV7j1B7QgZ6dNjIfIODTRHq62eUcmuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Cohen <amcohen@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 164/186] selftests: mlxsw: resource_scale: Fix return value
Date:   Mon,  7 Mar 2022 10:20:02 +0100
Message-Id: <20220307091658.662396399@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
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
index bcb110e830ce..dea33dc93790 100755
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




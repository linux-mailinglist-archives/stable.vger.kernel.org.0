Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1494A69CCA0
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbjBTNm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbjBTNmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:42:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89791D91B
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:42:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F8ADB80D4C
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3CFDC4339B;
        Mon, 20 Feb 2023 13:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900524;
        bh=8hVdpM989xGRw5gJgED2YVX1d75jEbCgBdIIgg5NmkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=04T+lNfr38xGJnJye3GulOq5hgYb3DBCWMteIUJCudLrK8A7aQugtEbLjt+knwd7e
         y3Wc/WyEXn4Aemws8wWVqyjWLbhISEF9V0GWmAus+EIlzjLPMY5WpW2FVLTQ35Ilfq
         AipukrxV5wOmPnyMtCaP7rLJJxdBsQNmH5MVk4wM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hangbin Liu <liuhangbin@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 50/89] selftests: forwarding: lib: quote the sysctl values
Date:   Mon, 20 Feb 2023 14:35:49 +0100
Message-Id: <20230220133554.892788535@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 3a082086aa200852545cf15159213582c0c80eba ]

When set/restore sysctl value, we should quote the value as some keys
may have multi values, e.g. net.ipv4.ping_group_range

Fixes: f5ae57784ba8 ("selftests: forwarding: lib: Add sysctl_set(), sysctl_restore()")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Link: https://lore.kernel.org/r/20230208032110.879205-1-liuhangbin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/lib.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index ee03552b41167..7ead9d2aa6b8a 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -519,14 +519,14 @@ sysctl_set()
 	local value=$1; shift
 
 	SYSCTL_ORIG[$key]=$(sysctl -n $key)
-	sysctl -qw $key=$value
+	sysctl -qw $key="$value"
 }
 
 sysctl_restore()
 {
 	local key=$1; shift
 
-	sysctl -qw $key=${SYSCTL_ORIG["$key"]}
+	sysctl -qw $key="${SYSCTL_ORIG[$key]}"
 }
 
 forwarding_enable()
-- 
2.39.0




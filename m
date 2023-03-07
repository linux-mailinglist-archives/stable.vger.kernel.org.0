Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7011D6AE955
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjCGRW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:22:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbjCGRWf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:22:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056082915A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:18:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95F3A614FF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7D5C433D2;
        Tue,  7 Mar 2023 17:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209482;
        bh=YPgh0AhVMBwuvC1FB1jKznntH8Jwwl3qVXSAGKpY0Ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gf1Ey/iI9peO09WVdZveucda7roWrUn0B9Th+ibJ/LCXEYqyIHDILFDd4aHFiwMYp
         2OYV7F5gve5QC1WGcYEEKnUUu/Un8BzY6SLucn6Gi/5fZmhMW6hDmlc/4akpojIb1T
         Pghkeirbys52TGqSWBZbkRjFnHvTXWMabaDUFfnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexei Starovoitov <ast@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0234/1001] selftests/bpf: Initialize tc in xdp_synproxy
Date:   Tue,  7 Mar 2023 17:50:06 +0100
Message-Id: <20230307170032.006594156@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 354bb4a0e0b6be8f55bacbe7f08c94b4741f5658 ]

xdp_synproxy/xdp fails in CI with:

    Error: bpf_tc_hook_create: File exists

The XDP version of the test should not be calling bpf_tc_hook_create();
the reason it's happening anyway is that if we don't specify --tc on the
command line, tc variable remains uninitialized.

Fixes: 784d5dc0efc2 ("selftests/bpf: Add selftests for raw syncookie helpers in TC mode")
Reported-by: Alexei Starovoitov <ast@kernel.org>
Reported-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Link: https://lore.kernel.org/r/20230202235335.3403781-1-iii@linux.ibm.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/xdp_synproxy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/xdp_synproxy.c b/tools/testing/selftests/bpf/xdp_synproxy.c
index 410a1385a01dd..6dbe0b7451985 100644
--- a/tools/testing/selftests/bpf/xdp_synproxy.c
+++ b/tools/testing/selftests/bpf/xdp_synproxy.c
@@ -116,6 +116,7 @@ static void parse_options(int argc, char *argv[], unsigned int *ifindex, __u32 *
 	*tcpipopts = 0;
 	*ports = NULL;
 	*single = false;
+	*tc = false;
 
 	while (true) {
 		int opt;
-- 
2.39.2




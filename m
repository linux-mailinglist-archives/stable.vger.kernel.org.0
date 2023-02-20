Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78AA269CE40
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbjBTN54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbjBTN5z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:57:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768901EBDE
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:57:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5381B60EA5
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EF9C433EF;
        Mon, 20 Feb 2023 13:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901452;
        bh=Un6JpB0UHci0qIBH1D+no3jpcc+8i6GyZ7154XvIZjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O57ESA0vHX5+JjrR4IF2wwduK2GQ7vlVRkijri+qEgSQyPYK3gJBXkGpSsKdq1khb
         LiZBNAfHPw+aI9Tn7y33IH8hlx54pG6OoUuv/ub8ccjeEOlyWaPQbTkSQvWw1bJdZ8
         XDmsMrvQ/mnOq2JezLmkByNJcx7bVvdLDTdVsLuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Andrei Gherzan <andrei.gherzan@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/118] selftest: net: Improve IPV6_TCLASS/IPV6_HOPLIMIT tests apparmor compatibility
Date:   Mon, 20 Feb 2023 14:35:38 +0100
Message-Id: <20230220133601.313432606@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
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

From: Andrei Gherzan <andrei.gherzan@canonical.com>

[ Upstream commit a6efc42a86c0c87cfe2f1c3d1f09a4c9b13ba890 ]

"tcpdump" is used to capture traffic in these tests while using a random,
temporary and not suffixed file for it. This can interfere with apparmor
configuration where the tool is only allowed to read from files with
'known' extensions.

The MINE type application/vnd.tcpdump.pcap was registered with IANA for
pcap files and .pcap is the extension that is both most common but also
aligned with standard apparmor configurations. See TCPDUMP(8) for more
details.

This improves compatibility with standard apparmor configurations by
using ".pcap" as the file extension for the tests' temporary files.

Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/cmsg_ipv6.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/cmsg_ipv6.sh b/tools/testing/selftests/net/cmsg_ipv6.sh
index 2d89cb0ad2889..330d0b1ceced3 100755
--- a/tools/testing/selftests/net/cmsg_ipv6.sh
+++ b/tools/testing/selftests/net/cmsg_ipv6.sh
@@ -6,7 +6,7 @@ ksft_skip=4
 NS=ns
 IP6=2001:db8:1::1/64
 TGT6=2001:db8:1::2
-TMPF=`mktemp`
+TMPF=$(mktemp --suffix ".pcap")
 
 cleanup()
 {
-- 
2.39.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A961D694A2E
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbjBMPFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbjBMPFE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:05:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6171E1C2
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:05:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19EB1B81257
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40ED8C433EF;
        Mon, 13 Feb 2023 15:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300699;
        bh=F63YXpzKJKXeeDKsY9kHgLGcNcJlNPjtdmpxBycAH9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJkDI0IHP/FNNP8vMlApflvKr+HqUWdfIUm8EP0d93wOJKMQ5r0P6ouH2GRRwB/py
         0ToBUQ/Xs1tXHn2axRfCt+KflHJf9ByScx3S5U84ASlPEl4ptNloBMGWdPek9PZjWJ
         lV5XBn9q7JXIFIS+O11V9GGojpfdVK94uljiGkEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Herton R. Krzesinski" <herton@redhat.com>,
        Carlos ODonell <carlos@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 115/139] uapi: add missing ip/ipv6 header dependencies for linux/stddef.h
Date:   Mon, 13 Feb 2023 15:51:00 +0100
Message-Id: <20230213144751.976694382@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
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

From: Herton R. Krzesinski <herton@redhat.com>

[ Upstream commit 03702d4d29be4e2510ec80b248dbbde4e57030d9 ]

Since commit 58e0be1ef6118 ("net: use struct_group to copy ip/ipv6
header addresses"), ip and ipv6 headers started to use the __struct_group
definition, which is defined at include/uapi/linux/stddef.h. However,
linux/stddef.h isn't explicitly included in include/uapi/linux/{ip,ipv6}.h,
which breaks build of xskxceiver bpf selftest if you install the uapi
headers in the system:

$ make V=1 xskxceiver -C tools/testing/selftests/bpf
...
make: Entering directory '(...)/tools/testing/selftests/bpf'
gcc -g -O0 -rdynamic -Wall -Werror (...)
In file included from xskxceiver.c:79:
/usr/include/linux/ip.h:103:9: error: expected specifier-qualifier-list before ‘__struct_group’
  103 |         __struct_group(/* no tag */, addrs, /* no attrs */,
      |         ^~~~~~~~~~~~~~
...

Include the missing <linux/stddef.h> dependency in ip.h and do the
same for the ipv6.h header.

Fixes: 58e0be1ef611 ("net: use struct_group to copy ip/ipv6 header addresses")
Signed-off-by: Herton R. Krzesinski <herton@redhat.com>
Reviewed-by: Carlos O'Donell <carlos@redhat.com>
Tested-by: Carlos O'Donell <carlos@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/ip.h   | 1 +
 include/uapi/linux/ipv6.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/uapi/linux/ip.h b/include/uapi/linux/ip.h
index d2f143393780c..860bbf6bf29cb 100644
--- a/include/uapi/linux/ip.h
+++ b/include/uapi/linux/ip.h
@@ -18,6 +18,7 @@
 #ifndef _UAPI_LINUX_IP_H
 #define _UAPI_LINUX_IP_H
 #include <linux/types.h>
+#include <linux/stddef.h>
 #include <asm/byteorder.h>
 
 #define IPTOS_TOS_MASK		0x1E
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index 766ab5c8ee655..d44d0483fd73f 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -4,6 +4,7 @@
 
 #include <linux/libc-compat.h>
 #include <linux/types.h>
+#include <linux/stddef.h>
 #include <linux/in6.h>
 #include <asm/byteorder.h>
 
-- 
2.39.0




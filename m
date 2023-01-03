Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87A0065BBBD
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjACIPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237011AbjACIP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:15:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5DEDFAA
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:15:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0923A611CF
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC33C433D2;
        Tue,  3 Jan 2023 08:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733712;
        bh=aqT0K3Yhg1Khi8nfpCkMU2vySz60QhXWT201+JJD1Lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPZqJcHhZVeZ54LcuaQq0jDngouSU5SY3G4ug/A7flNUa4bjzTEdgCyFXyTkSigad
         XdagqrM/HSssdS0avbwY4RJ1fJuRWB4By4XUlIrGCgM9zWhgcNxTSRSOKw+9snsTsx
         3YvicFDs2RzoY+LOL/ZCBhqgyVfzY4T/6vWGVXHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 08/63] tools headers UAPI: Sync openat2.h with the kernel sources
Date:   Tue,  3 Jan 2023 09:13:38 +0100
Message-Id: <20230103081309.064401565@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 1e61463cfcd0b3e7a19ba36b8a98c64ebaac5c6e ]

To pick the changes in:

  99668f618062816c ("fs: expose LOOKUP_CACHED through openat2() RESOLVE_CACHED")

That don't result in any change in tooling, only silences this perf
build warning:

  Warning: Kernel ABI header at 'tools/include/uapi/linux/openat2.h' differs from latest version at 'include/uapi/linux/openat2.h'
  diff -u tools/include/uapi/linux/openat2.h include/uapi/linux/openat2.h

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/uapi/linux/openat2.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/include/uapi/linux/openat2.h
+++ b/tools/include/uapi/linux/openat2.h
@@ -35,5 +35,9 @@ struct open_how {
 #define RESOLVE_IN_ROOT		0x10 /* Make all jumps to "/" and ".."
 					be scoped inside the dirfd
 					(similar to chroot(2)). */
+#define RESOLVE_CACHED		0x20 /* Only complete if resolution can be
+					completed through cached lookup. May
+					return -EAGAIN if that's not
+					possible. */
 
 #endif /* _UAPI_LINUX_OPENAT2_H */



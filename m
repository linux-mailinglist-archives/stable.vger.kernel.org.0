Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5CD60486E
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbiJSN4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234146AbiJSNzQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:55:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8A817C55F;
        Wed, 19 Oct 2022 06:37:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38E79B82326;
        Wed, 19 Oct 2022 08:48:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E87C433C1;
        Wed, 19 Oct 2022 08:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169307;
        bh=gdVxvXTVsxzy2ljfw76jvEClmWnODYkAY5VxrKNgL8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uV7GoQ5kkpRe81u7hX9qWdRRVxsyu+X5A9zKz6ugVCuVeYdhY9wBcrnBccA/wRBX3
         DaspGzUd80ZhAmI9Rq4juO+6HMVzlVaCMUSEd+SKLMDlIxJIKnZLtgjiAz7tq043N8
         s25gUYWhNz1TALSDVpLCew1sdplCnBy0dAlwA+so=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 228/862] libbpf: Initialize err in probe_map_create
Date:   Wed, 19 Oct 2022 10:25:15 +0200
Message-Id: <20221019083300.143314598@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 3045f42a64324d339125a8a1a1763bb9e1e08300 ]

GCC-11 warns about the possibly unitialized err variable in
probe_map_create:

libbpf_probes.c: In function 'probe_map_create':
libbpf_probes.c:361:38: error: 'err' may be used uninitialized in this function [-Werror=maybe-uninitialized]
  361 |                 return fd < 0 && err == exp_err ? 1 : 0;
      |                                  ~~~~^~~~~~~~~~

Fixes: 878d8def0603 ("libbpf: Rework feature-probing APIs")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/20220801025109.1206633-1-f.fainelli@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf_probes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index 0b5398786bf3..6d495656f554 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -193,7 +193,7 @@ static int probe_map_create(enum bpf_map_type map_type)
 	LIBBPF_OPTS(bpf_map_create_opts, opts);
 	int key_size, value_size, max_entries;
 	__u32 btf_key_type_id = 0, btf_value_type_id = 0;
-	int fd = -1, btf_fd = -1, fd_inner = -1, exp_err = 0, err;
+	int fd = -1, btf_fd = -1, fd_inner = -1, exp_err = 0, err = 0;
 
 	key_size	= sizeof(__u32);
 	value_size	= sizeof(__u32);
-- 
2.35.1




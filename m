Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53DA56578D6
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233220AbiL1Oyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbiL1Oyt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:54:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00AD1F7
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:54:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 37264CE134E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E842C433EF;
        Wed, 28 Dec 2022 14:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239279;
        bh=hNVp5yNLIIWTp0g/JY/XAlmjdJHkSZBWr6BBAo3AxJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jlRkBtd2vDUcBpFifbg7VhUDiU/wWmRS9eKA0YuHVGPyxQlkVTetnPfJ2M59iLKJV
         jzT6zjU71MZLMq9RC/tF9jsUyElN0Ag2p1Ve7EP3+6J5zJdzEhYW/rRNF2118eUiY5
         pBi6Fw/zhKN21FTgy9zjW67He4rqn+Cda0X9SLfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Michael <fedora.dm0@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 196/731] libbpf: Fix uninitialized warning in btf_dump_dump_type_data
Date:   Wed, 28 Dec 2022 15:35:03 +0100
Message-Id: <20221228144302.240838791@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: David Michael <fedora.dm0@gmail.com>

[ Upstream commit dfd0afbf151d85411b371e841f62b81ee5d1ca54 ]

GCC 11.3.0 fails to compile btf_dump.c due to the following error,
which seems to originate in btf_dump_struct_data where the returned
value would be uninitialized if btf_vlen returns zero.

btf_dump.c: In function ‘btf_dump_dump_type_data’:
btf_dump.c:2363:12: error: ‘err’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
 2363 |         if (err < 0)
      |            ^

Fixes: 920d16af9b42 ("libbpf: BTF dumper support for typed data")
Signed-off-by: David Michael <fedora.dm0@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Alan Maguire <alan.maguire@oracle.com>
Link: https://lore.kernel.org/bpf/87zgcu60hq.fsf@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf_dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 9bcd75dc12cc..f620911ad3bb 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1915,7 +1915,7 @@ static int btf_dump_struct_data(struct btf_dump *d,
 {
 	const struct btf_member *m = btf_members(t);
 	__u16 n = btf_vlen(t);
-	int i, err;
+	int i, err = 0;
 
 	/* note that we increment depth before calling btf_dump_print() below;
 	 * this is intentional.  btf_dump_data_newline() will not print a
-- 
2.35.1




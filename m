Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED3D164E073
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 19:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiLOSOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 13:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbiLOSNb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 13:13:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1614A396F3
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 10:13:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12DFD61E59
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 18:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099C9C433EF;
        Thu, 15 Dec 2022 18:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671127998;
        bh=yAcrlxapSA193BaI+p6HvnTi2F1LTYMxaNUhWgnfKlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VzQ3q/W1K/mrOTbugA5m/2IHc4BOPnCXjgrZHymlIEBzytuZQbtaeNUS4ijfge96p
         04AugqL4AaFpP5/+cb7m6JRBi5eJwLKpzCwVDPf17EHb+buh3FyH8YVFWyp3julwGf
         WCv94/FNd8R6ynimAkPJS7cl1d4ovSo1Ivi4T1Hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Michael <fedora.dm0@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH 6.0 04/16] libbpf: Fix uninitialized warning in btf_dump_dump_type_data
Date:   Thu, 15 Dec 2022 19:10:48 +0100
Message-Id: <20221215172908.338365689@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221215172908.162858817@linuxfoundation.org>
References: <20221215172908.162858817@linuxfoundation.org>
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

commit dfd0afbf151d85411b371e841f62b81ee5d1ca54 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/lib/bpf/btf_dump.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1963,7 +1963,7 @@ static int btf_dump_struct_data(struct b
 {
 	const struct btf_member *m = btf_members(t);
 	__u16 n = btf_vlen(t);
-	int i, err;
+	int i, err = 0;
 
 	/* note that we increment depth before calling btf_dump_print() below;
 	 * this is intentional.  btf_dump_data_newline() will not print a



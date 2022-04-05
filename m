Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3D64F27C7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbiDEII4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235898AbiDEIAl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:00:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9844925A;
        Tue,  5 Apr 2022 00:58:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 275A9B81B16;
        Tue,  5 Apr 2022 07:58:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875D9C340EE;
        Tue,  5 Apr 2022 07:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145520;
        bh=jIcYDRqhOPQaS8NDwpkH/FdRN7CSfJSZNAAJHcEtsOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZS+y9HuSIZHfmHOszCzQbKTIiw/tc5UeqV9jeP33KwdFg3YQvgAPjtTisnJxXdy9Z
         fjne4SQvswtmZlFgXUoDvJdnd/Xgg9/Lb7vdwpc37++0IR87DWNv390nxZp2BvGJIn
         KgXZb4YTd2hJJrpBk5G3/lGd4s8aoEq5OdfjlokY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0436/1126] libbpf: Fix possible NULL pointer dereference when destroying skeleton
Date:   Tue,  5 Apr 2022 09:19:43 +0200
Message-Id: <20220405070420.421839289@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yafang Shao <laoar.shao@gmail.com>

[ Upstream commit a32ea51a3f17ce6524c9fc19d311e708331c8b5f ]

When I checked the code in skeleton header file generated with my own
bpf prog, I found there may be possible NULL pointer dereference when
destroying skeleton. Then I checked the in-tree bpf progs, finding that is
a common issue. Let's take the generated samples/bpf/xdp_redirect_cpu.skel.h
for example. Below is the generated code in
xdp_redirect_cpu__create_skeleton():

	xdp_redirect_cpu__create_skeleton
		struct bpf_object_skeleton *s;
		s = (struct bpf_object_skeleton *)calloc(1, sizeof(*s));
		if (!s)
			goto error;
		...
	error:
		bpf_object__destroy_skeleton(s);
		return  -ENOMEM;

After goto error, the NULL 's' will be deferenced in
bpf_object__destroy_skeleton().

We can simply fix this issue by just adding a NULL check in
bpf_object__destroy_skeleton().

Fixes: d66562fba1ce ("libbpf: Add BPF object skeleton support")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220108134739.32541-1-laoar.shao@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7f10dd501a52..fdb3536afa7d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -11795,6 +11795,9 @@ void bpf_object__detach_skeleton(struct bpf_object_skeleton *s)
 
 void bpf_object__destroy_skeleton(struct bpf_object_skeleton *s)
 {
+	if (!s)
+		return;
+
 	if (s->progs)
 		bpf_object__detach_skeleton(s);
 	if (s->obj)
-- 
2.34.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CBA4F36F6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240631AbiDELJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232972AbiDEJsi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFEB9285C;
        Tue,  5 Apr 2022 02:35:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47C35B81B75;
        Tue,  5 Apr 2022 09:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99996C385A2;
        Tue,  5 Apr 2022 09:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151355;
        bh=GltpdBVeULqUGpBO1nAxh639HFSQaoT6tOmZcNXQin4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aMi1m1bFpYsX3FR/wzkQdbKww6JeAYOoo6oi87k4NkgXLt/blrVPPLF86leV5MRQC
         w9LYo3bxBiFVbNDKBgPPFdl9wWmD5CNpFzID6uRYegFIfzvt7++0AVM2k5CkeJsHWH
         Y0tPnSSrOOFUTCDGYvX7e8tyYCoaBTMUEvMM8PME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Fu <fuweid89@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 386/913] bpftool: Only set obj->skeleton on complete success
Date:   Tue,  5 Apr 2022 09:24:08 +0200
Message-Id: <20220405070351.417249214@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Wei Fu <fuweid89@gmail.com>

[ Upstream commit 0991f6a38f576aa9a5e34713e23c998a3310d4d0 ]

After `bpftool gen skeleton`, the ${bpf_app}.skel.h will provide that
${bpf_app_name}__open helper to load bpf. If there is some error
like ENOMEM, the ${bpf_app_name}__open will rollback(free) the allocated
object, including `bpf_object_skeleton`.

Since the ${bpf_app_name}__create_skeleton set the obj->skeleton first
and not rollback it when error, it will cause double-free in
${bpf_app_name}__destory at ${bpf_app_name}__open. Therefore, we should
set the obj->skeleton before return 0;

Fixes: 5dc7a8b21144 ("bpftool, selftests/bpf: Embed object file inside skeleton")
Signed-off-by: Wei Fu <fuweid89@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220108084008.1053111-1-fuweid89@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/gen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index d40d92bbf0e4..07fa502a4ac1 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -870,7 +870,6 @@ static int do_skeleton(int argc, char **argv)
 			s = (struct bpf_object_skeleton *)calloc(1, sizeof(*s));\n\
 			if (!s)						    \n\
 				goto err;				    \n\
-			obj->skeleton = s;				    \n\
 									    \n\
 			s->sz = sizeof(*s);				    \n\
 			s->name = \"%1$s\";				    \n\
@@ -955,6 +954,7 @@ static int do_skeleton(int argc, char **argv)
 		\n\
 		\";							    \n\
 									    \n\
+			obj->skeleton = s;				    \n\
 			return 0;					    \n\
 		err:							    \n\
 			bpf_object__destroy_skeleton(s);		    \n\
-- 
2.34.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD3C53D097
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236740AbiFCSHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347900AbiFCSG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 14:06:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED905D5F8;
        Fri,  3 Jun 2022 10:59:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3D09B82189;
        Fri,  3 Jun 2022 17:59:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BAA8C385B8;
        Fri,  3 Jun 2022 17:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654279139;
        bh=jylEjt/kulbTS7GurMgB9K2xH/8vWaxgWIIDnWNp0L8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GFqMcWw0VZtKRFds+RBdbUt+Ny7HnlVKzxlunQ1Hqx3ZJyeXfjvkiqzl1WYHYrXYA
         2GPzqus93laXOFvQE094xrDxwd74Rks2JGPcgYIEXeNCsm/ECAkAbrXWTmsGIDtv3X
         XUDXGzwbRi/BHu8PMXHPO/6rpf9d2wSbLTFclxkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.18 65/67] bpf: Reject writes for PTR_TO_MAP_KEY in check_helper_mem_access
Date:   Fri,  3 Jun 2022 19:44:06 +0200
Message-Id: <20220603173822.586723850@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.731531504@linuxfoundation.org>
References: <20220603173820.731531504@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

commit 7b3552d3f9f6897851fc453b5131a967167e43c2 upstream.

It is not permitted to write to PTR_TO_MAP_KEY, but the current code in
check_helper_mem_access would allow for it, reject this case as well, as
helpers taking ARG_PTR_TO_UNINIT_MEM also take PTR_TO_MAP_KEY.

Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20220319080827.73251-4-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4861,6 +4861,11 @@ static int check_helper_mem_access(struc
 		return check_packet_access(env, regno, reg->off, access_size,
 					   zero_size_allowed);
 	case PTR_TO_MAP_KEY:
+		if (meta && meta->raw_mode) {
+			verbose(env, "R%d cannot write into %s\n", regno,
+				reg_type_str(env, reg->type));
+			return -EACCES;
+		}
 		return check_mem_region_access(env, regno, reg->off, access_size,
 					       reg->map_ptr->key_size, false);
 	case PTR_TO_MAP_VALUE:



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 722F8594770
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354071AbiHOXnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354288AbiHOXls (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E2DF5B1;
        Mon, 15 Aug 2022 13:11:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6C5960B9B;
        Mon, 15 Aug 2022 20:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41B6C433D6;
        Mon, 15 Aug 2022 20:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594299;
        bh=umu5Qdb7zS/cnY4uOR10gFUBOzmjDd7cXOrW7/1kgDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mQosnbe/+YJLiaoC4wq6go5MGrK7+uxXsUV6uYAzAJxpXJpYaRe5bAglI8p78viDG
         8jLs1/RERKnOEseqdFxXFJz8ZbEGnsctXlJLlJMK6dGQDwkj9tvY2cTPiX/Wbpvn91
         ml6WvvptAY7TurzYRqYy6YHt56ykGNIz5EPTq/fg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.18 1089/1095] bpf: Suppress passing zero to PTR_ERR warning
Date:   Mon, 15 Aug 2022 20:08:08 +0200
Message-Id: <20220815180514.073914895@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

commit 1ec5ee8c8a5a65ea377f8bea64bf4d5b743f6f79 upstream.

Kernel Test Robot complains about passing zero to PTR_ERR for the said
line, suppress it by using PTR_ERR_OR_ZERO.

Fixes: c0a5a21c25f3 ("bpf: Allow storing referenced kptr in map")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220521132620.1976921-1-memxor@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5327,7 +5327,7 @@ static int process_kptr_func(struct bpf_
 		return -EINVAL;
 	}
 	if (!map_value_has_kptrs(map_ptr)) {
-		ret = PTR_ERR(map_ptr->kptr_off_tab);
+		ret = PTR_ERR_OR_ZERO(map_ptr->kptr_off_tab);
 		if (ret == -E2BIG)
 			verbose(env, "map '%s' has more than %d kptr\n", map_ptr->name,
 				BPF_MAP_VALUE_OFF_MAX);



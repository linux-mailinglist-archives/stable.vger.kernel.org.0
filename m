Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D809065004D
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiLRQM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbiLRQMB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:12:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE40FDFA8;
        Sun, 18 Dec 2022 08:05:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F7DE60DCF;
        Sun, 18 Dec 2022 16:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D63C433EF;
        Sun, 18 Dec 2022 16:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379520;
        bh=RcIYVwf70pmzs7nidFY13OIN+AVbosDXuvB0Aa50h+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HyyU1G3CvoD6wGvpl7nTE9LRrZa0oUrkKrcnn7WgeqVhOwzNIABQ/X0WGvGYUL5IT
         D4EAm7/fhSrol+qYi97kCz9yUglsrfxy/LGQ5iICWz7ZpgSL/XSkpE/Kb5NbxRCkq5
         2PvDsmMlud2TZzlii2RA68jku1Jy7hPu1C6Ck2LrTV9GEfXp8JIY14f6SUVDi171yH
         qYuzCQMZ5W6RqyZDRRJNiOLSOZUCG4NKud5m/7BVhQcFhfNqjZ1smw56chmxIchzf6
         UPx1G/WVk9tN4423RVTg2z505iKgAUM7f2TTUBWtRz1ogmAoJYNTb0zXm284F5uz9C
         UNRekYJ8Afa/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yonghong Song <yhs@fb.com>, kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 55/85] bpf: Fix a BTF_ID_LIST bug with CONFIG_DEBUG_INFO_BTF not set
Date:   Sun, 18 Dec 2022 11:01:12 -0500
Message-Id: <20221218160142.925394-55-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160142.925394-1-sashal@kernel.org>
References: <20221218160142.925394-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit beb3d47d1d3d7185bb401af628ad32ee204a9526 ]

With CONFIG_DEBUG_INFO_BTF not set, we hit the following compilation error,
  /.../kernel/bpf/verifier.c:8196:23: error: array index 6 is past the end of the array
  (that has type 'u32[5]' (aka 'unsigned int[5]')) [-Werror,-Warray-bounds]
        if (meta->func_id == special_kfunc_list[KF_bpf_cast_to_kern_ctx])
                             ^                  ~~~~~~~~~~~~~~~~~~~~~~~
  /.../kernel/bpf/verifier.c:8174:1: note: array 'special_kfunc_list' declared here
  BTF_ID_LIST(special_kfunc_list)
  ^
  /.../include/linux/btf_ids.h:207:27: note: expanded from macro 'BTF_ID_LIST'
  #define BTF_ID_LIST(name) static u32 __maybe_unused name[5];
                            ^
  /.../kernel/bpf/verifier.c:8443:19: error: array index 5 is past the end of the array
  (that has type 'u32[5]' (aka 'unsigned int[5]')) [-Werror,-Warray-bounds]
                 btf_id == special_kfunc_list[KF_bpf_list_pop_back];
                           ^                  ~~~~~~~~~~~~~~~~~~~~
  /.../kernel/bpf/verifier.c:8174:1: note: array 'special_kfunc_list' declared here
  BTF_ID_LIST(special_kfunc_list)
  ^
  /.../include/linux/btf_ids.h:207:27: note: expanded from macro 'BTF_ID_LIST'
  #define BTF_ID_LIST(name) static u32 __maybe_unused name[5];
  ...

Fix the problem by increase the size of BTF_ID_LIST to 16 to avoid compilation error
and also prevent potentially unintended issue due to out-of-bound access.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/r/20221123155759.2669749-1-yhs@fb.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/btf_ids.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
index 2aea877d644f..2b9872008428 100644
--- a/include/linux/btf_ids.h
+++ b/include/linux/btf_ids.h
@@ -204,7 +204,7 @@ extern struct btf_id_set8 name;
 
 #else
 
-#define BTF_ID_LIST(name) static u32 __maybe_unused name[5];
+#define BTF_ID_LIST(name) static u32 __maybe_unused name[16];
 #define BTF_ID(prefix, name)
 #define BTF_ID_FLAGS(prefix, name, ...)
 #define BTF_ID_UNUSED
-- 
2.35.1


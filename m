Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45AFA658473
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbiL1Q5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235343AbiL1Q4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:56:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7431C929
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:51:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FC9FB816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F52DC433D2;
        Wed, 28 Dec 2022 16:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246311;
        bh=RcIYVwf70pmzs7nidFY13OIN+AVbosDXuvB0Aa50h+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ikAMD4j91fzuET8TOCf6QOxPs89hXFrZQQYP2bdL2VmuNJ5J2qahL3/FVzGDRY1oE
         wqx9LmXC0LcZoAHIfxVgeCx2CS1MG5BMFVPNuw8r+n7A9hoLb2tLPY+4W03IZyVFX2
         wr0fyOK6yV01+6xs2arcCzfIwhpsF4ng0MDHuMpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1019/1146] bpf: Fix a BTF_ID_LIST bug with CONFIG_DEBUG_INFO_BTF not set
Date:   Wed, 28 Dec 2022 15:42:38 +0100
Message-Id: <20221228144358.044387536@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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




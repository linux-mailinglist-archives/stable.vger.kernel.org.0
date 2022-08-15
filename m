Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A44C5947E0
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345246AbiHOXnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354283AbiHOXlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244CAB86B;
        Mon, 15 Aug 2022 13:11:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4ED06077B;
        Mon, 15 Aug 2022 20:11:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA20AC433C1;
        Mon, 15 Aug 2022 20:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594293;
        bh=m6tmQ3fcvqEazC3ml2tP0P8yC/apYVAOn4jfufH1sJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tjp8GdQThCTq0OsWotrGBEoZ04KsIiLE2Ewu0rqN3H/W8P5QyUnvAEuRnCm6IrYMe
         3gRCJ/sg+ox56h2cT3F96k2BowJMq83KkGn+GSck2+5lnVL9bLspwswb2VNA/lyCrU
         bL4Wm/s1IKa05iU3GlVAJQqxmQdRDVExW4vYPcAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.18 1088/1095] bpf: Fix sparse warning for bpf_kptr_xchg_proto
Date:   Mon, 15 Aug 2022 20:08:07 +0200
Message-Id: <20220815180514.042329632@linuxfoundation.org>
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

commit 5b74c690e1c55953ec99fd9dab74f72dbee4fe95 upstream.

Kernel Test Robot complained about missing static storage class
annotation for bpf_kptr_xchg_proto variable.

sparse: symbol 'bpf_kptr_xchg_proto' was not declared. Should it be static?

This caused by missing extern definition in the header. Add it to
suppress the sparse warning.

Fixes: c0a5a21c25f3 ("bpf: Allow storing referenced kptr in map")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20220511194654.765705-2-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2228,6 +2228,7 @@ extern const struct bpf_func_proto bpf_f
 extern const struct bpf_func_proto bpf_loop_proto;
 extern const struct bpf_func_proto bpf_strncmp_proto;
 extern const struct bpf_func_proto bpf_copy_from_user_task_proto;
+extern const struct bpf_func_proto bpf_kptr_xchg_proto;
 
 const struct bpf_func_proto *tracing_prog_func_proto(
   enum bpf_func_id func_id, const struct bpf_prog *prog);



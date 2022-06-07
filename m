Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E15AD540A64
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351731AbiFGSUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352848AbiFGSRi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:17:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED62E13F1E3;
        Tue,  7 Jun 2022 10:52:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18ED3617B2;
        Tue,  7 Jun 2022 17:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237D6C34115;
        Tue,  7 Jun 2022 17:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624363;
        bh=2dfON6Y6ocWRPqByUQw4PeL4NX+VEfRC9VTCbKNrOqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SNTl0MOBzjSDhUun9iiIVhpchnJQMG5CrSl/tL9AdC9tkRo1M7RVAsJvSz9T1veJ8
         FuYcxDluaT8LbhozkgE9gmfyJD778yg4msZ5agVVZlXODXY2bodcOdxukoytJZ4RLd
         JpCiIM/7yT1fmyO5OfeNZD84PWtSSLyWLUha2BnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, CKI Project <cki-project@redhat.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 299/667] samples: bpf: Dont fail for a missing VMLINUX_BTF when VMLINUX_H is provided
Date:   Tue,  7 Jun 2022 18:59:24 +0200
Message-Id: <20220607164943.745928702@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Marchand <jmarchan@redhat.com>

[ Upstream commit ec24704492d8791a52a75a39e3ad762b6e017bc6 ]

samples/bpf build currently always fails if it can't generate
vmlinux.h from vmlinux, even when vmlinux.h is directly provided by
VMLINUX_H variable, which makes VMLINUX_H pointless.
Only fails when neither method works.

Fixes: 384b6b3bbf0d ("samples: bpf: Add vmlinux.h generation support")
Reported-by: CKI Project <cki-project@redhat.com>
Reported-by: Veronika Kabatova <vkabatov@redhat.com>
Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220507161635.2219052-1-jmarchan@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/Makefile | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index c6e38e43c3fd..e2c9ea65df9f 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -365,16 +365,15 @@ VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
 
 $(obj)/vmlinux.h: $(VMLINUX_BTF) $(BPFTOOL)
 ifeq ($(VMLINUX_H),)
+ifeq ($(VMLINUX_BTF),)
+	$(error Cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)",\
+		build the kernel or set VMLINUX_BTF or VMLINUX_H variable)
+endif
 	$(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
 else
 	$(Q)cp "$(VMLINUX_H)" $@
 endif
 
-ifeq ($(VMLINUX_BTF),)
-	$(error Cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)",\
-		build the kernel or set VMLINUX_BTF variable)
-endif
-
 clean-files += vmlinux.h
 
 # Get Clang's default includes on this system, as opposed to those seen by
-- 
2.35.1




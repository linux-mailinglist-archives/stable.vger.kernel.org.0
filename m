Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D19C46BB0A8
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbjCOMU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbjCOMTz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:19:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45008227A2
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:19:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 682D4B81DFE
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6231C433EF;
        Wed, 15 Mar 2023 12:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882780;
        bh=rhxdufBm4e5kulz1JA4K+9qV2V4DEANXj5Xbx4cjepw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UotgbFyTS5+tT1dYpTP0Q7vjC+O7v4Dxy94KXL7d0MtvU5A7KHjxsSx/s1CXvahB+
         LlpO/Jx7SJt8CeFxJ1Lqytm3FIrpv+XY03wIMTL7Zy8bqtONgQ1kmJ89fYaTzYKFl2
         jISBSp6wNgToNPEitESQsULdRIdd2VNY5ZvWvr/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, SeongJae Park <sj@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.4 67/68] UML: define RUNTIME_DISCARD_EXIT
Date:   Wed, 15 Mar 2023 13:13:01 +0100
Message-Id: <20230315115728.732890091@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit b99ddbe8336ee680257c8ab479f75051eaa49dcf upstream.

With CONFIG_VIRTIO_UML=y, GNU ld < 2.36 fails to link UML vmlinux
(w/wo CONFIG_LD_SCRIPT_STATIC).

  `.exit.text' referenced in section `.uml.exitcall.exit' of arch/um/drivers/virtio_uml.o: defined in discarded section `.exit.text' of arch/um/drivers/virtio_uml.o
  collect2: error: ld returned 1 exit status

This fix is similar to the following commits:

- 4b9880dbf3bd ("powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT")
- a494398bde27 ("s390: define RUNTIME_DISCARD_EXIT to fix link error
  with GNU ld < 2.36")
- c1c551bebf92 ("sh: define RUNTIME_DISCARD_EXIT")

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Reported-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Tested-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/kernel/vmlinux.lds.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/um/kernel/vmlinux.lds.S
+++ b/arch/um/kernel/vmlinux.lds.S
@@ -1,4 +1,4 @@
-
+#define RUNTIME_DISCARD_EXIT
 KERNEL_STACK_SIZE = 4096 * (1 << CONFIG_KERNEL_STACK_ORDER);
 
 #ifdef CONFIG_LD_SCRIPT_STATIC



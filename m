Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091A06BB1F7
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbjCOMbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbjCOMbg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:31:36 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2310D8E3E7
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:30:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 65D55CE19BC
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:30:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73633C433EF;
        Wed, 15 Mar 2023 12:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883449;
        bh=rhxdufBm4e5kulz1JA4K+9qV2V4DEANXj5Xbx4cjepw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fKpBn3eD11NT/Yn38FqUcDYwOi7jrSADzBXG6j2GL25USMunRPZb/16mB5Ebda3Hl
         bTFWKWUNiNB3Se7FbxvX59aZpKXmcK9cZo/35SXIdYUgOnJRifgXCMU82aJG7Gw76e
         UpPaI+wXZc/3TnLLtjCGZ0YnF3J0/FkFW1xy2VJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, SeongJae Park <sj@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.15 141/145] UML: define RUNTIME_DISCARD_EXIT
Date:   Wed, 15 Mar 2023 13:13:27 +0100
Message-Id: <20230315115743.566373205@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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



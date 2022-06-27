Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C37D55DA7E
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238783AbiF0Lya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238712AbiF0Lwb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:52:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5149AE73;
        Mon, 27 Jun 2022 04:45:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A1CFB80D32;
        Mon, 27 Jun 2022 11:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41B3C3411D;
        Mon, 27 Jun 2022 11:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330312;
        bh=NSWLVHwkh4jCm7vqeyoTxm57tQ+lbvd9SSss7VBhs+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xh855Mu3NpfH5iD+dMOwiIefW6j4sdfqW54zrxoMWV6WIRGr9cxjNwrkxZ0LJNbid
         1CtFpzA6+oT0XPuQkI5jk+KL/wwfu8V35UWmNNokIvyzjdX7g7mVCZjzjBICQuCXk7
         rixyiNKOeAAB5wBn6PX4Im8fzkDb/EsHJKNbwIq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        John David Anglin <dave.anglin@bell.net>
Subject: [PATCH 5.18 155/181] parisc: Enable ARCH_HAS_STRICT_MODULE_RWX
Date:   Mon, 27 Jun 2022 13:22:08 +0200
Message-Id: <20220627111949.177477255@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 0a1355db36718178becd2bfe728a023933d73123 upstream.

Fix a boot crash on a c8000 machine as reported by Dave.  Basically it changes
patch_map() to return an alias mapping to the to-be-patched code in order to
prevent writing to write-protected memory.

Signed-off-by: Helge Deller <deller@gmx.de>
Suggested-by: John David Anglin <dave.anglin@bell.net>
Cc: stable@vger.kernel.org   # v5.2+
Link: https://lore.kernel.org/all/e8ec39e8-25f8-e6b4-b7ed-4cb23efc756e@bell.net/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -10,6 +10,7 @@ config PARISC
 	select ARCH_WANT_FRAME_POINTERS
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_STRICT_KERNEL_RWX
+	select ARCH_HAS_STRICT_MODULE_RWX
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_NO_SG_CHAIN



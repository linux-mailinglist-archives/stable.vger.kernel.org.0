Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9982E566DA9
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236524AbiGEM0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236519AbiGEMYw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:24:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C2B1F60F;
        Tue,  5 Jul 2022 05:17:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 406E2619E2;
        Tue,  5 Jul 2022 12:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423BEC341C7;
        Tue,  5 Jul 2022 12:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023438;
        bh=i0CGAAs5eqYu9dCjxaqX8R2K+gUYhSz8F47FXguxCYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uHE79lSByMDoSRKarykBgVve8zjsoszSpmRt1YTOBuXlSV9KulZkZniAAUa1B2Uf6
         9SEB1mhDmJeFLGxU93DTzzPWuvOTfNsAjGy/RK1XgWn++Vrgfeo5y6ndIV+OCOmYsM
         OnsMlKTJtQm2QTTdhmAFeGY93bK0dO/3aJOl5DVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coleman Dietsch <dietschc@csp.edu>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.18 060/102] selftests net: fix kselftest net fatal error
Date:   Tue,  5 Jul 2022 13:58:26 +0200
Message-Id: <20220705115620.110554978@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coleman Dietsch <dietschc@csp.edu>

commit 7b92aa9e613508cbaa29dd35bf27db4c35628b10 upstream.

The incorrect path is causing the following error when trying to run net
kselftests:

In file included from bpf/nat6to4.c:43:
../../../lib/bpf/bpf_helpers.h:11:10: fatal error: 'bpf_helper_defs.h' file not found
         ^~~~~~~~~~~~~~~~~~~
1 error generated.

Fixes: cf67838c4422 ("selftests net: fix bpf build error")
Signed-off-by: Coleman Dietsch <dietschc@csp.edu>
Link: https://lore.kernel.org/r/20220628174744.7908-1-dietschc@csp.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/bpf/Makefile b/tools/testing/selftests/net/bpf/Makefile
index 8a69c91fcca0..8ccaf8732eb2 100644
--- a/tools/testing/selftests/net/bpf/Makefile
+++ b/tools/testing/selftests/net/bpf/Makefile
@@ -2,7 +2,7 @@
 
 CLANG ?= clang
 CCINCLUDE += -I../../bpf
-CCINCLUDE += -I../../../lib
+CCINCLUDE += -I../../../../lib
 CCINCLUDE += -I../../../../../usr/include/
 
 TEST_CUSTOM_PROGS = $(OUTPUT)/bpf/nat6to4.o
-- 
2.37.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3144D658284
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiL1Qhf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234961AbiL1Qge (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:36:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0C519C0C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:32:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD410B8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F72DC433EF;
        Wed, 28 Dec 2022 16:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245175;
        bh=AfvHtbMwYDOMVDXunr4Q9QQh8V5hKEEPkEHGOfW1KAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pFpglaPalpngK9+++WdpH5v/nPyw5sdqqRK2ZXeTmbSqXQK+FhWPZDuY4HEE6HvY1
         msRUiWCieYzSCH0kpo70NNv5bcNVels3n1LQ/mw5XZC6xn+6PX9/cp5fOZc3/U8vS2
         ccM3ERs83loBXnFFqSYIhFOV0v16WIjgJzGSNjeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Daniel=20M=C3=BCller?= <deso@posteo.net>,
        Song Liu <song@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0845/1073] selftests/bpf: Select CONFIG_FUNCTION_ERROR_INJECTION
Date:   Wed, 28 Dec 2022 15:40:33 +0100
Message-Id: <20221228144350.973778252@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Song Liu <song@kernel.org>

[ Upstream commit a8dfde09c90109e3a98af54847e91bde7dc2d5c2 ]

BPF selftests require CONFIG_FUNCTION_ERROR_INJECTION to work. However,
CONFIG_FUNCTION_ERROR_INJECTION is no longer 'y' by default after recent
changes. As a result, we are seeing errors like the following from BPF CI:

   bpf_testmod_test_read() is not modifiable
   __x64_sys_setdomainname is not sleepable
   __x64_sys_getpgid is not sleepable

Fix this by explicitly selecting CONFIG_FUNCTION_ERROR_INJECTION in the
selftest config.

Fixes: a4412fdd49dc ("error-injection: Add prompt for function error injection")
Reported-by: Daniel Müller <deso@posteo.net>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Daniel Müller <deso@posteo.net>
Link: https://lore.kernel.org/bpf/20221213220500.3427947-1-song@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index fabf0c014349..c5c5fc2a3ce7 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -13,6 +13,7 @@ CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_DYNAMIC_FTRACE=y
 CONFIG_FPROBE=y
 CONFIG_FTRACE_SYSCALLS=y
+CONFIG_FUNCTION_ERROR_INJECTION=y
 CONFIG_FUNCTION_TRACER=y
 CONFIG_GENEVE=y
 CONFIG_IKCONFIG=y
-- 
2.35.1




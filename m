Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB59608924
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233814AbiJVIb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234036AbiJVI3Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:29:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901332E32C5;
        Sat, 22 Oct 2022 01:01:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C1D160B93;
        Sat, 22 Oct 2022 08:01:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CBEC433D6;
        Sat, 22 Oct 2022 08:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425704;
        bh=xHizhrsgBaS+HGjRTXe73ubCJjvU4dsr7/rdK0W9Avo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FFx8wThX1/d2kZqgSdnxizQOOakDqpUtoHaWImx3+/0fKHA+GFux5ms2O7Nb9XlmS
         6er+j9T/oPcEJtgbk1qSNx3iPNr9rj52AXRNZLw4qgjsACPSvsaCYxrZ5Z8zMtg0mG
         N4tzSphH2EVUxAZQCbKGJMzsYr93nQFzuZD0S6Y0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 558/717] bpftool: Clear errno after libcaps checks
Date:   Sat, 22 Oct 2022 09:27:17 +0200
Message-Id: <20221022072523.061685952@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Monnet <quentin@isovalent.com>

[ Upstream commit cea558855c39b7f1f02ff50dcf701ca6596bc964 ]

When bpftool is linked against libcap, the library runs a "constructor"
function to compute the number of capabilities of the running kernel
[0], at the beginning of the execution of the program. As part of this,
it performs multiple calls to prctl(). Some of these may fail, and set
errno to a non-zero value:

    # strace -e prctl ./bpftool version
    prctl(PR_CAPBSET_READ, CAP_MAC_OVERRIDE) = 1
    prctl(PR_CAPBSET_READ, 0x30 /* CAP_??? */) = -1 EINVAL (Invalid argument)
    prctl(PR_CAPBSET_READ, CAP_CHECKPOINT_RESTORE) = 1
    prctl(PR_CAPBSET_READ, 0x2c /* CAP_??? */) = -1 EINVAL (Invalid argument)
    prctl(PR_CAPBSET_READ, 0x2a /* CAP_??? */) = -1 EINVAL (Invalid argument)
    prctl(PR_CAPBSET_READ, 0x29 /* CAP_??? */) = -1 EINVAL (Invalid argument)
    ** fprintf added at the top of main(): we have errno == 1
    ./bpftool v7.0.0
    using libbpf v1.0
    features: libbfd, libbpf_strict, skeletons
    +++ exited with 0 +++

This has been addressed in libcap 2.63 [1], but until this version is
available everywhere, we can fix it on bpftool side.

Let's clean errno at the beginning of the main() function, to make sure
that these checks do not interfere with the batch mode, where we error
out if errno is set after a bpftool command.

  [0] https://git.kernel.org/pub/scm/libs/libcap/libcap.git/tree/libcap/cap_alloc.c?h=libcap-2.65#n20
  [1] https://git.kernel.org/pub/scm/libs/libcap/libcap.git/commit/?id=f25a1b7e69f7b33e6afb58b3e38f3450b7d2d9a0

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220815162205.45043-1-quentin@isovalent.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 9062ef2b8767..0881437587ba 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -435,6 +435,16 @@ int main(int argc, char **argv)
 
 	setlinebuf(stdout);
 
+#ifdef USE_LIBCAP
+	/* Libcap < 2.63 hooks before main() to compute the number of
+	 * capabilities of the running kernel, and doing so it calls prctl()
+	 * which may fail and set errno to non-zero.
+	 * Let's reset errno to make sure this does not interfere with the
+	 * batch mode.
+	 */
+	errno = 0;
+#endif
+
 	last_do_help = do_help;
 	pretty_output = false;
 	json_output = false;
-- 
2.35.1




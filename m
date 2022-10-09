Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3716C5F913C
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 00:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbiJIWa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 18:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232525AbiJIW3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 18:29:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F453ECC9;
        Sun,  9 Oct 2022 15:19:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18FD360C2B;
        Sun,  9 Oct 2022 22:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DBFC4347C;
        Sun,  9 Oct 2022 22:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353962;
        bh=wptZSXMfTHCS8yg64d9eFyNTCBSG3MYIcBN8bHhvfOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JMVHobl8W0gj3BNfwohlAMRB5XXXapxe+LPpYlIP++OhAb5rn8Qzfcq6pHTMHd62u
         FPnSjiCy1aAfC9ZRGDWOGODc/evt/cIdNSSjNJBN4VAwd7TRFTuMcD1tqFwgxHLAHk
         ckvXDuhGX89JydPf+qochcsKdJjqQuTK7bRtjOq+rP9b2knhG1KLeVecmpiDnAfKqc
         Ch1ZXL3NCCSuRsUeQy5ApMwrCjCsfil823nNzSvqCxOGB+LzTSB9NDux0f7UNeipgF
         VRPh6f2hCelqGJMNZG+KQ/4I6Hgq4ME5y1k0DbrCxbU6f+OKgA/wwnTZAaR2D38aW/
         AUilRAdPzag6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quentin Monnet <quentin@isovalent.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        andrii@kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 03/46] bpftool: Clear errno after libcap's checks
Date:   Sun,  9 Oct 2022 18:18:28 -0400
Message-Id: <20221009221912.1217372-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221912.1217372-1-sashal@kernel.org>
References: <20221009221912.1217372-1-sashal@kernel.org>
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
index d27ec4f852bb..b70c023f3a57 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -404,6 +404,16 @@ int main(int argc, char **argv)
 
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


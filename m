Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56D7B4B2CF4
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 19:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344627AbiBKS0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 13:26:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbiBKS0R (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 13:26:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B699BC;
        Fri, 11 Feb 2022 10:26:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25BE4B82B96;
        Fri, 11 Feb 2022 18:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B562CC340ED;
        Fri, 11 Feb 2022 18:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644603972;
        bh=vfmncepaPypMZwfR1mG4BAkP3b+DbtouCdTpVJ1JAdw=;
        h=Date:To:From:Subject:From;
        b=Rn8A5R4fN1OoZDfRosZghS18nykfx1x8vdF0dJDkIaPNVDzITRzI2pfJqejQMZWEf
         bq8Sk+A8EoV7ZybKwgOYx/XkudyqPO1emJi0YO0i7C7srmECNa9qVYQ4flQ19oLy7a
         yhPZd5b6Y8gI3jhjQWYWD3xjrYcjfPNlu4dLzwfU=
Date:   Fri, 11 Feb 2022 10:26:12 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        skhan@linuxfoundation.org, keescook@chromium.org,
        ebiederm@xmission.com, bot@kernelci.org, usama.anjum@collabora.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-exec-add-non-regular-to-test_gen_progs.patch added to -mm tree
Message-Id: <20220211182612.B562CC340ED@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: selftests/exec: add non-regular to TEST_GEN_PROGS
has been added to the -mm tree.  Its filename is
     selftests-exec-add-non-regular-to-test_gen_progs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-exec-add-non-regular-to-test_gen_progs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-exec-add-non-regular-to-test_gen_progs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/exec: add non-regular to TEST_GEN_PROGS

non-regular file needs to be compiled and then copied to the output
directory.  Remove it from TEST_PROGS and add it to TEST_GEN_PROGS.  This
removes error thrown by rsync when non-regular object isn't found:

rsync: [sender] link_stat "/linux/tools/testing/selftests/exec/non-regular" failed: No such file or directory (2)
rsync error: some files/attrs were not transferred (see previous errors) (code 23) at main.c(1333) [sender=3.2.3]

Link: https://lkml.kernel.org/r/20220210171323.1304501-1-usama.anjum@collabora.com
Fixes: 0f71241a8e32 ("selftests/exec: add file type errno tests")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/tools/testing/selftests/exec/Makefile~selftests-exec-add-non-regular-to-test_gen_progs
+++ a/tools/testing/selftests/exec/Makefile
@@ -3,8 +3,8 @@ CFLAGS = -Wall
 CFLAGS += -Wno-nonnull
 CFLAGS += -D_GNU_SOURCE
 
-TEST_PROGS := binfmt_script non-regular
-TEST_GEN_PROGS := execveat load_address_4096 load_address_2097152 load_address_16777216
+TEST_PROGS := binfmt_script
+TEST_GEN_PROGS := execveat load_address_4096 load_address_2097152 load_address_16777216 non-regular
 TEST_GEN_FILES := execveat.symlink execveat.denatured script subdir
 # Makefile is a run-time dependency, since it's accessed by the execveat test
 TEST_FILES := Makefile
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-exec-add-non-regular-to-test_gen_progs.patch
selftests-set-the-build-variable-to-absolute-path.patch
selftests-add-and-export-a-kernel-uapi-headers-path.patch
selftests-correct-the-headers-install-path.patch
selftests-futex-add-the-uapi-headers-include-variable.patch
selftests-kvm-add-the-uapi-headers-include-variable.patch
selftests-landlock-add-the-uapi-headers-include-variable.patch
selftests-net-add-the-uapi-headers-include-variable.patch
selftests-mptcp-add-the-uapi-headers-include-variable.patch
selftests-vm-add-the-uapi-headers-include-variable.patch
selftests-vm-remove-dependecy-from-internal-kernel-macros.patch


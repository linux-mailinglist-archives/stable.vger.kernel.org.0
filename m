Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD24623E11
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 09:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiKJI4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 03:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKJI4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 03:56:33 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B4822712;
        Thu, 10 Nov 2022 00:56:33 -0800 (PST)
Received: from neptune.. (ip5f592f1a.dynamic.kabel-deutschland.de [95.89.47.26])
        by linux.microsoft.com (Postfix) with ESMTPSA id 873A020B9F82;
        Thu, 10 Nov 2022 00:56:28 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 873A020B9F82
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1668070592;
        bh=FfwmxhJsqtLTs81LcrV/J5ZY7FFwpESRhNnkwiisl/Y=;
        h=From:To:Cc:Subject:Date:From;
        b=ASU5gzioz7duIB56Z+ZepUBZYU4SnHLT1N0QElDWZFrrHMdsO1k1T6Xl9GihG8m4h
         +abCRVXzcNuy/sVfGNqeqWdTNy/MH26T+6xBmzaRNI08cit53MP42skVGp+bYRCXdu
         vGS5DAGCIRs/AbW1PISvXBuodOGQEJNB9Ny1+dMc=
From:   Alban Crequy <albancrequy@linux.microsoft.com>
To:     bpf@vger.kernel.org
Cc:     stable@vger.kernel.org, albancrequy@linux.microsoft.com,
        flaniel@linux.microsoft.com, akpm@linux-foundation.org,
        andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        haoluo@google.com, john.fastabend@gmail.com, jolsa@kernel.org,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
        martin.lau@linux.dev, mykolal@fb.com, sdf@google.com,
        shuah@kernel.org, song@kernel.org, yhs@fb.com
Subject: [PATCH bpf v2 0/2] Fix offset when fault occurs in strncpy_from_kernel_nofault()
Date:   Thu, 10 Nov 2022 09:56:12 +0100
Message-Id: <20221110085614.111213-1-albancrequy@linux.microsoft.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

This is v2 of the fix & selftest previously sent at:
https://lore.kernel.org/linux-mm/20221108195211.214025-1-flaniel@linux.microsoft.com/

Changes v1 to v2:
- add 'cc:stable', 'Fixes:' and review/ack tags
- update commitmsg and fix my email
- rebase on bpf tree and tag for bpf tree

Thanks!


Alban Crequy (2):
  maccess: fix writing offset in case of fault in
    strncpy_from_kernel_nofault()
  selftests: bpf: add a test when bpf_probe_read_kernel_str() returns
    EFAULT

 mm/maccess.c                                    | 2 +-
 tools/testing/selftests/bpf/prog_tests/varlen.c | 7 +++++++
 tools/testing/selftests/bpf/progs/test_varlen.c | 5 +++++
 3 files changed, 13 insertions(+), 1 deletion(-)

-- 
2.36.1


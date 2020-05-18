Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309CC1D84D8
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732097AbgERR7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:59:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732095AbgERR7k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:59:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2A34207C4;
        Mon, 18 May 2020 17:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824779;
        bh=2LASOvTvTrONAR+ocAmH7QR9a1jeIKG1nWnEI8PmZrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZK8bCoMYUYjZz7jrHkLDS61A8EEP740NC0C3VULUxfFqUpM5Z2dtofI29v5OfLy2p
         2Wsce7P1Xa3npHP3EjqYACb1efr9iwfz/1wPJLZ42ksCgTYUe/tAQyGx76DlJdUkYJ
         Irsje9wTiP86n1szph4pDSVfXgVZJbe9tER9McrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 5.4 147/147] bpf: Test_progs, fix test_get_stack_rawtp_err.c build
Date:   Mon, 18 May 2020 19:37:50 +0200
Message-Id: <20200518173531.196702589@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Mostafa <kamal@canonical.com>

The linux-5.4.y commit 8781011a302b ("bpf: Test_progs, add test to catch
retval refine error handling") fails to build when libbpf headers are
not installed, as it tries to include <bpf/bpf_helpers.h>:

  progs/test_get_stack_rawtp_err.c:4:10:
      fatal error: 'bpf/bpf_helpers.h' file not found

For 5.4-stable (only) the new test prog needs to include "bpf_helpers.h"
instead (like all the rest of progs/*.c do) because 5.4-stable does not
carry commit e01a75c15969 ("libbpf: Move bpf_{helpers, helper_defs,
endian, tracing}.h into libbpf").

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Fixes: 8781011a302b ("bpf: Test_progs, add test to catch retval refine error handling")
Cc: <stable@vger.kernel.org> # v5.4
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/bpf/progs/test_get_stack_rawtp_err.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp_err.c
+++ b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp_err.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/bpf.h>
-#include <bpf/bpf_helpers.h>
+#include "bpf_helpers.h"
 
 #define MAX_STACK_RAWTP 10
 



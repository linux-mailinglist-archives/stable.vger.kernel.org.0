Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC6B21579F0
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729443AbgBJNTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:19:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:60254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728911AbgBJMhs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:48 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00AC624683;
        Mon, 10 Feb 2020 12:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338268;
        bh=StvTK6+608Rc+mF19RXGksdZ5Delha5xSdGRrD8cACo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NAJmlHQEBksI2m2kDlxiLzl61NeFwwL1liwvMlNDmRWmgWkG8hq9ucU/TYpruZK9m
         RV8pbligQvenAcz00/pRDnhJ9hGRlIfpqa26rh8jeapWk4CPMBa4CQjRWO0sCCVxPC
         N7PzXWa0RLhZ3LltBJkwVrtecMFE+xpk8ssc/2dY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 148/309] tc-testing: fix eBPF tests failure on linux fresh clones
Date:   Mon, 10 Feb 2020 04:31:44 -0800
Message-Id: <20200210122420.534926962@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

commit 7145fcfffef1fad4266aaf5ca96727696916edb7 upstream.

when the following command is done on a fresh clone of the kernel tree,

 [root@f31 tc-testing]# ./tdc.py -c bpf

test cases that need to build the eBPF sample program fail systematically,
because 'buildebpfPlugin' is unable to install the kernel headers (i.e, the
'khdr' target fails). Pass the correct environment to 'make', in place of
ENVIR, to allow running these tests.

Fixes: 4c2d39bd40c1 ("tc-testing: use a plugin to build eBPF program")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/tc-testing/plugin-lib/buildebpfPlugin.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/tc-testing/plugin-lib/buildebpfPlugin.py
+++ b/tools/testing/selftests/tc-testing/plugin-lib/buildebpfPlugin.py
@@ -54,7 +54,7 @@ class SubPlugin(TdcPlugin):
             shell=True,
             stdout=subprocess.PIPE,
             stderr=subprocess.PIPE,
-            env=ENVIR)
+            env=os.environ.copy())
         (rawout, serr) = proc.communicate()
 
         if proc.returncode != 0 and len(serr) > 0:



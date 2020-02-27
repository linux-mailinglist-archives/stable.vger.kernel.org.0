Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74B5F171E02
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388395AbgB0OMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:12:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:51140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387880AbgB0OM2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:12:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAD6620578;
        Thu, 27 Feb 2020 14:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812747;
        bh=FIgjdj1w7IAWYyZl/p9F1x2kOjAClWaNTPRGjZiUd8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HNJCvjtACoqSajzFObHDdBi4klgGPmnjXNGBkM2xEnzqka7ZWyRxQE5Dk/2WpOeFf
         3mn/phUsOLdHbSJWh/3y229mROnPGdKTuEK0Jkg81sP1MTngaU+CTMWNyZ5HqFr3/D
         JUbbXe7xbti5AxVPv1NrX//WKOKazuYNVQ6TpTMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [PATCH 5.4 135/135] bpf: Selftests build error in sockmap_basic.c
Date:   Thu, 27 Feb 2020 14:37:55 +0100
Message-Id: <20200227132249.294203802@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

commit f2e97dc126b712c0d21219ed0c42710006c1cf52 upstream.

Fix following build error. We could push a tcp.h header into one of the
include paths, but I think its easy enough to simply pull in the three
defines we need here. If we end up using more of tcp.h at some point
we can pull it in later.

/home/john/git/bpf/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c: In function ‘connected_socket_v4’:
/home/john/git/bpf/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c:20:11: error: ‘TCP_REPAIR_ON’ undeclared (first use in this function)
  repair = TCP_REPAIR_ON;
           ^
/home/john/git/bpf/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c:20:11: note: each undeclared identifier is reported only once for each function it appears in
/home/john/git/bpf/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c:29:11: error: ‘TCP_REPAIR_OFF_NO_WP’ undeclared (first use in this function)
  repair = TCP_REPAIR_OFF_NO_WP;

Then with fix,

$ ./test_progs -n 44
#44/1 sockmap create_update_free:OK
#44/2 sockhash create_update_free:OK
#44 sockmap_basic:OK

Fixes: 5d3919a953c3c ("selftests/bpf: Test freeing sockmap/sockhash with a socket in it")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/158131347731.21414.12120493483848386652.stgit@john-Precision-5820-Tower
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/bpf/prog_tests/sockmap_basic.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -3,6 +3,11 @@
 
 #include "test_progs.h"
 
+#define TCP_REPAIR		19	/* TCP sock is under repair right now */
+
+#define TCP_REPAIR_ON		1
+#define TCP_REPAIR_OFF_NO_WP	-1	/* Turn off without window probes */
+
 static int connected_socket_v4(void)
 {
 	struct sockaddr_in addr = {



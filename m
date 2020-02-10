Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6F81579EB
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgBJNTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:19:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:60300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728916AbgBJMht (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:49 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F018C20873;
        Mon, 10 Feb 2020 12:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338269;
        bh=R9z6yjPFHF/aRe7qlZDX1G0yJvRepICq+0DcmrCr0Dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CNIdGoeZ3CQ4JcbmB9V2Hd1+UUL7zc83ycR+s6Z+5IfZr7J0mw34bOUnjW4LE8xH4
         ov7O13iWHtmoGKTTqRZXcQiJ+9W/m05MFKq5OaZRZ5IQ70xsOuj+KLO3A+H3Yk1QPn
         dpFvjLD64HqoQtHB7EGjGK8jKrh/8DU9v8yfg9u0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH 5.4 149/309] samples/bpf: Dont try to remove users homedir on clean
Date:   Mon, 10 Feb 2020 04:31:45 -0800
Message-Id: <20200210122420.620363865@linuxfoundation.org>
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

From: Toke Høiland-Jørgensen <toke@redhat.com>

commit b2e5e93ae8af6a34bca536cdc4b453ab1e707b8b upstream.

The 'clean' rule in the samples/bpf Makefile tries to remove backup
files (ending in ~). However, if no such files exist, it will instead try
to remove the user's home directory. While the attempt is mostly harmless,
it does lead to a somewhat scary warning like this:

rm: cannot remove '~': Is a directory

Fix this by using find instead of shell expansion to locate any actual
backup files that need to be removed.

Fixes: b62a796c109c ("samples/bpf: allow make to be run from samples/bpf/ directory")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Link: https://lore.kernel.org/bpf/157952560126.1683545.7273054725976032511.stgit@toke.dk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 samples/bpf/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -236,7 +236,7 @@ all:
 
 clean:
 	$(MAKE) -C ../../ M=$(CURDIR) clean
-	@rm -f *~
+	@find $(CURDIR) -type f -name '*~' -delete
 
 $(LIBBPF): FORCE
 # Fix up variables inherited from Kbuild that tools/ build system won't like



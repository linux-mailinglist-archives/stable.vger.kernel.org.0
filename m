Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0931B850F
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404086AbfISWRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:17:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406443AbfISWRL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:17:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDD8A21907;
        Thu, 19 Sep 2019 22:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931431;
        bh=Lj7bkb2BiDO38UOg4KwiSGvkPNkyrZAhGxld/8od+KE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJh54lBxjUV30YXNaq2T67Rv/uiaRibk9/lSh7KImWoUq6GMV/YeJdlHiNwN3e8qH
         IGTl+2PsRvVb4w8Ny/ceCG5u6zqoKwnVIGStJH+8RdeJVHTJ80Ouc7+npNuKWhRzsV
         BF+wGGDXkm/FnD8VrEOBcn1WdAknry4h5h86WjuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Zephaniah E. Loss-Cutler-Hull" <zephaniah@gmail.com>,
        Len Brown <len.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 44/59] tools/power x86_energy_perf_policy: Fix argument parsing
Date:   Fri, 20 Sep 2019 00:03:59 +0200
Message-Id: <20190919214807.211407928@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214755.852282682@linuxfoundation.org>
References: <20190919214755.852282682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zephaniah E. Loss-Cutler-Hull <zephaniah@gmail.com>

[ Upstream commit 03531482402a2bc4ab93cf6dde46833775e035e9 ]

The -w argument in x86_energy_perf_policy currently triggers an
unconditional segfault.

This is because the argument string reads: "+a:c:dD:E:e:f:m:M:rt:u:vw" and
yet the argument handler expects an argument.

When parse_optarg_string is called with a null argument, we then proceed to
crash in strncmp, not horribly friendly.

The man page describes -w as taking an argument, the long form
(--hwp-window) is correctly marked as taking a required argument, and the
code expects it.

As such, this patch simply marks the short form (-w) as requiring an
argument.

Signed-off-by: Zephaniah E. Loss-Cutler-Hull <zephaniah@gmail.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
index bbef8bcf44d6d..2aba622d1c5aa 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -546,7 +546,7 @@ void cmdline(int argc, char **argv)
 
 	progname = argv[0];
 
-	while ((opt = getopt_long_only(argc, argv, "+a:c:dD:E:e:f:m:M:rt:u:vw",
+	while ((opt = getopt_long_only(argc, argv, "+a:c:dD:E:e:f:m:M:rt:u:vw:",
 				long_options, &option_index)) != -1) {
 		switch (opt) {
 		case 'a':
-- 
2.20.1




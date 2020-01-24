Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F361A14828D
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391731AbgAXL2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:28:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391727AbgAXL2t (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:28:49 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A59C720718;
        Fri, 24 Jan 2020 11:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865328;
        bh=3lgcFBKJKbVwE2Hfs1ASQbPTBkbI0WqglpVRsQiJUps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rlDYq/d9nu5zE2ZBNn+hs/asxMXSqTTRvt9qrhUl2jiNHWQCo00LDBW4wB5OTHcI0
         vhLpHciCmsgHOLSJiP6Ud+Sk1kD91+vWxIaIPyr8tXpHT77Bbu+0QTFCuRwhJi1Yh/
         p5UgONz45mUJwnPIxpnkMzT8By+Qs579PgP9DPis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 508/639] tools: bpftool: fix arguments for p_err() in do_event_pipe()
Date:   Fri, 24 Jan 2020 10:31:18 +0100
Message-Id: <20200124093152.424163675@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Monnet <quentin.monnet@netronome.com>

[ Upstream commit 9def249dc8409ffc1f5a1d7195f1c462f2b49c07 ]

The last argument passed to some calls to the p_err() functions is not
correct, it should be "*argv" instead of "**argv". This may lead to a
segmentation fault error if CPU IDs or indices from the command line
cannot be parsed correctly. Let's fix this.

Fixes: f412eed9dfde ("tools: bpftool: add simple perf event output reader")
Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/map_perf_ring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/map_perf_ring.c b/tools/bpf/bpftool/map_perf_ring.c
index 6d41323be291b..8ec0148d7426d 100644
--- a/tools/bpf/bpftool/map_perf_ring.c
+++ b/tools/bpf/bpftool/map_perf_ring.c
@@ -205,7 +205,7 @@ int do_event_pipe(int argc, char **argv)
 			NEXT_ARG();
 			cpu = strtoul(*argv, &endptr, 0);
 			if (*endptr) {
-				p_err("can't parse %s as CPU ID", **argv);
+				p_err("can't parse %s as CPU ID", *argv);
 				goto err_close_map;
 			}
 
@@ -216,7 +216,7 @@ int do_event_pipe(int argc, char **argv)
 			NEXT_ARG();
 			index = strtoul(*argv, &endptr, 0);
 			if (*endptr) {
-				p_err("can't parse %s as index", **argv);
+				p_err("can't parse %s as index", *argv);
 				goto err_close_map;
 			}
 
-- 
2.20.1




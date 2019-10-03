Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65C0DCAB6C
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730803AbfJCRVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:21:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389250AbfJCQR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:17:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C193021783;
        Thu,  3 Oct 2019 16:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119447;
        bh=RqFa86+ysUK3w9+oA6+iwf3Z60j/QVf4cHLrqJuUrvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WEDYif+RwGhr5GSlwQYvolwtHMcCzVUIqGYcjQFYnH6i0xe/M5IiMJgqlfU4TqLFH
         vE7T5sZoVJP6L+ge6GpfGwZw6aUn2++j5UHhnvy5zWt+fITfVPYOYRdhLIAXKSIdUw
         Hge7f9ErdMyPtb4OirOcgqU4Fs1XhA722bwnwx98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        =?UTF-8?q?Luis=20Cl=C3=A1udio=20Gon=C3=A7alves?= 
        <lclaudio@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Taeung Song <treeze.taeung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 067/211] perf config: Honour $PERF_CONFIG env var to specify alternate .perfconfig
Date:   Thu,  3 Oct 2019 17:52:13 +0200
Message-Id: <20191003154503.822460048@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 61a461fcbd62d42c29a1ea6a9cc3838ad9f49401 ]

We had this comment in Documentation/perf_counter/config.c, i.e. since
when we got this from the git sources, but never really did that
getenv("PERF_CONFIG"), do it now as I need to disable whatever
~/.perfconfig root has so that tests parsing tool output are done for
the expected default output or that we specify an alternate config file
that when read will make the tools produce expected output.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Luis Cláudio Gonçalves <lclaudio@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Taeung Song <treeze.taeung@gmail.com>
Fixes: 078006012401 ("perf_counter tools: add in basic glue from Git")
Link: https://lkml.kernel.org/n/tip-jo209zac9rut0dz1rqvbdlgm@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/perf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index a11cb006f9682..80f8ae8b13666 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -439,6 +439,9 @@ int main(int argc, const char **argv)
 
 	srandom(time(NULL));
 
+	/* Setting $PERF_CONFIG makes perf read _only_ the given config file. */
+	config_exclusive_filename = getenv("PERF_CONFIG");
+
 	err = perf_config(perf_default_config, NULL);
 	if (err)
 		return err;
-- 
2.20.1




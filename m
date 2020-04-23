Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67DBA1B59D9
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 13:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbgDWLA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 07:00:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727895AbgDWLA7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 07:00:59 -0400
Received: from localhost.localdomain (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 581D120704;
        Thu, 23 Apr 2020 11:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587639658;
        bh=lTkMi/ZNt6OC2GMlHpavILsFBilbXzr9Sq3gYRp/Quo=;
        h=From:To:Cc:Subject:Date:From;
        b=U295c3Sfnwm6J1C5y+rOiboR8YTzaw1H5LHIcFwxCp1EiP3Suh2lURr6OEpb2cF6O
         AT0hfCR147Y+9WzUU/Mkk7t+A58rayXb4gqwHn4f7lRCgOA1cWp7Neg18MrwiFxrh6
         G1Pzbq2o4iz6czYtAv012q85JtWvgHpRBqunWiIM=
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 0/3] perf-probe: Fix __init function and blacklist checking
Date:   Thu, 23 Apr 2020 20:00:54 +0900
Message-Id: <158763965400.30755.14484569071233923742.stgit@devnote2>
X-Mailer: git-send-email 2.20.1
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Here is a series of fixes related to __init function and
blacklist checking routines. Arnaldo noticed me some cases
which don't check the __init function checking. I found that
the blacklist checking is also not working with KASLR, and
also skipped probes are shown in result list unexpectedly.

Thank you,

---

Masami Hiramatsu (3):
      perf-probe: Fix to check blacklist address correctly
      perf-probe: Check address correctness by map instead of _etext
      perf-probe: Do not show the skipped events


 tools/perf/builtin-probe.c    |    3 +++
 tools/perf/util/probe-event.c |   46 +++++++++++++++++++++++++----------------
 2 files changed, 31 insertions(+), 18 deletions(-)

--
Masami Hiramatsu (Linaro) <mhiramat@kernel.org>

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0105E1F7AAA
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 17:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgFLPXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 11:23:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgFLPXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jun 2020 11:23:12 -0400
Received: from localhost.localdomain (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89098206A4;
        Fri, 12 Jun 2020 15:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591975392;
        bh=aZ5zbFgUlr+jWJ0e8ysaxSNTCOeYD7NUs6V0V1Bpp8c=;
        h=From:To:Cc:Subject:Date:From;
        b=BtAGtrLF01Hpw0qjYokpggMJh566Y3yNxB0TUBFVY1pWz9YVMWT9ABbWqGFyZy1JA
         sKNJ3iVlwnNLFNBV8pVAqPxxs9168/guKp2Y1cQkqXxBfyDWvAcDWLZaUcpdgy5siM
         4gAjTe0Alq1i/w3IkEZFVqhSCR31Wqps68g27OkE=
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] bootconfig: Fix quote-character issue and return value
Date:   Sat, 13 Jun 2020 00:23:08 +0900
Message-Id: <159197538852.80267.10091816844311950396.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Steve,

I found 2 bugs in /proc/bootconfig and tools/bootconfig.

- They always use double-quote to quote values. For the values
  which includes double-quote, it should use single-quote instead.
- tools/bootconfig always returns error code if it shows the
  bootconfig in initrd (executed without options)

This series fixes those bugs and add testcases to ensure
no regressions.

Thank you,

---

Masami Hiramatsu (4):
      proc/bootconfig: Fix to use correct quotes for value
      tools/bootconfig: Fix to use correct quotes for value
      tools/bootconfig: Fix to return 0 if succeeded to show the bootconfig
      tools/bootconfig: Add testcase for show-command and quotes test


 fs/proc/bootconfig.c                |   13 +++++++++----
 tools/bootconfig/main.c             |   18 +++++++++++-------
 tools/bootconfig/test-bootconfig.sh |   10 ++++++++++
 3 files changed, 30 insertions(+), 11 deletions(-)

--
Masami Hiramatsu (Linaro) <mhiramat@kernel.org>

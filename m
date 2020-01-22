Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5D8F145698
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730724AbgAVN17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:27:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:49824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729742AbgAVN16 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:27:58 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFC0D205F4;
        Wed, 22 Jan 2020 13:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699678;
        bh=c+tAHl7rKqHexa/ZvutCPfX7AcAg56Ionp2mrmpOZMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qPsOqkZ9u0fmdao8gSY6pkQrQpr88I7jsNEMcBRlqhz/Ch9hjVcYDepbpAeTNi2gn
         q1jcbEZO8mfevfHSTvFlCnkyR7EWjobTvqy25erk0ftvxL3uecl8bA4kTsqKa4E3IN
         O6NegQ+cleZF8efzt1vlEhaljjNlInOgsp78f+BA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.4 216/222] perf script: Allow --time with --reltime
Date:   Wed, 22 Jan 2020 10:30:02 +0100
Message-Id: <20200122092849.159018562@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

commit 3714437d3fcc7956cabcb0077f2a506b61160a56 upstream.

The original --reltime patch forbid --time with --reltime.

But it turns out --time doesn't really care about --reltime, because the
relative time is only used at final output, while the time filtering
always works earlier on absolute time.

So just remove the check and allow combining the two options.

Fixes: 90b10f47c0ee ("perf script: Support relative time")
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: http://lore.kernel.org/lkml/20191002164642.1719-1-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/builtin-script.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -3605,11 +3605,6 @@ int cmd_script(int argc, const char **ar
 		}
 	}
 
-	if (script.time_str && reltime) {
-		fprintf(stderr, "Don't combine --reltime with --time\n");
-		return -1;
-	}
-
 	if (itrace_synth_opts.callchain &&
 	    itrace_synth_opts.callchain_sz > scripting_max_stack)
 		scripting_max_stack = itrace_synth_opts.callchain_sz;



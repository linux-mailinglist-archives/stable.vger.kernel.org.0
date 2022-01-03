Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46BB4832EE
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbiACOcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:32:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233581AbiACOaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:30:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C15C061353;
        Mon,  3 Jan 2022 06:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D04196112B;
        Mon,  3 Jan 2022 14:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF12C36AEB;
        Mon,  3 Jan 2022 14:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220215;
        bh=7NvUlMhpEE6zxLCt2O0j28O7RqnVD/IKOrrFFcFK3mA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RBTXxzBN3tnoXwtNw0Qx4uFkpqK+35PHiqF1rJKp7b4igNJUxs4eTbB3tcMiwuSTy
         vYhNyGrHYA9FysBvMhmLR0ThmG9wD20vqFIQNcU6gYOLzEWFGX3+bPdhaSCl/JOd4H
         ar+DHOSJ6gg7pVnx700UIQWDXrtybJQN2Qk+5YBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Riccardo Mancini <rickyman7@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 47/48] perf script: Fix CPU filtering of a scripts switch events
Date:   Mon,  3 Jan 2022 15:24:24 +0100
Message-Id: <20220103142055.056940289@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142053.466768714@linuxfoundation.org>
References: <20220103142053.466768714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 5e0c325cdb714409a5b242c9e73a1b61157abb36 upstream.

CPU filtering was not being applied to a script's switch events.

Fixes: 5bf83c29a0ad2e78 ("perf script: Add scripting operation process_switch()")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Riccardo Mancini <rickyman7@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211215080636.149562-3-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/builtin-script.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -2354,7 +2354,7 @@ static int process_switch_event(struct p
 	if (perf_event__process_switch(tool, event, sample, machine) < 0)
 		return -1;
 
-	if (scripting_ops && scripting_ops->process_switch)
+	if (scripting_ops && scripting_ops->process_switch && !filter_cpu(sample))
 		scripting_ops->process_switch(event, sample, machine);
 
 	if (!script->show_switch_events)



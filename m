Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB38F483291
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbiACO2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234058AbiACO1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:27:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BA3C061374;
        Mon,  3 Jan 2022 06:27:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FE49B80F52;
        Mon,  3 Jan 2022 14:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88687C36AED;
        Mon,  3 Jan 2022 14:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220064;
        bh=rogCokf3ukcPGndDrdBE4Yf3YZ5S1kp8ezFtVDX/8po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sb1jYQxw6csZfK2nt07XUaHsJDIz5u+JU/GeLPITvDkN2fHBAfhZP2v8yXoLpjHkl
         AjKDIUI5h2bGpe2QLVJGeyldxNeDSQMXi5Apd/NVVq27d421KMJCovh5JLrkN7tkTV
         vbCWrPS74TGCWjSSbGPjWXlB3HM2XFK2bub4qYeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Riccardo Mancini <rickyman7@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.4 37/37] perf script: Fix CPU filtering of a scripts switch events
Date:   Mon,  3 Jan 2022 15:24:15 +0100
Message-Id: <20220103142053.014538902@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142051.883166998@linuxfoundation.org>
References: <20220103142051.883166998@linuxfoundation.org>
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
@@ -2308,7 +2308,7 @@ static int process_switch_event(struct p
 	if (perf_event__process_switch(tool, event, sample, machine) < 0)
 		return -1;
 
-	if (scripting_ops && scripting_ops->process_switch)
+	if (scripting_ops && scripting_ops->process_switch && !filter_cpu(sample))
 		scripting_ops->process_switch(event, sample, machine);
 
 	if (!script->show_switch_events)



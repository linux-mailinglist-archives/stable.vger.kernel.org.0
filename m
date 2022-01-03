Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F654833A5
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235170AbiACOkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbiACOil (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:38:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848B9C07E5E3;
        Mon,  3 Jan 2022 06:34:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 236F56111A;
        Mon,  3 Jan 2022 14:34:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FF6C36AEB;
        Mon,  3 Jan 2022 14:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220471;
        bh=2JWMGuVbnSq1VzJqRVPL/fPeH0jDf+xKMXM6tfpQsNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sHYKuEqgUzQEKbZbMasB4azVPPybiap+YhOib1F0gK6uO5JXgsoVY/wmQBFtRSueN
         PV1GQmgrBg9o23H4w+ko3mO8zpX+mXw4x54MFGM2Ep6Kco0ceXt56WIzxIuDmoNLMt
         CgLP6GNHDatBqyjcDSgmhXC4CoPgTpI7KORfbzCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Riccardo Mancini <rickyman7@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.15 72/73] perf script: Fix CPU filtering of a scripts switch events
Date:   Mon,  3 Jan 2022 15:24:33 +0100
Message-Id: <20220103142059.257687950@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
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
@@ -2463,7 +2463,7 @@ static int process_switch_event(struct p
 	if (perf_event__process_switch(tool, event, sample, machine) < 0)
 		return -1;
 
-	if (scripting_ops && scripting_ops->process_switch)
+	if (scripting_ops && scripting_ops->process_switch && !filter_cpu(sample))
 		scripting_ops->process_switch(event, sample, machine);
 
 	if (!script->show_switch_events)



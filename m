Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF24A475EF9
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343598AbhLOR02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:26:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45726 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245601AbhLORZF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:25:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DDAD619EB;
        Wed, 15 Dec 2021 17:25:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B9DC36AE0;
        Wed, 15 Dec 2021 17:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589104;
        bh=vC2xqwwv9yOfn599z6hMyZmo+dC8ibJvUAC4HxoCnPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=15dCIFUs5w+j0VbhsCq3lFikjV/r3RGMsCnU3g0siR8zff/X+u7xOxgx2A96B8hgo
         5atToc5lHCpe+z2C/PScKWMsulU+8J9otJn8UXgcCpDMTAUCKsCkUeFSiLlsElHsEX
         T7eqUi9p9NKJKxacGej+sme/rsO2tyhgpO4TX6EI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 21/33] perf inject: Fix itrace space allowed for new attributes
Date:   Wed, 15 Dec 2021 18:21:19 +0100
Message-Id: <20211215172025.499954318@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172024.787958154@linuxfoundation.org>
References: <20211215172024.787958154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit c29d9792607e67ed8a3f6e9db0d96836d885a8c5 upstream.

The space allowed for new attributes can be too small if existing header
information is large. That can happen, for example, if there are very
many CPUs, due to having an event ID per CPU per event being stored in the
header information.

Fix by adding the existing header.data_offset. Also increase the extra
space allowed to 8KiB and align to a 4KiB boundary for neatness.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lore.kernel.org/lkml/20211125071457.2066863-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[Adrian: Backport to v5.10]
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/builtin-inject.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -752,7 +752,7 @@ static int __cmd_inject(struct perf_inje
 		inject->tool.ordered_events = true;
 		inject->tool.ordering_requires_timestamps = true;
 		/* Allow space in the header for new attributes */
-		output_data_offset = 4096;
+		output_data_offset = roundup(8192 + session->header.data_offset, 4096);
 		if (inject->strip)
 			strip_init(inject);
 	}



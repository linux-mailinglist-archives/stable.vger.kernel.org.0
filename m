Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8119475ECD
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238371AbhLORYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:24:49 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44724 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245365AbhLORYE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:24:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3D1F619E8;
        Wed, 15 Dec 2021 17:24:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83DAC36AE2;
        Wed, 15 Dec 2021 17:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589043;
        bh=+q9LINZAMnju/J1RN8FmBJT3/5KdKmOLPEEphQu5i1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hHiRgUXHpMBWLaSGrLgManr3fVUcT03NlA5Sxq9DY+CDsWEGBhYCv4MxKLx/76b+Q
         rxseY0fb/O9qtzSex7cGYyj0RG9d+4QxJuj/UezWH2LINrA+SzsunJQlCXNHD2Eyee
         GgpcDh8lqGAER8+0DNlDsQEVsIHPKmpnJ9rttFxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.15 42/42] perf inject: Fix itrace space allowed for new attributes
Date:   Wed, 15 Dec 2021 18:21:23 +0100
Message-Id: <20211215172028.076413106@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
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
[Adrian: Backport to v5.15]
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/builtin-inject.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -819,7 +819,7 @@ static int __cmd_inject(struct perf_inje
 		inject->tool.ordered_events = true;
 		inject->tool.ordering_requires_timestamps = true;
 		/* Allow space in the header for new attributes */
-		output_data_offset = 4096;
+		output_data_offset = roundup(8192 + session->header.data_offset, 4096);
 		if (inject->strip)
 			strip_init(inject);
 	}



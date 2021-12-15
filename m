Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2AEE475F38
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238385AbhLOR2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:28:53 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46254 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbhLORZj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:25:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECF88619EC;
        Wed, 15 Dec 2021 17:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52BCC36AE2;
        Wed, 15 Dec 2021 17:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589138;
        bh=XMFSDXCQyp+vSh2JdAPzTiWExUYpSLIkJGU1gj9BpBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I1ePzP95ahruShN9kbQB//ERii8ZZsvF4KfeIrkhUSTHnDVHh+XlRMRyzle1UY2fp
         dNl1eoK/cKwWgvIu6KsGIVDaOaroU26wpIwVAO9Rsf+hJLdK20Bdej9svG1KIr84jA
         A0As3oWpMV7XxWlr7x5CEPJVihU3jrUZqDcKfgLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 26/33] perf intel-pt: Fix next err value, walking trace
Date:   Wed, 15 Dec 2021 18:21:24 +0100
Message-Id: <20211215172025.672822311@linuxfoundation.org>
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

commit a32e6c5da599dbf49e60622a4dfb5b9b40ece029 upstream.

Code after label 'next:' in intel_pt_walk_trace() assumes 'err' is zero,
but it may not be, if arrived at via a 'goto'. Ensure it is zero.

Fixes: 7c1b16ba0e26e6 ("perf intel-pt: Add support for decoding FUP/TIP only")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org # v5.15+
Link: https://lore.kernel.org/r/20211210162303.2288710-6-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[Adrian: Backport to v5.10]
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -2068,6 +2068,7 @@ static int intel_pt_walk_trace(struct in
 		if (err)
 			return err;
 next:
+		err = 0;
 		if (decoder->cyc_threshold) {
 			if (decoder->sample_cyc && last_packet_type != INTEL_PT_CYC)
 				decoder->sample_cyc = false;



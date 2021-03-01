Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA413283A4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237684AbhCAQWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:22:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:56664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237798AbhCAQUw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:20:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04A2264E22;
        Mon,  1 Mar 2021 16:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615494;
        bh=KN0mQ0RcyQ10XRw1zZxBSot2P22F9YHZ4KB9utzW9C8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XqcRn3EZ/r1DvE7nWtJ6UDvtJPOdXqLqOT9BdTsec2VKC1yZnN2aTFlhFS/z+HECV
         jWsKlqnr0qXtVqNN3PuLvzwCMFDfZtDw3u4VQ1z//KTSAUclrD1UidUxL3WoEYNuFJ
         TQz3bxNzBU/GJaQw4zw9nGz+6Sc9/8bX61uQGCkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 49/93] perf intel-pt: Fix missing CYC processing in PSB
Date:   Mon,  1 Mar 2021 17:13:01 +0100
Message-Id: <20210301161009.316077353@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161006.881950696@linuxfoundation.org>
References: <20210301161006.881950696@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 03fb0f859b45d1eb05c984ab4bd3bef67e45ede2 ]

Add missing CYC packet processing when walking through PSB+. This
improves the accuracy of timestamps that follow PSB+, until the next
MTC.

Fixes: 3d49807870f08 ("perf tools: Add new Intel PT packet definitions")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: https://lore.kernel.org/r/20210205175350.23817-2-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
index c1944765533c8..28f9e88c65bac 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -1478,6 +1478,9 @@ static int intel_pt_walk_psbend(struct intel_pt_decoder *decoder)
 			break;
 
 		case INTEL_PT_CYC:
+			intel_pt_calc_cyc_timestamp(decoder);
+			break;
+
 		case INTEL_PT_VMCS:
 		case INTEL_PT_MNT:
 		case INTEL_PT_PAD:
-- 
2.27.0




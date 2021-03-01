Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FF632849D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbhCAQit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:38:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:36924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232666AbhCAQc1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:32:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAC1764F4F;
        Mon,  1 Mar 2021 16:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615901;
        bh=3COQfUzL2kyXEBjlpRemtYoklUhQmWM+6CIESuVMDmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=150u5hDf79DcJMA4znViz7OInwq8iNbD7bIgc6oV1/XB3fRgUUFXQJ/KT/hu0NMtQ
         zkLVYf/aNjPpuurxrIHAiHTOx6uQeyHezyrOGvd2eANQ5TGN2Odbr2IKgNvhOnnNFQ
         sYixi51aXhpiqa/xXCT9sSYWj422Hc4FhL/zOQdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 070/134] perf intel-pt: Fix missing CYC processing in PSB
Date:   Mon,  1 Mar 2021 17:12:51 +0100
Message-Id: <20210301161017.001934144@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
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
index 63fa3a95a1d69..7292f73118ed3 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -1508,6 +1508,9 @@ static int intel_pt_walk_psbend(struct intel_pt_decoder *decoder)
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




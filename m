Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA8911DB3
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbfEBPcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:32:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728651AbfEBPcd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:32:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C812520675;
        Thu,  2 May 2019 15:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811152;
        bh=aFnUXFlRaYzH6NCPbxdKrZuk1ZJSOgHvyS+LtCDVygc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XexrajBfztBxSi5wvfePgWpoQy01q7PUiC4OrMfA+PPVXJnhiSUq5i98D1EzgSnQx
         +3kNbhR5c8AB9M1/u/Md1fWvIBC6/49QeIEK7SArDonzA+RelJ4tSSJ6j1mZrDjSfl
         lRbtUSkRsXOsMZc2QjskuLI9CE16X80u0XXK51aE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Solomon Tan <solomonbobstoner@gmail.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Walker <robert.walker@arm.com>,
        Suzuki K Poulouse <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 094/101] perf cs-etm: Add missing case value
Date:   Thu,  2 May 2019 17:21:36 +0200
Message-Id: <20190502143346.174914362@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c8fa7a807f3c5f946bd92076fbaf7826edb650dc ]

The following error was thrown when compiling `tools/perf` using OpenCSD
v0.11.1. This patch fixes said error.

    CC       util/intel-pt-decoder/intel-pt-log.o
    CC       util/cs-etm-decoder/cs-etm-decoder.o
  util/cs-etm-decoder/cs-etm-decoder.c: In function
  ‘cs_etm_decoder__buffer_range’:
  util/cs-etm-decoder/cs-etm-decoder.c:370:2: error: enumeration value
  ‘OCSD_INSTR_WFI_WFE’ not handled in switch [-Werror=switch-enum]
    switch (elem->last_i_type) {
    ^~~~~~
    CC       util/intel-pt-decoder/intel-pt-decoder.o
  cc1: all warnings being treated as errors

Because `OCSD_INSTR_WFI_WFE` case was added only in v0.11.0, the minimum
required OpenCSD library version for this patch is no longer v0.10.0.

Signed-off-by: Solomon Tan <solomonbobstoner@gmail.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Walker <robert.walker@arm.com>
Cc: Suzuki K Poulouse <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Link: http://lkml.kernel.org/r/20190322052255.GA4809@w-OptiPlex-7050
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 tools/build/feature/test-libopencsd.c           | 4 ++--
 tools/perf/util/cs-etm-decoder/cs-etm-decoder.c | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/build/feature/test-libopencsd.c b/tools/build/feature/test-libopencsd.c
index d68eb4fb40cc..2b0e02c38870 100644
--- a/tools/build/feature/test-libopencsd.c
+++ b/tools/build/feature/test-libopencsd.c
@@ -4,9 +4,9 @@
 /*
  * Check OpenCSD library version is sufficient to provide required features
  */
-#define OCSD_MIN_VER ((0 << 16) | (10 << 8) | (0))
+#define OCSD_MIN_VER ((0 << 16) | (11 << 8) | (0))
 #if !defined(OCSD_VER_NUM) || (OCSD_VER_NUM < OCSD_MIN_VER)
-#error "OpenCSD >= 0.10.0 is required"
+#error "OpenCSD >= 0.11.0 is required"
 #endif
 
 int main(void)
diff --git a/tools/perf/util/cs-etm-decoder/cs-etm-decoder.c b/tools/perf/util/cs-etm-decoder/cs-etm-decoder.c
index 8c155575c6c5..2a8bf6b45a30 100644
--- a/tools/perf/util/cs-etm-decoder/cs-etm-decoder.c
+++ b/tools/perf/util/cs-etm-decoder/cs-etm-decoder.c
@@ -374,6 +374,7 @@ cs_etm_decoder__buffer_range(struct cs_etm_decoder *decoder,
 		break;
 	case OCSD_INSTR_ISB:
 	case OCSD_INSTR_DSB_DMB:
+	case OCSD_INSTR_WFI_WFE:
 	case OCSD_INSTR_OTHER:
 	default:
 		packet->last_instr_taken_branch = false;
-- 
2.19.1




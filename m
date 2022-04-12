Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CECC54FD9C3
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244136AbiDLH66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358730AbiDLHmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C8E23A;
        Tue, 12 Apr 2022 00:19:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FD5D616E7;
        Tue, 12 Apr 2022 07:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3142CC385A1;
        Tue, 12 Apr 2022 07:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747940;
        bh=hlP2sze5FnxNqcBlA5c2Y8VQGE+NWL4VnSSqf3dvcBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TFN3hEfTjhQXMUUd+ZDid3P2ZWtq74u59JqQ3U6GrRDxAi8AI6VRFaQpn39/mguWz
         5TwMKGyMfpV3Y6IURdWvbH1w1EjrJwcGnH+Zazm0OdCKEy2d2blOyixHguY3Q0fpEJ
         GuNQyLB3v+SEbJbQTJ8b/ihy6tV3DSYFuCfJU4rY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 261/343] perf tools: Fix perfs libperf_print callback
Date:   Tue, 12 Apr 2022 08:31:19 +0200
Message-Id: <20220412062958.858571132@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit aeee9dc53ce405d2161f9915f553114e94e5b677 ]

eprintf() does not expect va_list as the type of the 4th parameter.

Use veprintf() because it does.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: 428dab813a56ce94 ("libperf: Merge libperf_set_print() into libperf_init()")
Cc: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20220408132625.2451452-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/perf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 2f6b67189b42..6aae7b6c376b 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -434,7 +434,7 @@ void pthread__unblock_sigwinch(void)
 static int libperf_print(enum libperf_print_level level,
 			 const char *fmt, va_list ap)
 {
-	return eprintf(level, verbose, fmt, ap);
+	return veprintf(level, verbose, fmt, ap);
 }
 
 int main(int argc, const char **argv)
-- 
2.35.1




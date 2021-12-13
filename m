Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2C7472720
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237512AbhLMJ60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:58:26 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:45920 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239029AbhLMJ4Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:56:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E54BFCE0EDF;
        Mon, 13 Dec 2021 09:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941FDC34601;
        Mon, 13 Dec 2021 09:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389381;
        bh=sXUOCeDsNRrp54/TkIY7AFesEnvtOOohdAB/7sguf7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c9XkTE8tw8Ndp4OoVZ+u7PX0mRygyzkObBshCt6XDNSuY0Hn3ScWmceUlzqSQOJTy
         mnMCRYPAEaQOYWSe70YRWq6ICiBRtZoVDePQOr9NB62HPwCgnWjDQ3GkYJHZsDYOph
         bTmadazvfOkBOWen8Ik7J49v+cPGX7+0ic2fG/6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.15 080/171] perf intel-pt: Fix next err value, walking trace
Date:   Mon, 13 Dec 2021 10:29:55 +0100
Message-Id: <20211213092947.756236581@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -2941,6 +2941,7 @@ static int intel_pt_walk_trace(struct in
 		if (err)
 			return err;
 next:
+		err = 0;
 		if (decoder->cyc_threshold) {
 			if (decoder->sample_cyc && last_packet_type != INTEL_PT_CYC)
 				decoder->sample_cyc = false;



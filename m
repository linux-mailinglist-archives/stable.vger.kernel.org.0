Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A202C498E79
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbiAXTmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:42:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60170 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355028AbiAXTjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:39:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27732B81142;
        Mon, 24 Jan 2022 19:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BE2C340E5;
        Mon, 24 Jan 2022 19:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053189;
        bh=TL1Xfz0ZRvKe04M8qbnQ2bKlTrASfu2apqLnWMTqNQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=izba72dK2ejXFHX9NWzfOyHRagrX8z1ksfR2QEfVDMMeGMRP8oDJQB2R443KpwADt
         K5I+koVcUjiTy9LsKUScTQsUW8GOsyy7N6XzhFIvMC8yIE3+TXwAvrc08GPpsabvBM
         dcXBodcRCuMr8yp5L6qqIOMQqqXSQPDbI8yzp2MU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.4 304/320] perf script: Fix hex dump character output
Date:   Mon, 24 Jan 2022 19:44:48 +0100
Message-Id: <20220124184004.288294990@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 62942e9fda9fd1def10ffcbd5e1c025b3c9eec17 upstream.

Using grep -C with perf script -D can give erroneous results as grep loses
lines due to non-printable characters, for example, below the 0020, 0060
and 0070 lines are missing:

 $ perf script -D | grep -C10 AUX | head
 .  0010:  08 00 00 00 00 00 00 00 1f 00 00 00 00 00 00 00  ................
 .  0030:  01 00 00 00 00 00 00 00 00 04 00 00 00 00 00 00  ................
 .  0040:  00 08 00 00 00 00 00 00 02 00 00 00 00 00 00 00  ................
 .  0050:  00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
 .  0080:  02 00 00 00 00 00 00 00 1b 00 00 00 00 00 00 00  ................
 .  0090:  00 00 00 00 00 00 00 00                          ........

 0 0 0x450 [0x98]: PERF_RECORD_AUXTRACE_INFO type: 1
   PMU Type            8
   Time Shift          31

perf's isprint() is a custom implementation from the kernel, but the
kernel's _ctype appears to include characters from Latin-1 Supplement which
is not compatible with, for example, UTF-8. Fix by checking also isascii().

After:

 $ tools/perf/perf script -D | grep -C10 AUX | head
 .  0010:  08 00 00 00 00 00 00 00 1f 00 00 00 00 00 00 00  ................
 .  0020:  03 84 32 2f 00 00 00 00 63 7c 4f d2 fa ff ff ff  ..2/....c|O.....
 .  0030:  01 00 00 00 00 00 00 00 00 04 00 00 00 00 00 00  ................
 .  0040:  00 08 00 00 00 00 00 00 02 00 00 00 00 00 00 00  ................
 .  0050:  00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
 .  0060:  00 02 00 00 00 00 00 00 00 c0 03 00 00 00 00 00  ................
 .  0070:  e2 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00  ................
 .  0080:  02 00 00 00 00 00 00 00 1b 00 00 00 00 00 00 00  ................
 .  0090:  00 00 00 00 00 00 00 00                          ........

Fixes: 3052ba56bcb58904 ("tools perf: Move from sane_ctype.h obtained from git to the Linux's original")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lore.kernel.org/lkml/20220112085057.277205-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -143,7 +143,7 @@ static int trace_event_printer(enum bina
 		break;
 	case BINARY_PRINT_CHAR_DATA:
 		printed += color_fprintf(fp, color, "%c",
-			      isprint(ch) ? ch : '.');
+			      isprint(ch) && isascii(ch) ? ch : '.');
 		break;
 	case BINARY_PRINT_CHAR_PAD:
 		printed += color_fprintf(fp, color, " ");



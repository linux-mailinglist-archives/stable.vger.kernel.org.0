Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2101360D8F
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbhDOPDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:03:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235279AbhDOPAn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:00:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A976613EB;
        Thu, 15 Apr 2021 14:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498610;
        bh=79mMtt/hGUXaKUl+irwBL8/9SThCbhkuACna22xx2Uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AulrfT8IXwLC2Yf5Ll4z17EUKjTiP9LUCs6GgbusbADK79PA5I4/jT4GR2PJ6/srE
         Cm6E64YjPA6QGpLJ5eni4z8/QeHkykJrjtCPwSdbdT9OgKpQs+zBHTetWdffbxq8HO
         o3B7BPT1EW+kMisKKLbUB04SShocN25vLMMyeroc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Clark Williams <williams@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 5.4 15/18] perf tools: Use %define api.pure full instead of %pure-parser
Date:   Thu, 15 Apr 2021 16:48:08 +0200
Message-Id: <20210415144413.527701940@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.055232956@linuxfoundation.org>
References: <20210415144413.055232956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

commit fc8c0a99223367b071c83711259d754b6bb7a379 upstream.

bison deprecated the "%pure-parser" directive in favor of "%define
api.pure full".

The api.pure got introduced in bison 2.3 (Oct 2007), so it seems safe to
use it without any version check.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Clark Williams <williams@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lore.kernel.org/lkml/20200112192259.GA35080@krava
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/expr.y         |    3 ++-
 tools/perf/util/parse-events.y |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/tools/perf/util/expr.y
+++ b/tools/perf/util/expr.y
@@ -12,7 +12,8 @@
 #define MAXIDLEN 256
 %}
 
-%pure-parser
+%define api.pure full
+
 %parse-param { double *final_val }
 %parse-param { struct parse_ctx *ctx }
 %parse-param { const char **pp }
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -1,4 +1,4 @@
-%pure-parser
+%define api.pure full
 %parse-param {void *_parse_state}
 %parse-param {void *scanner}
 %lex-param {void* scanner}



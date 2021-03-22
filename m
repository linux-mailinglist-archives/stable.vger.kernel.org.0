Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F5F34440F
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbhCVM45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:56:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231672AbhCVMyt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:54:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE64961994;
        Mon, 22 Mar 2021 12:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417274;
        bh=7dcP4BRIfNkx/fS5oqxn/eOLOl91QdQ5llE/8G2AYgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rvSoPWHL8PkNU8Le7GUDXjhaPtgMd5/Avb1/iMQE4UDzV3sMPX1naWtDANgO/tH9j
         kmGgjdtyssDcb5QUCLtzVyfCv4nUOHKIpSSiCCp5PLGqzosStLOnzUGPGmEiYdaQlW
         W94qopnh0KcwfpZfttj2YT9P1Ih4NPqSTu3TDfs4=
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
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 10/43] perf tools: Use %define api.pure full instead of %pure-parser
Date:   Mon, 22 Mar 2021 13:28:51 +0100
Message-Id: <20210322121920.384050485@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121920.053255560@linuxfoundation.org>
References: <20210322121920.053255560@linuxfoundation.org>
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
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/expr.y         |    3 ++-
 tools/perf/util/parse-events.y |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/tools/perf/util/expr.y
+++ b/tools/perf/util/expr.y
@@ -10,7 +10,8 @@
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



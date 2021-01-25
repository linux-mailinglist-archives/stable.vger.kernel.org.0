Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F3F3033C3
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731001AbhAZFEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:04:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:40454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731301AbhAYSxz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:53:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F835221E3;
        Mon, 25 Jan 2021 18:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600794;
        bh=A7spKmcgzj5bdGNQ+cuN9qdBZB0Pc4WFgGyKVYfV7fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNKtOAVEnhIhBr5T4GDpLys99c86ER8Au22MfzVsSp/t7JX3TPBmIrPXbHw1qALnr
         23bhBheTOrS0JFwP9DRNjAeLp9lvfUcDSNy1dR76pR8ZilKoczCwkO2gbUIscsuKvp
         pmoZpoOfA+MD5VPC9DVTxCNWX4z3WFX3z3SGyKYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kent Gibson <warthog618@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.10 152/199] tools: gpio: fix %llu warning in gpio-watch.c
Date:   Mon, 25 Jan 2021 19:39:34 +0100
Message-Id: <20210125183222.624505274@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kent Gibson <warthog618@gmail.com>

commit 1fc7c1ef37f86f207b4db40aba57084bb2f6a69a upstream.

Some platforms, such as mips64, don't map __u64 to long long unsigned
int so using %llu produces a warning:

gpio-watch.c: In function ‘main’:
gpio-watch.c:89:30: warning: format ‘%llu’ expects argument of type ‘long long unsigned int’, but argument 4 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
   89 |    printf("line %u: %s at %llu\n",
      |                           ~~~^
      |                              |
      |                              long long unsigned int
      |                           %lu
   90 |           chg.info.offset, event, chg.timestamp_ns);
      |                                   ~~~~~~~~~~~~~~~~
      |                                      |
      |                                      __u64 {aka long unsigned int}

Replace the %llu with PRIu64 and cast the argument to uint64_t.

Fixes: 33f0c47b8fb4 ("tools: gpio: implement gpio-watch")
Signed-off-by: Kent Gibson <warthog618@gmail.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/gpio/gpio-watch.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/tools/gpio/gpio-watch.c
+++ b/tools/gpio/gpio-watch.c
@@ -10,6 +10,7 @@
 #include <ctype.h>
 #include <errno.h>
 #include <fcntl.h>
+#include <inttypes.h>
 #include <linux/gpio.h>
 #include <poll.h>
 #include <stdbool.h>
@@ -86,8 +87,8 @@ int main(int argc, char **argv)
 				return EXIT_FAILURE;
 			}
 
-			printf("line %u: %s at %llu\n",
-			       chg.info.offset, event, chg.timestamp_ns);
+			printf("line %u: %s at %" PRIu64 "\n",
+			       chg.info.offset, event, (uint64_t)chg.timestamp_ns);
 		}
 	}
 



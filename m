Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5495FDFAF
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 19:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiJMR50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 13:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbiJMR4x (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 13:56:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08AFAC4C32;
        Thu, 13 Oct 2022 10:55:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6015B82039;
        Thu, 13 Oct 2022 17:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12570C433D6;
        Thu, 13 Oct 2022 17:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683698;
        bh=CRJNGRjkpflGVzVE5K8nb5uIXUCKPhy0qiAB2mRSc9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oOmTNyAsb3VtRSQQF3R/vd8DTfEfLGcgwTRNypflviMxPY2Bmn4fVUGOYNAvucu2/
         JGtI57w4EZJlZUItHn02DJ/ZPciWg/Rhc+LWdbJWE1uR7NeKm/Uh0deuEu5QKbpW7A
         DgNT+74OTUS/4lqGrDhLoaswlHYOQ4wMN0ZWUk1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Alexey Dobriyan (SK hynix)" <adobriyan@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 5.10 08/54] perf tools: Fixup get_current_dir_name() compilation
Date:   Thu, 13 Oct 2022 19:52:02 +0200
Message-Id: <20221013175147.560677531@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175147.337501757@linuxfoundation.org>
References: <20221013175147.337501757@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

commit 128dbd78bd673f9edbc4413072b23efb6657feb0 upstream.

strdup() prototype doesn't live in stdlib.h .

Add limits.h for PATH_MAX definition as well.

This fixes the build on Android.

Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/lkml/YRukaQbrgDWhiwGr@localhost.localdomain
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/get_current_dir_name.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/perf/util/get_current_dir_name.c
+++ b/tools/perf/util/get_current_dir_name.c
@@ -3,8 +3,9 @@
 //
 #ifndef HAVE_GET_CURRENT_DIR_NAME
 #include "get_current_dir_name.h"
+#include <limits.h>
+#include <string.h>
 #include <unistd.h>
-#include <stdlib.h>
 
 /* Android's 'bionic' library, for one, doesn't have this */
 



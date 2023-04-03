Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466E86D49C0
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbjDCOlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbjDCOlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:41:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3721617ACF
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:41:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8F47B81CF9
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30805C4339B;
        Mon,  3 Apr 2023 14:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532860;
        bh=5ksT/VopG9E0WBigQofaC8e3hEBi4gPeNc2vegbD6RE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H5Hweujly5gAK90r/rmUL+3/inPkM413a9zbgVdzb5hwwgI9HJHOvCEwVD+YXmplP
         Qs5ygn7wDfvN3NRxuWvRpuxH5tPXhxFlCF+KAjVf7RVEQg+jHy9mwS6tXp8W4P4oXz
         +ZYvjHckNvez56bl7VYxnmuolpIQIOlhHtqEy2ME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ben Hutchings <ben@decadent.org.uk>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.1 144/181] modpost: Fix processing of CRCs on 32-bit build machines
Date:   Mon,  3 Apr 2023 16:09:39 +0200
Message-Id: <20230403140419.744797431@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

commit fb27e70f6e408dee5d22b083e7a38a59e6118253 upstream.

modpost now reads CRCs from .*.cmd files, parsing them using strtol().
This is inconsistent with its parsing of Module.symvers and with their
definition as *unsigned* 32-bit values.

strtol() clamps values to [LONG_MIN, LONG_MAX], and when building on a
32-bit system this changes all CRCs >= 0x80000000 to be 0x7fffffff.

Change extract_crcs_for_object() to use strtoul() instead.

Cc: stable@vger.kernel.org
Fixes: f292d875d0dc ("modpost: extract symbol versions from *.cmd files")
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/mod/modpost.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1722,7 +1722,7 @@ static void extract_crcs_for_object(cons
 		if (!isdigit(*p))
 			continue;	/* skip this line */
 
-		crc = strtol(p, &p, 0);
+		crc = strtoul(p, &p, 0);
 		if (*p != '\n')
 			continue;	/* skip this line */
 



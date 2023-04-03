Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B23A06D4AD7
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbjDCOuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234217AbjDCOu2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:50:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB942A598
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:49:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78FBD61F96
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C60C433D2;
        Mon,  3 Apr 2023 14:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533393;
        bh=T+zcTRxTzzd6H+hiTtK7VEoVnFYEoUYcQTFM9Q5O3Wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HcBwLgqgdK1XaRtm9KRTPdfC1J9pruaPGjCv1i0px/h7+x2vK4RC0G9PHZ8NAHUgM
         4nyAwy1EdhHQFjCbo5QrpCxfsg3scNxO+1wV3512ZZ2UMBtrX2//KXXqWMKwFBVs1C
         F8EQ/X8tvXUo8xmepOZZJ6GrXRGgv2vmKy0SGpUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ben Hutchings <ben@decadent.org.uk>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.2 149/187] modpost: Fix processing of CRCs on 32-bit build machines
Date:   Mon,  3 Apr 2023 16:09:54 +0200
Message-Id: <20230403140420.935035653@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
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
@@ -1733,7 +1733,7 @@ static void extract_crcs_for_object(cons
 		if (!isdigit(*p))
 			continue;	/* skip this line */
 
-		crc = strtol(p, &p, 0);
+		crc = strtoul(p, &p, 0);
 		if (*p != '\n')
 			continue;	/* skip this line */
 



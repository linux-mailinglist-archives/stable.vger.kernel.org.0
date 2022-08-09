Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7EEC58DF26
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345360AbiHISeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347685AbiHISc4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:32:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08A5275FA;
        Tue,  9 Aug 2022 11:11:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64DE6B81A77;
        Tue,  9 Aug 2022 18:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC31C433D7;
        Tue,  9 Aug 2022 18:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068532;
        bh=e+Sqdz09GdVHe1dlbhbcgQasCVxSYIYnh6jIqbIAANo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OHX/zyBp9Qs4hpQSSIRbXCFWVNHydE4kl5STgXbUJvqOXzyGxR34dk69II3nslnMM
         wNuoCUchRxfJ5kci57TPgKj95s938BqO1BTb6CMPXcztBcKSb28L/dQxh0S9UwbS7o
         XlG77ISWc/EY4SqwfR5jsXQXrs7aTbTY5nCgIzyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Ning Qiang <sohu0106@126.com>,
        Kees Cook <keescook@chromium.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.19 19/21] macintosh/adb: fix oob read in do_adb_query() function
Date:   Tue,  9 Aug 2022 20:01:11 +0200
Message-Id: <20220809175513.948745628@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175513.345597655@linuxfoundation.org>
References: <20220809175513.345597655@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ning Qiang <sohu0106@126.com>

commit fd97e4ad6d3b0c9fce3bca8ea8e6969d9ce7423b upstream.

In do_adb_query() function of drivers/macintosh/adb.c, req->data is copied
form userland. The parameter "req->data[2]" is missing check, the array
size of adb_handler[] is 16, so adb_handler[req->data[2]].original_address and
adb_handler[req->data[2]].handler_id will lead to oob read.

Cc: stable <stable@kernel.org>
Signed-off-by: Ning Qiang <sohu0106@126.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220713153734.2248-1-sohu0106@126.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/macintosh/adb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/macintosh/adb.c
+++ b/drivers/macintosh/adb.c
@@ -647,7 +647,7 @@ do_adb_query(struct adb_request *req)
 
 	switch(req->data[1]) {
 	case ADB_QUERY_GETDEVINFO:
-		if (req->nbytes < 3)
+		if (req->nbytes < 3 || req->data[2] >= 16)
 			break;
 		mutex_lock(&adb_handler_mutex);
 		req->reply[0] = adb_handler[req->data[2]].original_address;



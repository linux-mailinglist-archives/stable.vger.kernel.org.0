Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E939C4BDB71
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351936AbiBUJyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:54:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352013AbiBUJxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:53:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669981D317;
        Mon, 21 Feb 2022 01:23:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19146B80EAF;
        Mon, 21 Feb 2022 09:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CFACC340E9;
        Mon, 21 Feb 2022 09:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435397;
        bh=SH5kv4+d2g9ytmY1kPDcn0mQvYvUQiU/BXUGy5MogX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLall1nHhA8Xk+mWFHTLsBqhGTflRMRNa8/6or2CFMOVJJuOkE0V58KoRac46C71u
         vDKgfQSCjrfZ+vudBgPaAS3B+9PdzzKP/LaD0tUl0g4bw+7ytqU9WoUXHBK3ZSmqMb
         D9ym82nU50ETN/iWmSFg2dD7ZuayU6d1fN925RsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 117/227] mctp: fix use after free
Date:   Mon, 21 Feb 2022 09:48:56 +0100
Message-Id: <20220221084938.753002243@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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

From: Tom Rix <trix@redhat.com>

commit 7e5b6a5c8c44310784c88c1c198dde79f6402f7b upstream.

Clang static analysis reports this problem
route.c:425:4: warning: Use of memory after it is freed
  trace_mctp_key_acquire(key);
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~
When mctp_key_add() fails, key is freed but then is later
used in trace_mctp_key_acquire().  Add an else statement
to use the key only when mctp_key_add() is successful.

Fixes: 4f9e1ba6de45 ("mctp: Add tracepoints for tag/key handling")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mctp/route.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -414,13 +414,14 @@ static int mctp_route_input(struct mctp_
 			 * this function.
 			 */
 			rc = mctp_key_add(key, msk);
-			if (rc)
+			if (rc) {
 				kfree(key);
+			} else {
+				trace_mctp_key_acquire(key);
 
-			trace_mctp_key_acquire(key);
-
-			/* we don't need to release key->lock on exit */
-			mctp_key_unref(key);
+				/* we don't need to release key->lock on exit */
+				mctp_key_unref(key);
+			}
 			key = NULL;
 
 		} else {



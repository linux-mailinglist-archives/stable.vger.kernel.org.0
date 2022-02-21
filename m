Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 531134BE81A
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351482AbiBUKAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 05:00:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352460AbiBUJzQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:55:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C77A38BFC;
        Mon, 21 Feb 2022 01:24:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D30F6B80EBB;
        Mon, 21 Feb 2022 09:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2414C340E9;
        Mon, 21 Feb 2022 09:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435460;
        bh=DL49cb9d1UNYv3vnuLE5vghj+o41h5Rq2job1VvuVjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UyS7M+OKBfcM8d4gOliEUXbYyQQRdS+x79AHQXfqLO+/Qoerul1vtQV2ienTlYRXQ
         CqMcyYFkENv5oYitzO3z/w95mzsQsWr2yC8Zol6g7C9Fb1MXORck3F/OL/G1cWAbjn
         LrsLcZTGXvHBE7o9x5J0wAWXIlpw/9S7S6cETfnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eliav Farber <farbere@amazon.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.16 171/227] EDAC: Fix calculation of returned address and next offset in edac_align_ptr()
Date:   Mon, 21 Feb 2022 09:49:50 +0100
Message-Id: <20220221084940.499270787@linuxfoundation.org>
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

From: Eliav Farber <farbere@amazon.com>

commit f8efca92ae509c25e0a4bd5d0a86decea4f0c41e upstream.

Do alignment logic properly and use the "ptr" local variable for
calculating the remainder of the alignment.

This became an issue because struct edac_mc_layer has a size that is not
zero modulo eight, and the next offset that was prepared for the private
data was unaligned, causing an alignment exception.

The patch in Fixes: which broke this actually wanted to "what we
actually care about is the alignment of the actual pointer that's about
to be returned." But it didn't check that alignment.

Use the correct variable "ptr" for that.

  [ bp: Massage commit message. ]

Fixes: 8447c4d15e35 ("edac: Do alignment logic properly in edac_align_ptr()")
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220113100622.12783-2-farbere@amazon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/edac_mc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -213,7 +213,7 @@ void *edac_align_ptr(void **p, unsigned
 	else
 		return (char *)ptr;
 
-	r = (unsigned long)p % align;
+	r = (unsigned long)ptr % align;
 
 	if (r == 0)
 		return (char *)ptr;



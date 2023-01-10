Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66730664B60
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbjAJSmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239593AbjAJSl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:41:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE10213E35
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:35:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68DDF6183C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CC0C433EF;
        Tue, 10 Jan 2023 18:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375746;
        bh=NO5k0c5KZ88CxndTd0TEBkca8IlYz0s7pBQVwqf1iIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FHeLnm5f3eW9au0xLdeTYqSkHV3RDCwcCds+m4t2gr6tWzr3p6xe99IIoDX+4HS9q
         musYvvyHFl7G6cHg3Ccvz/rCYArEQRh8FcHCwKoslRAOAo1371G13TjzOiOTPs4yha
         +NAJnark/3NO6fZKrOib2QRScTQGVouAU4DPGe+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.15 289/290] io_uring: Fix unsigned res comparison with zero in io_fixup_rw_res()
Date:   Tue, 10 Jan 2023 19:06:21 +0100
Message-Id: <20230110180041.877930250@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Smatch warning: io_fixup_rw_res() warn:
	unsigned 'res' is never less than zero.

Change type of 'res' from unsigned to long.

Fixes: d6b7efc722a2 ("io_uring/rw: fix error'ed retry return values")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2701,7 +2701,7 @@ static bool __io_complete_rw_common(stru
 	return false;
 }
 
-static inline int io_fixup_rw_res(struct io_kiocb *req, unsigned res)
+static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
 {
 	struct io_async_rw *io = req->async_data;
 



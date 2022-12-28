Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB11658501
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234827AbiL1RFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233712AbiL1REG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:04:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D073A21813
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:58:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F648B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:58:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECE7C433D2;
        Wed, 28 Dec 2022 16:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246720;
        bh=SJq0HXEP6SaMc2nvEg74Yr7oXYudStapI1zLV51gV+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FRUe2L+SO4ZssvV3BV8pse/Ih/CXJR+jkMKsTInreQdg3dhgW/WSpnTvfgMDfQ5DS
         ZAN5dpZ7+CpTum7BjcxEopl73aSmZUI/pABFXt9iD1AfgIe3ZmXDTtNbuPfMtka8BE
         CsVS2OqrOMKtfOo+rEFwX7Mcpf3FlT4G44oIupmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiri Slaby <jirislaby@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 1139/1146] io_uring/net: ensure compat import handlers clear free_iov
Date:   Wed, 28 Dec 2022 15:44:38 +0100
Message-Id: <20221228144401.080892905@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit 990a4de57e44f4f4cfc33c90d2ec5d285b7c8342 upstream.

If we're not allocating the vectors because the count is below
UIO_FASTIOV, we still do need to properly clear ->free_iov to prevent
an erronous free of on-stack data.

Reported-by: Jiri Slaby <jirislaby@gmail.com>
Fixes: 4c17a496a7a0 ("io_uring/net: fix cleanup double free free_iov init")
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    1 +
 1 file changed, 1 insertion(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -479,6 +479,7 @@ static int __io_compat_recvmsg_copy_hdr(
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		compat_ssize_t clen;
 
+		iomsg->free_iov = NULL;
 		if (msg.msg_iovlen == 0) {
 			sr->len = 0;
 		} else if (msg.msg_iovlen > 1) {



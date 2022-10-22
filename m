Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D0A608601
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiJVHm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbiJVHmg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:42:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1F9B49;
        Sat, 22 Oct 2022 00:41:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 001AAB82DFB;
        Sat, 22 Oct 2022 07:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58542C433C1;
        Sat, 22 Oct 2022 07:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424407;
        bh=wQtvt0pQYSjjl8y2IQ9Sln7QvAgF+4ZI5oQv0B0dNBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLNN7coLmCdU9TLkHohiDCahQFKlLFrHpA1SCp22u/OFgCAJUSKSSzh6/SZGrZYV+
         EePWI4423Os9u6dakrUsVAEXIRaMoKczedtHSLA053GcYEfixFrPm0Cw2nuD5QMiRU
         54gqHR5HB95Jr0/EB8bHyhrQCNvWaotoP+L5N96I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.19 103/717] ksmbd: fix endless loop when encryption for response fails
Date:   Sat, 22 Oct 2022 09:19:42 +0200
Message-Id: <20221022072433.621452811@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

commit 360c8ee6fefdb496fffd2c18bb9a96a376a1a804 upstream.

If ->encrypt_resp return error, goto statement cause endless loop.
It send an error response immediately after removing it.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/server.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -235,10 +235,8 @@ send:
 	if (work->sess && work->sess->enc && work->encrypted &&
 	    conn->ops->encrypt_resp) {
 		rc = conn->ops->encrypt_resp(work);
-		if (rc < 0) {
+		if (rc < 0)
 			conn->ops->set_rsp_status(work, STATUS_DATA_ERROR);
-			goto send;
-		}
 	}
 
 	ksmbd_conn_write(work);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B1165D863
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239593AbjADQOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:14:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239829AbjADQNa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:13:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61CDDE4
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:13:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 08651CE1818
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AA3C433D2;
        Wed,  4 Jan 2023 16:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848806;
        bh=Sn+hzq9h09ualt1WovD9gcawki8wgkSRVAJc8HlrLrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=joVAnCC6NBaEVWDgjXqPRSjeCYazQDjLAoV7ihlZCk6P/HtaLDZKjFvx5ADmkNEJ9
         bsqAHo3jF7XlsoELGqffQaLybfpECdTjZWYqrcZZi14Z+jiImStQawxo/fSXDPrS3X
         38R5rPhQEToU1iSOA2t+Wy4NsOFcwyGJV3v8VyE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>
Subject: [PATCH 6.1 061/207] fs: dlm: retry accept() until -EAGAIN or error returns
Date:   Wed,  4 Jan 2023 17:05:19 +0100
Message-Id: <20230104160513.859624712@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

From: Alexander Aring <aahringo@redhat.com>

commit f0f4bb431bd543ed7bebbaea3ce326cfcd5388bc upstream.

This patch fixes a race if we get two times an socket data ready event
while the listen connection worker is queued. Currently it will be
served only once but we need to do it (in this case twice) until we hit
-EAGAIN which tells us there is no pending accept going on.

This patch wraps an do while loop until we receive a return value which
is different than 0 as it was done before commit d11ccd451b65 ("fs: dlm:
listen socket out of connection hash").

Cc: stable@vger.kernel.org
Fixes: d11ccd451b65 ("fs: dlm: listen socket out of connection hash")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/lowcomms.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1543,7 +1543,11 @@ static void process_recv_sockets(struct
 
 static void process_listen_recv_socket(struct work_struct *work)
 {
-	accept_from_sock(&listen_con);
+	int ret;
+
+	do {
+		ret = accept_from_sock(&listen_con);
+	} while (!ret);
 }
 
 static void dlm_connect(struct connection *con)



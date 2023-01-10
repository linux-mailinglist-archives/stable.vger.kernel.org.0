Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8BCC664A28
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239233AbjAJSa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239367AbjAJSaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:30:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E05152C5F
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:25:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C079761864
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8AFC433D2;
        Tue, 10 Jan 2023 18:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375100;
        bh=w0xO49TIzoNjZMAtrlzZnmgqx4upUyfxRLjiQXfWQRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gbeNdsN8Atr+U2ARFNiLF2kh7Gc+ir9pELqYD0GJd4BeaiDMGq5zTwtWZTkH9F1YK
         t8GRlqYDduGkh84tBauXZOb+PPMSBWq+LVoff1sUs39wFPw4lGM1BIaEDfbreTrTDX
         bH57G+QDa0bYFwkODiRuDjA19LTJ+4/fOqqO1+fY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>
Subject: [PATCH 5.15 078/290] fs: dlm: retry accept() until -EAGAIN or error returns
Date:   Tue, 10 Jan 2023 19:02:50 +0100
Message-Id: <20230110180034.315200469@linuxfoundation.org>
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
@@ -1520,7 +1520,11 @@ static void process_recv_sockets(struct
 
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



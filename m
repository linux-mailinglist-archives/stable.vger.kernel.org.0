Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 102B3664A2B
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239274AbjAJSa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238952AbjAJSaT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:30:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0991D52C56
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:24:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 39861CE18D1
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10502C433D2;
        Tue, 10 Jan 2023 18:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375095;
        bh=O7hOAGal/0o67nv2+ITXPit0FJvBYdG313OurF/TYSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CYG6G+qGvbIzQMiPfJ4fpZKD1b9nz6np49wrSMRIwOWan9+WEY5HpwnhMm2hVufRQ
         hsCB9cfUm2KX/AvugzGzZTf3y4dQS7FXf2hVK6lyisjEAV/9ZRK946D/pJoPysOl1i
         i0ery4fzb5dBnGwD4t7qpJa/FwkiSyi7BYCErWa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>
Subject: [PATCH 5.15 077/290] fs: dlm: fix sock release if listen fails
Date:   Tue, 10 Jan 2023 19:02:49 +0100
Message-Id: <20230110180034.285314641@linuxfoundation.org>
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

commit 08ae0547e75ec3d062b6b6b9cf4830c730df68df upstream.

This patch fixes a double sock_release() call when the listen() is
called for the dlm lowcomms listen socket. The caller of
dlm_listen_for_all should never care about releasing the socket if
dlm_listen_for_all() fails, it's done now only once if listen() fails.

Cc: stable@vger.kernel.org
Fixes: 2dc6b1158c28 ("fs: dlm: introduce generic listen")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/lowcomms.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1797,7 +1797,7 @@ static int dlm_listen_for_all(void)
 	result = sock->ops->listen(sock, 5);
 	if (result < 0) {
 		dlm_close_sock(&listen_con.sock);
-		goto out;
+		return result;
 	}
 
 	return 0;
@@ -2000,7 +2000,6 @@ fail_listen:
 	dlm_proto_ops = NULL;
 fail_proto_ops:
 	dlm_allow_conn = 0;
-	dlm_close_sock(&listen_con.sock);
 	work_stop();
 fail_local:
 	deinit_local();



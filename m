Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A8365D895
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239860AbjADQQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239908AbjADQPy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:15:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCD03C393
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:15:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B79C4B81730
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05873C433D2;
        Wed,  4 Jan 2023 16:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848942;
        bh=yiy/BAanfZaE9KPqRhdmn+0BIKx/+dNNMmkwyeAkINg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MeGHWHf0S34VcbLvcC+5W3LPDV7JN0UyVFl7NbiO0py60pdv3ytYGv7bCpDmLMrwA
         2tJ6wlPmo9EJVyFHfCtw67Y6ubZjKPyHBPI9OtlXVwikDh+2yXoy9rePUpRYpKP1PB
         sl61d/F86pR8OuFghbsX1OaDTQTbsB1py3iw6a30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>
Subject: [PATCH 6.0 038/177] fs: dlm: fix sock release if listen fails
Date:   Wed,  4 Jan 2023 17:05:29 +0100
Message-Id: <20230104160508.811621920@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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
@@ -1820,7 +1820,7 @@ static int dlm_listen_for_all(void)
 	result = sock->ops->listen(sock, 5);
 	if (result < 0) {
 		dlm_close_sock(&listen_con.sock);
-		goto out;
+		return result;
 	}
 
 	return 0;
@@ -2023,7 +2023,6 @@ fail_listen:
 	dlm_proto_ops = NULL;
 fail_proto_ops:
 	dlm_allow_conn = 0;
-	dlm_close_sock(&listen_con.sock);
 	work_stop();
 fail_local:
 	deinit_local();



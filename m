Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709854B4B1D
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346244AbiBNKTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:19:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346218AbiBNKRs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:17:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F259A7CDF3;
        Mon, 14 Feb 2022 01:54:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C21AB80DD4;
        Mon, 14 Feb 2022 09:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30EF1C340E9;
        Mon, 14 Feb 2022 09:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832486;
        bh=Zgwca39LIUpGLZ62CO/FtDwq+uINYpeQGJ1NAqdiEEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W1ZqDFsipAa+jjTmpCKSKILXzVDH2FxRXmTSx9DNyqtLc+XyjKF80ApoX7xOLWkcb
         NVzdpBKYj2kziVdsRikEJSgYFbFFUPShDxiSNRbHkQ5M+YUWxuEfoAwJ6PMve3A9kE
         0s34DRnMttCLi6C1zKMubhdOEvQ09ZInoxOX3yHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 029/203] SUNRPC allow for unspecified transport time in rpc_clnt_add_xprt
Date:   Mon, 14 Feb 2022 10:24:33 +0100
Message-Id: <20220214092511.200096671@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit b8a09619a56334414cbd7f935a0796240d0cc07e ]

If the supplied argument doesn't specify the transport type, use the
type of the existing rpc clnt and its existing transport.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index a312ea2bc4405..c83fe618767c4 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2900,7 +2900,7 @@ int rpc_clnt_add_xprt(struct rpc_clnt *clnt,
 	unsigned long connect_timeout;
 	unsigned long reconnect_timeout;
 	unsigned char resvport, reuseport;
-	int ret = 0;
+	int ret = 0, ident;
 
 	rcu_read_lock();
 	xps = xprt_switch_get(rcu_dereference(clnt->cl_xpi.xpi_xpswitch));
@@ -2914,8 +2914,11 @@ int rpc_clnt_add_xprt(struct rpc_clnt *clnt,
 	reuseport = xprt->reuseport;
 	connect_timeout = xprt->connect_timeout;
 	reconnect_timeout = xprt->max_reconnect_timeout;
+	ident = xprt->xprt_class->ident;
 	rcu_read_unlock();
 
+	if (!xprtargs->ident)
+		xprtargs->ident = ident;
 	xprt = xprt_create_transport(xprtargs);
 	if (IS_ERR(xprt)) {
 		ret = PTR_ERR(xprt);
-- 
2.34.1




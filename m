Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D774ABB31
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384269AbiBGL1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242911AbiBGLKY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:10:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289F2C043181;
        Mon,  7 Feb 2022 03:10:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A935961380;
        Mon,  7 Feb 2022 11:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71995C004E1;
        Mon,  7 Feb 2022 11:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232223;
        bh=/1gOUus/PlI8TcuhnyrJCK0TBi6oG+v2tNclrv/K+8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZTrUM9juqsGnZdMmESX2AxTSxoEcYpEJvgAy0sQkFgHa0ebK7d+5l9vzBGxXodETK
         t29UO5ZxK8C2Cu0Aooji/40bbXguCzYhASQC0T3ARowS2Fwgfg1t5l9k9S6VPOlxhz
         638E2zWEbJKEW0O8FVtnIKOJmCvBm5yrJY2qNVIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dai Ngo <dai.ngo@oracle.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Bruce Fields <bfields@fieldses.org>
Subject: [PATCH 4.9 44/48] nfsd: nfsd4_setclientid_confirm mistakenly expires confirmed client.
Date:   Mon,  7 Feb 2022 12:06:17 +0100
Message-Id: <20220207103753.761720551@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103752.341184175@linuxfoundation.org>
References: <20220207103752.341184175@linuxfoundation.org>
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

From: Dai Ngo <dai.ngo@oracle.com>

commit ab451ea952fe9d7afefae55ddb28943a148247fe upstream.

>From RFC 7530 Section 16.34.5:

o  The server has not recorded an unconfirmed { v, x, c, *, * } and
   has recorded a confirmed { v, x, c, *, s }.  If the principals of
   the record and of SETCLIENTID_CONFIRM do not match, the server
   returns NFS4ERR_CLID_INUSE without removing any relevant leased
   client state, and without changing recorded callback and
   callback_ident values for client { x }.

The current code intends to do what the spec describes above but
it forgot to set 'old' to NULL resulting to the confirmed client
to be expired.

Fixes: 2b63482185e6 ("nfsd: fix clid_inuse on mount with security change")
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Bruce Fields <bfields@fieldses.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3424,8 +3424,10 @@ nfsd4_setclientid_confirm(struct svc_rqs
 			status = nfserr_clid_inuse;
 			if (client_has_state(old)
 					&& !same_creds(&unconf->cl_cred,
-							&old->cl_cred))
+							&old->cl_cred)) {
+				old = NULL;
 				goto out;
+			}
 			status = mark_client_expired_locked(old);
 			if (status) {
 				old = NULL;



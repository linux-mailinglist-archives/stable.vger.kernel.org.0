Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1F44ABD10
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343751AbiBGLoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385015AbiBGLa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:30:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F3CC03BFFA;
        Mon,  7 Feb 2022 03:28:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B324BB811B2;
        Mon,  7 Feb 2022 11:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFCCC36AE2;
        Mon,  7 Feb 2022 11:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233337;
        bh=TdKdDS8mr/Iv2O+Ke94fu/1lpmuGq84s4HlElW3efN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=usBKefgxZ2ogVmb+oI3SvYIPNcjjjp4m2nUrNiK/oRIyhkKYhTRQGgnzBv/wH0dF3
         vx8WRasRZJX8wbOJNBCpfptWtx7CXyZcXS5AVNWGyvo5Hpqa9+FO4CzETWzYIoknXS
         moWe/DdpVhmUbov5ugS2ErrQPbd2P1Nstw3+uD0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dai Ngo <dai.ngo@oracle.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Bruce Fields <bfields@fieldses.org>
Subject: [PATCH 5.15 084/110] nfsd: nfsd4_setclientid_confirm mistakenly expires confirmed client.
Date:   Mon,  7 Feb 2022 12:06:57 +0100
Message-Id: <20220207103805.253054671@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
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
@@ -4112,8 +4112,10 @@ nfsd4_setclientid_confirm(struct svc_rqs
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



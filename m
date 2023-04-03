Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95A26D4AB5
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234138AbjDCOti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234140AbjDCOtW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:49:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C16F2A58B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:48:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 67EDFCE130A
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53EF7C433EF;
        Mon,  3 Apr 2023 14:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533299;
        bh=pkdR9FVXp1LVoAXJptwtc5yNL23uIonJqz8nKWsdv/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ccZFdPPELCVczM74NOPiiGLBcTgEMepkWXfkNXF/g1mqCAsKKcqekh4Hy8YPOEt2h
         v64yjcAbg0u4X7wDOf52ROpBxQkC8cZnFVVN9X1SLCHzGZmcvjA2i2EyYTFkngBCpY
         zTo+6xAi3phWuwlyxMAuyGBCa69LLPWxp/lRLrkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.2 131/187] cifs: prevent infinite recursion in CIFSGetDFSRefer()
Date:   Mon,  3 Apr 2023 16:09:36 +0200
Message-Id: <20230403140420.294831781@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@manguebit.com>

commit 09ba47b44d26b475bbdf9c80db9e0193d2b58956 upstream.

We can't call smb_init() in CIFSGetDFSRefer() as cifs_reconnect_tcon()
may end up calling CIFSGetDFSRefer() again to get new DFS referrals
and thus causing an infinite recursion.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Cc: stable@vger.kernel.org # 6.2
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifssmb.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -4377,8 +4377,13 @@ CIFSGetDFSRefer(const unsigned int xid,
 		return -ENODEV;
 
 getDFSRetry:
-	rc = smb_init(SMB_COM_TRANSACTION2, 15, ses->tcon_ipc, (void **) &pSMB,
-		      (void **) &pSMBr);
+	/*
+	 * Use smb_init_no_reconnect() instead of smb_init() as
+	 * CIFSGetDFSRefer() may be called from cifs_reconnect_tcon() and thus
+	 * causing an infinite recursion.
+	 */
+	rc = smb_init_no_reconnect(SMB_COM_TRANSACTION2, 15, ses->tcon_ipc,
+				   (void **)&pSMB, (void **)&pSMBr);
 	if (rc)
 		return rc;
 



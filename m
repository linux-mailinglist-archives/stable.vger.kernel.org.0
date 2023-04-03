Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF3F6D47B0
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbjDCOWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbjDCOWg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:22:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4C13128B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:22:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78B9E61D2B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91383C433D2;
        Mon,  3 Apr 2023 14:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531732;
        bh=R+POetAYSV5TRg5HgTiYf8CNFjTKmQTNrVBo5/RGKmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1crlUlpyzyq0HO2drV8DSYCLCRlsIftXDXyZ325y6LlCChL93jUWOZW+1Si7HMp/D
         4hX/abOqPRDubb3FEnFOxULMvGihm3zIHkfPIKbQmn91Orm8QfJk0Ppunfu7N67ZdW
         dPS7ntKZtEilGgSi2TcXChz1IZopmqoIIwa+E8Nc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.4 089/104] cifs: prevent infinite recursion in CIFSGetDFSRefer()
Date:   Mon,  3 Apr 2023 16:09:21 +0200
Message-Id: <20230403140407.645633395@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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
@@ -4933,8 +4933,13 @@ CIFSGetDFSRefer(const unsigned int xid,
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
 



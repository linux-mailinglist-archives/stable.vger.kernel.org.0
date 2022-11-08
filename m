Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3436214E8
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbiKHOGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234930AbiKHOGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:06:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8C369DFC
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:06:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BACE76152D
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:06:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9BAC433D6;
        Tue,  8 Nov 2022 14:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916379;
        bh=QEyu1ffuGv05i6X0NGHhaT2q1tC8eS4mnHXlllE8HYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1xPnuAjfe7dAFG9nX7ircmmrSRxOUOMm4I8aGkFZ1vesJpE5hf+t5mOqXsBmXm1w+
         UUdYCBEn2Ep0qSjG2k+Mkn5pbIPISlhusVv7ZwxTOQRaZbrnkK3n2sZUOJ72RFhJI8
         BV1sDVy7wZbSqZSmbykfcUvL3QUcFrZ4Of4Cgc7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 139/144] cifs: fix regression in very old smb1 mounts
Date:   Tue,  8 Nov 2022 14:40:16 +0100
Message-Id: <20221108133351.175101474@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit 2f6f19c7aaad5005dc75298a413eb0243c5d312d upstream.

BZ: 215375

Fixes: 76a3c92ec9e0 ("cifs: remove support for NTLM and weaker authentication algorithms")
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3711,12 +3711,11 @@ CIFSTCon(const unsigned int xid, struct
 	pSMB->AndXCommand = 0xFF;
 	pSMB->Flags = cpu_to_le16(TCON_EXTENDED_SECINFO);
 	bcc_ptr = &pSMB->Password[0];
-	if (tcon->pipe || (ses->server->sec_mode & SECMODE_USER)) {
-		pSMB->PasswordLength = cpu_to_le16(1);	/* minimum */
-		*bcc_ptr = 0; /* password is null byte */
-		bcc_ptr++;              /* skip password */
-		/* already aligned so no need to do it below */
-	}
+
+	pSMB->PasswordLength = cpu_to_le16(1);	/* minimum */
+	*bcc_ptr = 0; /* password is null byte */
+	bcc_ptr++;              /* skip password */
+	/* already aligned so no need to do it below */
 
 	if (ses->server->sign)
 		smb_buffer->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B125461ED4
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378615AbhK2Sky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:40:54 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:54638 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379308AbhK2Siy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:38:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1B176CE13BF;
        Mon, 29 Nov 2021 18:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE04DC53FCF;
        Mon, 29 Nov 2021 18:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210930;
        bh=sTBWQKpXcKub/jb8xHgg4g4xJSCthP6zmxgbu147GME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zwbqde4JoD+fb9H0RytEnvt1gjhH0BhoUnvYYjRXfpt7ltUc7fXHBXCzfhfgXLNR/
         gI9zTZ+A16KPKUw77XitiwDcjm2n37Hh0IEpRsTKhotnI9BHzRjiR92gHuMGqjIGJ6
         IH7wjabX+H21v/wL0hekXbJaBXhGBQdEXb9ZuPGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 044/179] ksmbd: downgrade addition info error msg to debug in smb2_get_info_sec()
Date:   Mon, 29 Nov 2021 19:17:18 +0100
Message-Id: <20211129181720.413192776@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

commit 8e537d1465e7401f352a6e0a728a93f8cad5294a upstream.

While file transfer through windows client, This error flood message
happen. This flood message will cause performance degradation and
misunderstand server has problem.

Fixes: e294f78d3478 ("ksmbd: allow PROTECTED_DACL_SECINFO and UNPROTECTED_DACL_SECINFO addition information in smb2 set info security")
Cc: stable@vger.kernel.org # v5.15
Acked-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -5060,7 +5060,7 @@ static int smb2_get_info_sec(struct ksmb
 	if (addition_info & ~(OWNER_SECINFO | GROUP_SECINFO | DACL_SECINFO |
 			      PROTECTED_DACL_SECINFO |
 			      UNPROTECTED_DACL_SECINFO)) {
-		pr_err("Unsupported addition info: 0x%x)\n",
+		ksmbd_debug(SMB, "Unsupported addition info: 0x%x)\n",
 		       addition_info);
 
 		pntsd->revision = cpu_to_le16(1);



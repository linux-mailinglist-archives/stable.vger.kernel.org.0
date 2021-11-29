Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA99462682
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234704AbhK2WxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:53:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235926AbhK2Wvy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:51:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E44DC1E03DE;
        Mon, 29 Nov 2021 10:41:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 078ACB815D5;
        Mon, 29 Nov 2021 18:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B52C53FCD;
        Mon, 29 Nov 2021 18:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211284;
        bh=r187UJZvMBwR7WGq8l1d+v3WJjbJzQJSn6eQ+6hzlT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oL00kIPZ4hFHsf7ynvTFNLF5XvDp0E/3gqQFmjRwS73+NUbYwMto3ZXcQuVUfPg9j
         WfI+RZHqk8auiefudANOSUJ8vqGYyQQtUcnqJsdR+che3Ed7fdZ6E1cDOAK3pBgZYy
         /KnzdrmF7TsNrFa/oIPw9UQROoNoLiQnnk9b9TsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 169/179] ksmbd: Fix an error handling path in smb2_sess_setup()
Date:   Mon, 29 Nov 2021 19:19:23 +0100
Message-Id: <20211129181724.491431873@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit f8fbfd85f5c95fff477a7c19f576725945891d0c upstream.

All the error handling paths of 'smb2_sess_setup()' end to 'out_err'.

All but the new error handling path added by the commit given in the Fixes
tag below.

Fix this error handling path and branch to 'out_err' as well.

Fixes: 0d994cd482ee ("ksmbd: add buffer validation in session setup")
Cc: stable@vger.kernel.org # v5.15
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1700,8 +1700,10 @@ int smb2_sess_setup(struct ksmbd_work *w
 	negblob_off = le16_to_cpu(req->SecurityBufferOffset);
 	negblob_len = le16_to_cpu(req->SecurityBufferLength);
 	if (negblob_off < (offsetof(struct smb2_sess_setup_req, Buffer) - 4) ||
-	    negblob_len < offsetof(struct negotiate_message, NegotiateFlags))
-		return -EINVAL;
+	    negblob_len < offsetof(struct negotiate_message, NegotiateFlags)) {
+		rc = -EINVAL;
+		goto out_err;
+	}
 
 	negblob = (struct negotiate_message *)((char *)&req->hdr.ProtocolId +
 			negblob_off);



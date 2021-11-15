Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC28451EB8
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243726AbhKPAhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232664AbhKOTZv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9159B633FD;
        Mon, 15 Nov 2021 19:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003259;
        bh=Fn5vxZqghPhG1HmA8a9LtFSudJ90NJrHO7Dfh/sui0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fKT/uI9a5bHm3Laks/Gz31z13Tx5ZGZXvLmg9n0Qxc9qgOP8iiCxfYlFs29xqAILa
         ePoevnwwcidyDtKVk6UmM8ASvaTehzZA+jwzVUdElhoLE+EXF0vOwMXqhK45BvC6Zl
         1Nf5gwaqCi19EfB7aNnX/zPDVfJdGzPcZtWDiQKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Marios Makassikis <mmakassikis@freebox.fr>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 869/917] ksmbd: Fix buffer length check in fsctl_validate_negotiate_info()
Date:   Mon, 15 Nov 2021 18:06:04 +0100
Message-Id: <20211115165458.519042615@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marios Makassikis <mmakassikis@freebox.fr>

commit 78f1688a64cca77758ceb9b183088cf0054bfc82 upstream.

The validate_negotiate_info_req struct definition includes an extra
field to access the data coming after the header. This causes the check
in fsctl_validate_negotiate_info() to count the first element of the
array twice. This in turn makes some valid requests fail, depending on
whether they include padding or not.

Fixes: f7db8fd03a4b ("ksmbd: add validation in smb2_ioctl")
Cc: stable@vger.kernel.org # v5.15
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Acked-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7319,7 +7319,7 @@ static int fsctl_validate_negotiate_info
 	int ret = 0;
 	int dialect;
 
-	if (in_buf_len < sizeof(struct validate_negotiate_info_req) +
+	if (in_buf_len < offsetof(struct validate_negotiate_info_req, Dialects) +
 			le16_to_cpu(neg_req->DialectCount) * sizeof(__le16))
 		return -EINVAL;
 



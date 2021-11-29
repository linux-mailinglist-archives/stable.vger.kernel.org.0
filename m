Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDC9461ED6
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379625AbhK2Sk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:40:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43154 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379597AbhK2Si4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:38:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C9A0B815CE;
        Mon, 29 Nov 2021 18:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D060C53FAD;
        Mon, 29 Nov 2021 18:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210936;
        bh=pmqMktAJiNe3gwCL43sCY6s97VwQepgn/lzC7Bll7ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lhW9XD2Go/iZ1CIUDzv3PgsYIF1ndlWYqbZW9qI+44zFt7n0QCnS3x2wlchi8JNxk
         OFdFq6mOdeTZc3wiJlDx1wH1HE5zL0jHnyQnKmk2xZN4uIY6kk/hrl7jQLvrzH4PrJ
         7tauI/4B+8sGS0GFj1xHOzocWeoaj3c5HEVWWrCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coverity Scan <scan-admin@coverity.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 046/179] ksmbd: fix memleak in get_file_stream_info()
Date:   Mon, 29 Nov 2021 19:17:20 +0100
Message-Id: <20211129181720.487852046@linuxfoundation.org>
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

commit 178ca6f85aa3231094467691f5ea1ff2f398aa8d upstream.

Fix memleak in get_file_stream_info()

Fixes: 34061d6b76a4 ("ksmbd: validate OutputBufferLength of QUERY_DIR, QUERY_INFO, IOCTL requests")
Cc: stable@vger.kernel.org # v5.15
Reported-by: Coverity Scan <scan-admin@coverity.com>
Acked-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -4489,8 +4489,10 @@ static void get_file_stream_info(struct
 				     ":%s", &stream_name[XATTR_NAME_STREAM_LEN]);
 
 		next = sizeof(struct smb2_file_stream_info) + streamlen * 2;
-		if (next > buf_free_len)
+		if (next > buf_free_len) {
+			kfree(stream_buf);
 			break;
+		}
 
 		file_info = (struct smb2_file_stream_info *)&rsp->Buffer[nbytes];
 		streamlen  = smbConvertToUTF16((__le16 *)file_info->StreamName,



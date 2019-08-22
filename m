Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4983D99E1C
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391333AbfHVRWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391312AbfHVRW3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:22:29 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C44D8233FD;
        Thu, 22 Aug 2019 17:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494548;
        bh=R+BP7NJ411RCZSukiwh8Wo2uoyrAea8561vGMjPlR8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DN2vxM6TJ2DhW6uq87CKwlyEdIcRBrzv6NOIffqZXqeKvhgWBSaQrnlBf6fMSWqOu
         n97lHkvIAFRSbrT+s+d54imgz0SytqzHjUdKt9nKEhNtCbGUkixXMUZxUFTaYsPSRu
         RJxT7G6mywhlO8E6vDXqRRkjDCsaQghIRzaNEpSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 4.4 30/78] smb3: send CAP_DFS capability during session setup
Date:   Thu, 22 Aug 2019 10:18:34 -0700
Message-Id: <20190822171832.916583468@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171832.012773482@linuxfoundation.org>
References: <20190822171832.012773482@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit 8d33096a460d5b9bd13300f01615df5bb454db10 upstream.

We had a report of a server which did not do a DFS referral
because the session setup Capabilities field was set to 0
(unlike negotiate protocol where we set CAP_DFS).  Better to
send it session setup in the capabilities as well (this also
more closely matches Windows client behavior).

Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
CC: Stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2pdu.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -677,7 +677,12 @@ ssetup_ntlmssp_authenticate:
 	else
 		req->SecurityMode = 0;
 
+#ifdef CONFIG_CIFS_DFS_UPCALL
+	req->Capabilities = cpu_to_le32(SMB2_GLOBAL_CAP_DFS);
+#else
 	req->Capabilities = 0;
+#endif /* DFS_UPCALL */
+
 	req->Channel = 0; /* MBZ */
 
 	iov[0].iov_base = (char *)req;



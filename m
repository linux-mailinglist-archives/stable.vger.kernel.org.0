Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 053BC8DA34
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731117AbfHNROk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:14:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730520AbfHNROk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:14:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B2BE2084D;
        Wed, 14 Aug 2019 17:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802879;
        bh=DOxNJoygQl/sn/2FO12FqUQxl5U5sdqG4oOVZJAjo00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VMCnzwvrzuSIn1Tf+WxMFJWQMzQJrRnarYOtsHQkVFZ3iqFyO7aC9Nd5l3wYK4pVw
         Vo3vnUeIeOQnS4r+E4y/3Q7WyNAHw2mfeV0X9/cJxmO2qkC6JmpAYLXvkbaWzlSFRA
         NZW7cd7V/MbP97UP+FOsvM8wtbOaO7k20J6O+duE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 4.14 61/69] smb3: send CAP_DFS capability during session setup
Date:   Wed, 14 Aug 2019 19:01:59 +0200
Message-Id: <20190814165750.069022327@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
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
@@ -834,7 +834,12 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_
 	else
 		req->SecurityMode = 0;
 
+#ifdef CONFIG_CIFS_DFS_UPCALL
+	req->Capabilities = cpu_to_le32(SMB2_GLOBAL_CAP_DFS);
+#else
 	req->Capabilities = 0;
+#endif /* DFS_UPCALL */
+
 	req->Channel = 0; /* MBZ */
 
 	sess_data->iov[0].iov_base = (char *)req;



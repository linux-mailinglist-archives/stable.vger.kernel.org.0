Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0D699D3F
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404324AbfHVRlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:41:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404016AbfHVRYA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:24:00 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 206BA23406;
        Thu, 22 Aug 2019 17:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494640;
        bh=npn5csC58/Gqehne4ZrpsB2rfX7ftSA4a3/ETkSOceI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ePabi0ru1vQmcxmY1gpiBQ1qJHNiNjXNdhKmGy5rpvhaHB/90utEjme0+OYWeSwV5
         E+q5Dt7nckov2W/Z47aQUay3p3Z/pLkhSF7JhxVr5UfiepXC6lt9o02sxVvkvXEKDF
         H2J91tn9nTaZK1TjkUUk3XPi4Kfg9fju3pb/7COU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 4.9 038/103] smb3: send CAP_DFS capability during session setup
Date:   Thu, 22 Aug 2019 10:18:26 -0700
Message-Id: <20190822171730.352987289@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171728.445189830@linuxfoundation.org>
References: <20190822171728.445189830@linuxfoundation.org>
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
@@ -660,7 +660,12 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_
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



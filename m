Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB541FBB4F
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730529AbgFPPiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:38:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730521AbgFPPiE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:38:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC7D720C56;
        Tue, 16 Jun 2020 15:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592321883;
        bh=bHg0dV46Jz1chb7Gwip6gcY2WQCwVUIDvqWYO0fC7hk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FAQrZeQhAMT/PHbYD8oHA0i8C+4pzYgVbKJmm4mxdp8bhErIl/YW7WxbxaoFfPnbD
         BHLY/aTzi+doWHWRkhnGncBjv0k/Bs4QN0dUia+bEKUWNj2fi4vgnNwtHWM1PE183v
         azzBMSjMZLZw/5RUqBteLbpXUO2o96C6pb1aigWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aurelien Aptel <aaptel@suse.com>,
        Steve French <smfrench@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.4 053/134] smb3: add indatalen that can be a non-zero value to calculation of credit charge in smb2 ioctl
Date:   Tue, 16 Jun 2020 17:33:57 +0200
Message-Id: <20200616153103.322549191@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

commit ebf57440ec59a36e1fc5fe91e31d66ae0d1662d0 upstream.

Some of tests in xfstests failed with cifsd kernel server since commit
e80ddeb2f70e. cifsd kernel server validates credit charge from client
by calculating it base on max((InputCount + OutputCount) and
(MaxInputResponse + MaxOutputResponse)) according to specification.

MS-SMB2 specification describe credit charge calculation of smb2 ioctl :

If Connection.SupportsMultiCredit is TRUE, the server MUST validate
CreditCharge based on the maximum of (InputCount + OutputCount) and
(MaxInputResponse + MaxOutputResponse), as specified in section 3.3.5.2.5.
If the validation fails, it MUST fail the IOCTL request with
STATUS_INVALID_PARAMETER.

This patch add indatalen that can be a non-zero value to calculation of
credit charge in SMB2_ioctl_init().

Fixes: e80ddeb2f70e ("smb3: fix incorrect number of credits when ioctl
MaxOutputResponse > 64K")
Cc: Stable <stable@vger.kernel.org>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Cc: Steve French <smfrench@gmail.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2pdu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2747,7 +2747,9 @@ SMB2_ioctl_init(struct cifs_tcon *tcon,
 	 * response size smaller.
 	 */
 	req->MaxOutputResponse = cpu_to_le32(max_response_size);
-	req->sync_hdr.CreditCharge = cpu_to_le16(DIV_ROUND_UP(max_response_size, SMB2_MAX_BUFFER_SIZE));
+	req->sync_hdr.CreditCharge =
+		cpu_to_le16(DIV_ROUND_UP(max(indatalen, max_response_size),
+					 SMB2_MAX_BUFFER_SIZE));
 	if (is_fsctl)
 		req->Flags = cpu_to_le32(SMB2_0_IOCTL_IS_FSCTL);
 	else



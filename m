Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAEEAC9196
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729779AbfJBTKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:10:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35966 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729342AbfJBTIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:18 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyx-000366-Re; Wed, 02 Oct 2019 20:08:16 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyp-0003fF-GS; Wed, 02 Oct 2019 20:08:07 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Ronnie Sahlberg" <lsahlber@redhat.com>,
        "Pavel Shilovsky" <pshilov@microsoft.com>,
        "Steve French" <stfrench@microsoft.com>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.694878814@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 67/87] SMB3: retry on STATUS_INSUFFICIENT_RESOURCES
 instead of failing write
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit 8d526d62db907e786fd88948c75d1833d82bd80e upstream.

Some servers such as Windows 10 will return STATUS_INSUFFICIENT_RESOURCES
as the number of simultaneous SMB3 requests grows (even though the client
has sufficient credits).  Return EAGAIN on STATUS_INSUFFICIENT_RESOURCES
so that we can retry writes which fail with this status code.

This (for example) fixes large file copies to Windows 10 on fast networks.

Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/smb2maperror.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -455,7 +455,7 @@ static const struct status_to_posix_erro
 	{STATUS_FILE_INVALID, -EIO, "STATUS_FILE_INVALID"},
 	{STATUS_ALLOTTED_SPACE_EXCEEDED, -EIO,
 	"STATUS_ALLOTTED_SPACE_EXCEEDED"},
-	{STATUS_INSUFFICIENT_RESOURCES, -EREMOTEIO,
+	{STATUS_INSUFFICIENT_RESOURCES, -EAGAIN,
 				"STATUS_INSUFFICIENT_RESOURCES"},
 	{STATUS_DFS_EXIT_PATH_FOUND, -EIO, "STATUS_DFS_EXIT_PATH_FOUND"},
 	{STATUS_DEVICE_DATA_ERROR, -EIO, "STATUS_DEVICE_DATA_ERROR"},


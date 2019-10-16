Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB27D9C03
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 22:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437286AbfJPUwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 16:52:35 -0400
Received: from linux.microsoft.com ([13.77.154.182]:58774 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437248AbfJPUwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 16:52:34 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 2608C20B711E; Wed, 16 Oct 2019 13:52:34 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2608C20B711E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1571259154;
        bh=5FICGste6jToJaBBTX9BeJ88MaaNvL9+/uQnD2Xs5i0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=javdQhW7M6QQqLxECCB4aG4rwSEvYr7aXdN2IxS3niWxp73wOWOhPHG8LTKnE/LFP
         sNRup78L8b7k6jN1r20mtSW9icuT+KeHIWnXVTgu/CuaGXasiELvGsQwSM9BrKCuiM
         qAeIGALM3yaduZB1I877V3w8qi/3j1eNnebendsE=
From:   longli@linuxonhyperv.com
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>, stable@vger.kernel.org
Subject: [PATCH 5/7] cifs: smbd: Return -ECONNABORTED when trasnport is not in connected state
Date:   Wed, 16 Oct 2019 13:51:54 -0700
Message-Id: <1571259116-102015-6-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571259116-102015-1-git-send-email-longli@linuxonhyperv.com>
References: <1571259116-102015-1-git-send-email-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Long Li <longli@microsoft.com>

The transport should return this error so the upper layer will reconnect.

Signed-off-by: Long Li <longli@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/cifs/smbdirect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 227ef51c0712..cf001f10d555 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1970,7 +1970,7 @@ static int smbd_recv_buf(struct smbd_connection *info, char *buf,
 
 	if (info->transport_status != SMBD_CONNECTED) {
 		log_read(ERR, "disconnected\n");
-		return 0;
+		return -ECONNABORTED;
 	}
 
 	goto again;
-- 
2.17.1


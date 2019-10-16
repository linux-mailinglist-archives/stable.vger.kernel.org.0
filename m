Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE456D9BFE
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 22:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437261AbfJPUwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 16:52:25 -0400
Received: from linux.microsoft.com ([13.77.154.182]:58678 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437248AbfJPUwY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 16:52:24 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 60F3F20B711C; Wed, 16 Oct 2019 13:52:24 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 60F3F20B711C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1571259144;
        bh=/J1KAoDt4Ozk7FB45NoOpcC31EITTBCBFxE5mPDky0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=Y0eBDBHquq6cYy1+wkmaiQuaVrwGocFDF9ABfnRExz/FxhSPac8J/t7NassnmR6nV
         S9YQv4Ait77buBeYE2tCeL+OtoBuYbmyZl2JObo5m11m0lkg1jOAE3Qi4T9dHSugfT
         cWiu3jU1tgK+MA7bJHOq3Hep9xGbV9ikyeDBEznY=
From:   longli@linuxonhyperv.com
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>, stable@vger.kernel.org
Subject: [PATCH 3/7] cifs: smbd: Return -EINVAL when the number of iovs exceeds SMBDIRECT_MAX_SGE
Date:   Wed, 16 Oct 2019 13:51:52 -0700
Message-Id: <1571259116-102015-4-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571259116-102015-1-git-send-email-longli@linuxonhyperv.com>
References: <1571259116-102015-1-git-send-email-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Long Li <longli@microsoft.com>

While it's not friendly to fail user processes that issue more iovs
than we support, at least we should return the correct error code so the
user process gets a chance to retry with smaller number of iovs.

Signed-off-by: Long Li <longli@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/cifs/smbdirect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index cd07e5301d42..d41a9345f90d 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1069,7 +1069,7 @@ static int smbd_post_send_data(
 
 	if (n_vec > SMBDIRECT_MAX_SGE) {
 		cifs_dbg(VFS, "Can't fit data to SGL, n_vec=%d\n", n_vec);
-		return -ENOMEM;
+		return -EINVAL;
 	}
 
 	sg_init_table(sgl, n_vec);
-- 
2.17.1


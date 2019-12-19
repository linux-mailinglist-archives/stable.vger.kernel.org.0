Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25CA8126B6E
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730821AbfLSS43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:56:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:53080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730819AbfLSS43 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:56:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1199424680;
        Thu, 19 Dec 2019 18:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781788;
        bh=Yo9CFf4PoozPwftEeU9+puyfoaQCOgPONOUKYf5ajww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HyAcvWhlV4AQLa030c4M7RzPFYwIWMGC/UTk8IW4mZrP4R/b63Gk1eZ5mX7mAhOln
         WD4+gSMnXhq3TL85lG6NJDzXIe9MaWG44zyEkD06x08pEzOEcpu0QVVQLYlbvOiewf
         LgdVx+lIlMegwjh14mCG+UTmlGDuetRtFSGY/VCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Long Li <longli@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.4 32/80] cifs: smbd: Return -ECONNABORTED when trasnport is not in connected state
Date:   Thu, 19 Dec 2019 19:34:24 +0100
Message-Id: <20191219183105.601289021@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Long Li <longli@microsoft.com>

commit acd4680e2bef2405a0e1ef2149fbb01cce7e116c upstream.

The transport should return this error so the upper layer will reconnect.

Signed-off-by: Long Li <longli@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smbdirect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1972,7 +1972,7 @@ read_rfc1002_done:
 
 	if (info->transport_status != SMBD_CONNECTED) {
 		log_read(ERR, "disconnected\n");
-		return 0;
+		return -ECONNABORTED;
 	}
 
 	goto again;



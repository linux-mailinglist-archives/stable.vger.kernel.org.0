Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0119813FFBA
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730969AbgAPXoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:44:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:52616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729366AbgAPXXx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:23:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AF6A2072E;
        Thu, 16 Jan 2020 23:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217032;
        bh=ZYX+Zfw+r6NhNQ/v3dQsd8zFyH2Ea9S8fCDau5E4rXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w7fp1dsWI8BH/WDsc4nRmCHzWT+T3mjV6Qtj2BCuUkm6ibaPqJ6hgFysUu2V5NRYv
         KepT2m1klq+YOYaD10tJc/IRp3sPbTLrbHQtYR32gowRsZRSSzNIbTve/s9e0hIACx
         p27PCeYnl2ct4fygHp/yBHrUlYlIBPNvgMqRcXmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.4 104/203] NFSv2: Fix a typo in encode_sattr()
Date:   Fri, 17 Jan 2020 00:17:01 +0100
Message-Id: <20200116231754.657309758@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit ad97a995d8edff820d4238bd0dfc69f440031ae6 upstream.

Encode the mtime correctly.

Fixes: 95582b0083883 ("vfs: change inode times to use struct timespec64")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs2xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/nfs2xdr.c
+++ b/fs/nfs/nfs2xdr.c
@@ -370,7 +370,7 @@ static void encode_sattr(struct xdr_stre
 	} else
 		p = xdr_time_not_set(p);
 	if (attr->ia_valid & ATTR_MTIME_SET) {
-		ts = timespec64_to_timespec(attr->ia_atime);
+		ts = timespec64_to_timespec(attr->ia_mtime);
 		xdr_encode_time(p, &ts);
 	} else if (attr->ia_valid & ATTR_MTIME) {
 		ts = timespec64_to_timespec(attr->ia_mtime);



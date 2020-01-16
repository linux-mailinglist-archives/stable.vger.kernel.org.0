Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3AC813FEF4
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388703AbgAPXis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:38:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:34246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388441AbgAPX3A (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:29:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F651206D9;
        Thu, 16 Jan 2020 23:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217340;
        bh=fsw8lL1IWuKn/0gDMrgvzCHQn0ImuNeGrwCeqmtVuMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pkSP8SgmgGRzSSi+nyvnofnQA7TPY9AfkfJQnNAIokIujH9kEPOhzTR3w45vzSBVG
         aVp81uNPlz7DNMXS/zBeG/ZVNJ/7zixpja+T0Az0VS+0na21Hn+g3tafAN3IMgnfy7
         RqdHyngmB1N66sO3YaG+DSy/tTfkRf/bB2YOb4m4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.19 43/84] NFSv2: Fix a typo in encode_sattr()
Date:   Fri, 17 Jan 2020 00:18:17 +0100
Message-Id: <20200116231718.855004434@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
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
@@ -385,7 +385,7 @@ static void encode_sattr(struct xdr_stre
 	} else
 		p = xdr_time_not_set(p);
 	if (attr->ia_valid & ATTR_MTIME_SET) {
-		ts = timespec64_to_timespec(attr->ia_atime);
+		ts = timespec64_to_timespec(attr->ia_mtime);
 		xdr_encode_time(p, &ts);
 	} else if (attr->ia_valid & ATTR_MTIME) {
 		ts = timespec64_to_timespec(attr->ia_mtime);



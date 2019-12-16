Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 231B912154A
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732085AbfLPSU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:20:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:50630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732080AbfLPSU1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:20:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B6FD206EC;
        Mon, 16 Dec 2019 18:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520426;
        bh=E1eH4V28AhDSPxwzREWDAeBIRwVTvqP+aN8l9PpGcgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GmdR15D15LDehOGem4wLswtqeBi17NcbxLH0JqfgDBCIt1gsFIjlJyKpLdj30IpLd
         WcE578YkSVvM4IacjoewBeHAEW/Xe0s6QfaloIVZ+Vpg1QWFrOLfWOadg4Hmc0lAvp
         wgA0anDuSSEBOgUjHSjS2U/pRrLcgq4FP10iq1XQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5.4 150/177] ext2: check err when partial != NULL
Date:   Mon, 16 Dec 2019 18:50:06 +0100
Message-Id: <20191216174847.857628809@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengguang Xu <cgxu519@mykernel.net>

commit e705f4b8aa27a59f8933e8f384e9752f052c469c upstream.

Check err when partial == NULL is meaningless because
partial == NULL means getting branch successfully without
error.

CC: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191105045100.7104-1-cgxu519@mykernel.net
Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext2/inode.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -701,10 +701,13 @@ static int ext2_get_blocks(struct inode
 		if (!partial) {
 			count++;
 			mutex_unlock(&ei->truncate_mutex);
-			if (err)
-				goto cleanup;
 			goto got_it;
 		}
+
+		if (err) {
+			mutex_unlock(&ei->truncate_mutex);
+			goto cleanup;
+		}
 	}
 
 	/*



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14DFB18B3E3
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgCSNFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:05:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726864AbgCSNFD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:05:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C539D20732;
        Thu, 19 Mar 2020 13:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623103;
        bh=Q4ze9RNhPw9/2gdiRhp0T2htBiBYKR/rd4T7I4hwO2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YW3gveMFKcGrpk6c6PIGRx63PGVpz/OvqvOlqOLzHhDBoI/h6EvUvGplZ6F0IUF/o
         sB65Vs0qJn5RkqIcA9ZjgA5mb2k6aFP/XGTXF2nOZB+YC5Vc2ueYgeahQyvvgYlq9t
         RgZJMlaBIkAX+QBYGCtisCGKDGkSH18ypf9jnViQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Malat <oss@malat.biz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 01/93] NFS: Remove superfluous kmap in nfs_readdir_xdr_to_array
Date:   Thu, 19 Mar 2020 13:59:05 +0100
Message-Id: <20200319123925.195750467@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123924.795019515@linuxfoundation.org>
References: <20200319123924.795019515@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Malat <oss@malat.biz>

Array is mapped by nfs_readdir_get_array(), the further kmap is a result
of a bad merge and should be removed.

This resource leakage can be exploited for DoS by receptively reading
a content of a directory on NFS (e.g. by running ls).

Fixes: 67a56e9743171 ("NFS: Fix memory leaks and corruption in readdir")
Signed-off-by: Petr Malat <oss@malat.biz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/dir.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -657,8 +657,6 @@ int nfs_readdir_xdr_to_array(nfs_readdir
 		goto out_label_free;
 	}
 
-	array = kmap(page);
-
 	status = nfs_readdir_alloc_pages(pages, array_size);
 	if (status < 0)
 		goto out_release_array;



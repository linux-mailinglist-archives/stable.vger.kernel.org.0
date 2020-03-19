Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10C6918B7DB
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbgCSNgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:36:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727821AbgCSNJp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:09:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD69C208D6;
        Thu, 19 Mar 2020 13:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623385;
        bh=AdNahJelzRheswR/YE75fk2oSiEMrLk9h64N1vmKkcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xt5AoCHOg8w+tpeD8Yzk9srjjHhbiVQnBg82BRkNWG96JYw5WOCQqP+dQFzXlEe+m
         fynT4A5jXn7KoOgcR9vOda7m4AizfjZC/X8RaTTnTTfrPlni5561XQzql0Fmy7gatF
         6Isc8ItuPlTAYCy4v3AXEM1AgaSVUJHeSmjFvCfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Malat <oss@malat.biz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 01/90] NFS: Remove superfluous kmap in nfs_readdir_xdr_to_array
Date:   Thu, 19 Mar 2020 13:59:23 +0100
Message-Id: <20200319123928.955435028@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123928.635114118@linuxfoundation.org>
References: <20200319123928.635114118@linuxfoundation.org>
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
@@ -678,8 +678,6 @@ int nfs_readdir_xdr_to_array(nfs_readdir
 		goto out_label_free;
 	}
 
-	array = kmap(page);
-
 	status = nfs_readdir_alloc_pages(pages, array_size);
 	if (status < 0)
 		goto out_release_array;



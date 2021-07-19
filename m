Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746583CE368
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238693AbhGSPhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:37:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347896AbhGSPfU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F405C613CC;
        Mon, 19 Jul 2021 16:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711185;
        bh=HqmlAkqCj5oe2HY1FIeZOrtpfv+jYtfWJVS8YpOkWRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=flNpj0gCzagPy6MkgBxcb/Bams/2CdQcocR4VcV33L9yAruLCGHHxRKBv6qh6y2UT
         V9EWSPdAlrmK7SnFn4eKPxBgiW3S5q0eNPPuZ2vQbBnG78EkVqDPW8TeCc3CPHU6S6
         Ox+wUhmCkKqXNB4AxVAvcGvGZ+v0EFsLHjh7xsKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 259/351] NFSD: Prevent a possible oops in the nfs_dirent() tracepoint
Date:   Mon, 19 Jul 2021 16:53:25 +0200
Message-Id: <20210719144953.519491077@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 7b08cf62b1239a4322427d677ea9363f0ab677c6 ]

The double copy of the string is a mistake, plus __assign_str()
uses strlen(), which is wrong to do on a string that isn't
guaranteed to be NUL-terminated.

Fixes: 6019ce0742ca ("NFSD: Add a tracepoint to record directory entry encoding")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/trace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index e7a269291a73..f3961506fe16 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -408,7 +408,6 @@ TRACE_EVENT(nfsd_dirent,
 		__entry->ino = ino;
 		__entry->len = namlen;
 		memcpy(__get_str(name), name, namlen);
-		__assign_str(name, name);
 	),
 	TP_printk("fh_hash=0x%08x ino=%llu name=%.*s",
 		__entry->fh_hash, __entry->ino,
-- 
2.30.2




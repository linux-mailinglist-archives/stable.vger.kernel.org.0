Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50A53EB873
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241332AbhHMPNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:13:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242145AbhHMPMr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:12:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 959AF61139;
        Fri, 13 Aug 2021 15:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867532;
        bh=qPFHhT+bhav1QagXPNWWqzbAbY4pF8XDa3NMGhkSNXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xpgf8vMskl+ffcu1Jx2NGp6wD616O8MNFBWjlDCMO+hmogSc3fuYh2H3k5R0IABET
         fpa47kpNHTXoE/waib5p9F9aeE8EYwlJ2WFwhEx0BHbbYwkMLsJGFEZVrxAS/8i8yp
         p2hpe6kDwFds4P70McxR6t7GUkiKc2rVXRHj9QTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=D0=91=D0=BB=D0=B0=D0=B3=D0=BE=D0=B4=D0=B0=D1=80=D0=B5=D0=BD=D0=BA=D0=BE=20=D0=90=D1=80=D1=82=D1=91=D0=BC?= 
        <artem.blagodarenko@gmail.com>, Denis <denis@voxelsoft.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.14 27/42] ext4: fix potential htree corruption when growing large_dir directories
Date:   Fri, 13 Aug 2021 17:06:53 +0200
Message-Id: <20210813150526.015219688@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150525.098817398@linuxfoundation.org>
References: <20210813150525.098817398@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit 877ba3f729fd3d8ef0e29bc2a55e57cfa54b2e43 upstream.

Commit b5776e7524af ("ext4: fix potential htree index checksum
corruption) removed a required restart when multiple levels of index
nodes need to be split.  Fix this to avoid directory htree corruptions
when using the large_dir feature.

Cc: stable@kernel.org # v5.11
Cc: Благодаренко Артём <artem.blagodarenko@gmail.com>
Fixes: b5776e7524af ("ext4: fix potential htree index checksum corruption)
Reported-by: Denis <denis@voxelsoft.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2295,7 +2295,7 @@ again:
 				goto journal_error;
 			err = ext4_handle_dirty_dx_node(handle, dir,
 							frame->bh);
-			if (err)
+			if (restart || err)
 				goto journal_error;
 		} else {
 			struct dx_root *dxroot;



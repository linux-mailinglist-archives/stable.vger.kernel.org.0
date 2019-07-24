Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22A2C7463D
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfGYFtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:49:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391082AbfGYFno (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:43:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9882D21850;
        Thu, 25 Jul 2019 05:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033424;
        bh=sX3FSgQbZueRubhLEc2kROJOAcVqYYn40pCYrivNa7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yG17frNvuRcvzdqd7dIC9IznAKYRe01Jm6OOh1nI0Ttt1XFS63B/cHouDRXPxVbNY
         8hViWFRzH4vOfdImOE7m/2nym2y1zx3KxfQwvBazjViablMkXFMM4O/wTLbpcUCDPG
         tjdiXB4g+7DbzSRN1KOVxhIMb3iooXdCEJStBs2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.19 202/271] pnfs: Fix a problem where we gratuitously start doing I/O through the MDS
Date:   Wed, 24 Jul 2019 21:21:11 +0200
Message-Id: <20190724191712.404937925@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 58bbeab425c6c5e318f5b6ae31d351331ddfb34b upstream.

If the client has to stop in pnfs_update_layout() to wait for another
layoutget to complete, it currently exits and defaults to I/O through
the MDS if the layoutget was successful.

Fixes: d03360aaf5cc ("pNFS: Ensure we return the error if someone kills...")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/pnfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1867,7 +1867,7 @@ lookup_again:
 		spin_unlock(&ino->i_lock);
 		lseg = ERR_PTR(wait_var_event_killable(&lo->plh_outstanding,
 					!atomic_read(&lo->plh_outstanding)));
-		if (IS_ERR(lseg) || !list_empty(&lo->plh_segs))
+		if (IS_ERR(lseg))
 			goto out_put_layout_hdr;
 		pnfs_put_layout_hdr(lo);
 		goto lookup_again;



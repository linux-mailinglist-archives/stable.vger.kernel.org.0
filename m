Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACD1EEEA4
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388839AbfKDWDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:03:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:34334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389133AbfKDWDu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:03:50 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 926AD222D4;
        Mon,  4 Nov 2019 22:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905030;
        bh=3COlhzhvPOBrpE/6ph6hpqEDpr+0arf86B8sdJA0n2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0jOetgHGrDPKLRsXKhWbekaP9EvjlOIC9l/19EEZ1EcqaUqVLZLiaG4fuK3YSDQGR
         syGTmQzhB0iAyzOiDa+WkUPkGyhsRG6/Vbfr0LhjqOqsqlghh5+Cl2WPiTvl85wahr
         2X9oy+IE6SAKYbxpq2pyNjQG8hWdJibfLeCMqr9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 4.19 134/149] NFS: Fix an RCU lock leak in nfs4_refresh_delegation_stateid()
Date:   Mon,  4 Nov 2019 22:45:27 +0100
Message-Id: <20191104212146.168377819@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

commit 79cc55422ce99be5964bde208ba8557174720893 upstream.

A typo in nfs4_refresh_delegation_stateid() means we're leaking an
RCU lock, and always returning a value of 'false'. As the function
description states, we were always supposed to return 'true' if a
matching delegation was found.

Fixes: 12f275cdd163 ("NFSv4: Retry CLOSE and DELEGRETURN on NFS4ERR_OLD_STATEID.")
Cc: stable@vger.kernel.org # v4.15+
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/delegation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -1154,7 +1154,7 @@ bool nfs4_refresh_delegation_stateid(nfs
 	if (delegation != NULL &&
 	    nfs4_stateid_match_other(dst, &delegation->stateid)) {
 		dst->seqid = delegation->stateid.seqid;
-		return ret;
+		ret = true;
 	}
 	rcu_read_unlock();
 out:



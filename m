Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAAE334420B
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbhCVMiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:38:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229614AbhCVMgv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:36:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACB0B6199F;
        Mon, 22 Mar 2021 12:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416582;
        bh=Wvt1J5IBOIQddoY64fkJMYE1fhRbMlz0xQt07UHoL8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+KZgUwLPzYhH1p67TQDD3tzti5p0Wf+tmKI/AhV9dS1SIntB7Ut2Q0dPxXN0SqNo
         Svl1gcKnerlVfcirmv42W9SGqUO3R5o5fmYzaOLT9LIOK3t/UPT3p5/HY2OzKDY3B5
         M6uS78gTGNdfigt9VML98UkKTYJSikBWePMSnYQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 042/157] nfsd: dont abort copies early
Date:   Mon, 22 Mar 2021 13:26:39 +0100
Message-Id: <20210322121935.087486206@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

commit bfdd89f232aa2de5a4b3fc985cba894148b830a8 upstream.

The typical result of the backwards comparison here is that the source
server in a server-to-server copy will return BAD_STATEID within a few
seconds of the copy starting, instead of giving the copy a full lease
period, so the copy_file_range() call will end up unnecessarily
returning a short read.

Fixes: 624322f1adc5 "NFSD add COPY_NOTIFY operation"
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5372,7 +5372,7 @@ nfs4_laundromat(struct nfsd_net *nn)
 	idr_for_each_entry(&nn->s2s_cp_stateids, cps_t, i) {
 		cps = container_of(cps_t, struct nfs4_cpntf_state, cp_stateid);
 		if (cps->cp_stateid.sc_type == NFS4_COPYNOTIFY_STID &&
-				cps->cpntf_time > cutoff)
+				cps->cpntf_time < cutoff)
 			_free_cpntf_state_locked(nn, cps);
 	}
 	spin_unlock(&nn->s2s_cp_lock);



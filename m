Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE11334413C
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbhCVMbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:31:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231307AbhCVMbT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:31:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADEE661992;
        Mon, 22 Mar 2021 12:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416279;
        bh=Wvt1J5IBOIQddoY64fkJMYE1fhRbMlz0xQt07UHoL8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M3IIo+xJjqppUTjwdScrc24fTpfU0TLwkhI5awImR+2lanmIzzTtcydqbkYqfhS6J
         3aqnePInjzf6FGbfzZtDPqdBhsfhh7KvmKIAIgErrV1Ax6mIRgBYEFvIeKoSPXUJx2
         JVifcsPKnubzJ/FF076bf5BRJCMzP4aEMyLSpnTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.11 047/120] nfsd: dont abort copies early
Date:   Mon, 22 Mar 2021 13:27:10 +0100
Message-Id: <20210322121931.244910546@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
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



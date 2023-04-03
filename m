Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC6856D4924
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbjDCOfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbjDCOfO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:35:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31F117667
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:35:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4839061E52
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24827C433D2;
        Mon,  3 Apr 2023 14:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532502;
        bh=dglRV7JqahOpmNOCBhiaZfQxX3dOLUNnRQA7ENMbweg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BAJA3yUrVPiRyFVyb9t86f/LzS0atXLXtn9hcSc2yNB157zSzX2TzhXJfJN6E4Nx5
         jQQS9M7DIndXfLg+T7Cqt3LROHg1VIb3aB+sq8zX+RivdjulEqjFmf3lxWhDfGrjcT
         VOo+Kp6DpvKsGkymDQIJ4/jdORmq7/00V32rVCG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.15 79/99] NFSv4: Fix hangs when recovering open state after a server reboot
Date:   Mon,  3 Apr 2023 16:09:42 +0200
Message-Id: <20230403140406.409503581@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 6165a16a5ad9b237bb3131cff4d3c601ccb8f9a3 upstream.

When we're using a cached open stateid or a delegation in order to avoid
sending a CLAIM_PREVIOUS open RPC call to the server, we don't have a
new open stateid to present to update_open_stateid().
Instead rely on nfs4_try_open_cached(), just as if we were doing a
normal open.

Fixes: d2bfda2e7aa0 ("NFSv4: don't reprocess cached open CLAIM_PREVIOUS")
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4proc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1993,8 +1993,7 @@ _nfs4_opendata_reclaim_to_nfs4_state(str
 	if (!data->rpc_done) {
 		if (data->rpc_status)
 			return ERR_PTR(data->rpc_status);
-		/* cached opens have already been processed */
-		goto update;
+		return nfs4_try_open_cached(data);
 	}
 
 	ret = nfs_refresh_inode(inode, &data->f_attr);
@@ -2003,7 +2002,7 @@ _nfs4_opendata_reclaim_to_nfs4_state(str
 
 	if (data->o_res.delegation_type != 0)
 		nfs4_opendata_check_deleg(data, state);
-update:
+
 	if (!update_open_stateid(state, &data->o_res.stateid,
 				NULL, data->o_arg.fmode))
 		return ERR_PTR(-EAGAIN);



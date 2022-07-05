Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11EDF566E15
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237481AbiGEMbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237960AbiGEM02 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:26:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520D9630D;
        Tue,  5 Jul 2022 05:18:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 035FCB8170A;
        Tue,  5 Jul 2022 12:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9E3C341C7;
        Tue,  5 Jul 2022 12:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023507;
        bh=IyAY60xbrSdkFFbgrfZdUCHoU7VC9nCnMrRzTpbJl44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QIsFqeOO5tIZ7WaifPnHGGDvcKyNEJhFXCVj1HeTB2KWaJL+uZH2PhtfMdf7SvPH9
         o6xcrDG3oQ9ROcutH7BTy33AFgnwccvAu8L0nHR1KXi6oUCH+FKlaZo/7MFz9yZ9Du
         mUv+nxcYX9uNCHKcTiAgfZ9t7NitBcaXLeJdg/JM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.18 044/102] NFS: restore module put when manager exits.
Date:   Tue,  5 Jul 2022 13:58:10 +0200
Message-Id: <20220705115619.661600798@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.de>

commit 080abad71e99d2becf38c978572982130b927a28 upstream.

Commit f49169c97fce ("NFSD: Remove svc_serv_ops::svo_module") removed
calls to module_put_and_kthread_exit() from threads that acted as SUNRPC
servers and had a related svc_serv_ops structure.  This was correct.

It ALSO removed the module_put_and_kthread_exit() call from
nfs4_run_state_manager() which is NOT a SUNRPC service.

Consequently every time the NFSv4 state manager runs the module count
increments and won't be decremented.  So the nfsv4 module cannot be
unloaded.

So restore the module_put_and_kthread_exit() call.

Fixes: f49169c97fce ("NFSD: Remove svc_serv_ops::svo_module")
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4state.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2743,5 +2743,6 @@ again:
 		goto again;
 
 	nfs_put_client(clp);
+	module_put_and_kthread_exit(0);
 	return 0;
 }



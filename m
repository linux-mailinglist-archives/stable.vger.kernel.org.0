Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715B2681136
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237219AbjA3OLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237233AbjA3OLI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:11:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9265E3B3D2
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:10:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46433B8117E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6A2C4339B;
        Mon, 30 Jan 2023 14:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087856;
        bh=Ea3HdgcfLRb0s72iSO6igcJtvk5vchWAX5O7bCvpTn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cetrKnl4QkTamVcZUkpBKqD1gs9xNxOSTYLBWiqcF8A8flrup2fC+dJ+LWv+6teES
         OcNR77mrpt/JubYuu2gR3CV+dcjW0afNQg1zKXzb0lD5BWgXvPXzclNtVO3zNZkAsD
         M1vV4OdSn6ShgMmmil+qK03VxzmzRtacYhfH72CI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xingyuan Mo <hdthky0@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 032/204] NFSD: fix use-after-free in nfsd4_ssc_setup_dul()
Date:   Mon, 30 Jan 2023 14:49:57 +0100
Message-Id: <20230130134317.724674113@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xingyuan Mo <hdthky0@gmail.com>

[ Upstream commit e6cf91b7b47ff82b624bdfe2fdcde32bb52e71dd ]

If signal_pending() returns true, schedule_timeout() will not be executed,
causing the waiting task to remain in the wait queue.
Fixed by adding a call to finish_wait(), which ensures that the waiting
task will always be removed from the wait queue.

Fixes: f4e44b393389 ("NFSD: delay unmount source's export after inter-server copy completed.")
Signed-off-by: Xingyuan Mo <hdthky0@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 09dd70f79158..0a900b9e39ea 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1205,6 +1205,7 @@ static __be32 nfsd4_ssc_setup_dul(struct nfsd_net *nn, char *ipaddr,
 			/* allow 20secs for mount/unmount for now - revisit */
 			if (signal_pending(current) ||
 					(schedule_timeout(20*HZ) == 0)) {
+				finish_wait(&nn->nfsd_ssc_waitq, &wait);
 				kfree(work);
 				return nfserr_eagain;
 			}
-- 
2.39.0




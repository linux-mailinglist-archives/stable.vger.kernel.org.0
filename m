Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8EF5934A9
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233518AbiHOSOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232924AbiHOSNy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:13:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F292A43B;
        Mon, 15 Aug 2022 11:13:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA5DA6127C;
        Mon, 15 Aug 2022 18:13:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF773C433C1;
        Mon, 15 Aug 2022 18:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587226;
        bh=i/IqNC9sKyzc2Gi0Ic4dqxmktUixRmto/+KsH9OoTSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UHcka7j2KCimGnJyHDymlVGr+hDKF70B+2sEn3NupyhP3gNi8ujdlMwc606ccGAdO
         FgQ2X0++hHkA82/8OLa7J9+mZt56Mu5p3f7LjHAuqVdsVoRV7DR9mYYRl57LPeAdcP
         bMEDaZTmzAHHA5TUERczHJrmHwPuH/fBAfPjrNKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.15 003/779] Revert "pNFS: nfs3_set_ds_client should set NFS_CS_NOPING"
Date:   Mon, 15 Aug 2022 19:54:07 +0200
Message-Id: <20220815180337.298765948@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 9597152d98840c2517230740952df97cfcc07e2f upstream.

This reverts commit c6eb58435b98bd843d3179664a0195ff25adb2c3.
If a transport is down, then we want to fail over to other transports if
they are listed in the GETDEVICEINFO reply.

Fixes: c6eb58435b98 ("pNFS: nfs3_set_ds_client should set NFS_CS_NOPING")
Cc: stable@vger.kernel.org # 5.11.x
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs3client.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/nfs/nfs3client.c
+++ b/fs/nfs/nfs3client.c
@@ -108,7 +108,6 @@ struct nfs_client *nfs3_set_ds_client(st
 	if (mds_srv->flags & NFS_MOUNT_NORESVPORT)
 		__set_bit(NFS_CS_NORESVPORT, &cl_init.init_flags);
 
-	__set_bit(NFS_CS_NOPING, &cl_init.init_flags);
 	__set_bit(NFS_CS_DS, &cl_init.init_flags);
 
 	/* Use the MDS nfs_client cl_ipaddr. */



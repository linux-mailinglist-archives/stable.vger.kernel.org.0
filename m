Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCD5593BD0
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245607AbiHOUII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346390AbiHOUGj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:06:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58A912AA6;
        Mon, 15 Aug 2022 11:55:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 700D0B81057;
        Mon, 15 Aug 2022 18:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1625C43145;
        Mon, 15 Aug 2022 18:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589722;
        bh=i/IqNC9sKyzc2Gi0Ic4dqxmktUixRmto/+KsH9OoTSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3Bj4jEkBBS7ZpT2VHEEbWNXTWGFIvscuvV5TgXvCWMpSPA+0/lr3GcdQ+QpSzCjq
         mkQwrPvhKN8zjBoOhP7Y0LD20OhmqkTyYJVD5w7b15choDPcvGf6cKePTofjPdvz/Z
         dII9CdwJI1v/h0nKpdZC8DCjokk2gcAvxIM6EiMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.18 0003/1095] Revert "pNFS: nfs3_set_ds_client should set NFS_CS_NOPING"
Date:   Mon, 15 Aug 2022 19:50:02 +0200
Message-Id: <20220815180429.424056333@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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



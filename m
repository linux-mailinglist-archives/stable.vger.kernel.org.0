Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120E959A020
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350167AbiHSPqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350106AbiHSPqa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:46:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C3F2A72B;
        Fri, 19 Aug 2022 08:46:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4932AB8280C;
        Fri, 19 Aug 2022 15:46:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD341C433C1;
        Fri, 19 Aug 2022 15:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660923981;
        bh=i/IqNC9sKyzc2Gi0Ic4dqxmktUixRmto/+KsH9OoTSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zd3Pto6SJ5esX5Q44/44YKsyky9g0BEyDjpjjtR9Q7/PGMD7/TMuI/LJasSHaxQY0
         puDTUV6N/1/umuvxcJHbdrbzPydB41jGLf/kB0GhmZZQCvEoIr4w8oxbRZnwttJELQ
         zkbLOxtUMl6ucc1Rxjqg1GhIINM0eet7YqMFbpEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.10 003/545] Revert "pNFS: nfs3_set_ds_client should set NFS_CS_NOPING"
Date:   Fri, 19 Aug 2022 17:36:13 +0200
Message-Id: <20220819153829.317503129@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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



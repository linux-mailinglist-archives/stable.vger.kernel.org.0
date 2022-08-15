Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCB76593C94
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243493AbiHOUJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240602AbiHOUIf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:08:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7510C481DE;
        Mon, 15 Aug 2022 11:55:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85008B810A0;
        Mon, 15 Aug 2022 18:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDD1C433C1;
        Mon, 15 Aug 2022 18:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589728;
        bh=ROX/1QPSrkWehly//Z9ez2AbVEnBFV5ns4JBLQV7t80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWc0s1yua8+4Hda6KKCExzIzpCUFhmThZ/sQB7qvkz7K9hVe9jdrLexBbq5YB+syq
         c9vN9TZFN6AiWBmOHb+aJh0qMvB6nWlprrbI30+h3RVAlyLEmr1Qbi9DY2AkO1YhMR
         lerZqfBzS+oJ3ibamLPoHxOk/cDMftvIMBfaMRT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.18 0005/1095] pNFS/flexfiles: Report RDMA connection errors to the server
Date:   Mon, 15 Aug 2022 19:50:04 +0200
Message-Id: <20220815180429.511045249@linuxfoundation.org>
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

commit 7836d75467e9d214bdf5c693b32721de729a6e38 upstream.

The RPC/RDMA driver will return -EPROTO and -ENODEV as connection errors
under certain circumstances. Make sure that we handle them and report
them to the server. If not, we can end up cycling forever in a
LAYOUTGET/LAYOUTRETURN loop.

Fixes: a12f996d3413 ("NFSv4/pNFS: Use connections to a DS that are all of the same protocol family")
Cc: stable@vger.kernel.org # 5.11.x
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1131,6 +1131,8 @@ static int ff_layout_async_handle_error_
 	case -EIO:
 	case -ETIMEDOUT:
 	case -EPIPE:
+	case -EPROTO:
+	case -ENODEV:
 		dprintk("%s DS connection error %d\n", __func__,
 			task->tk_status);
 		nfs4_delete_deviceid(devid->ld, devid->nfs_client,
@@ -1236,6 +1238,8 @@ static void ff_layout_io_track_ds_error(
 		case -ENOBUFS:
 		case -EPIPE:
 		case -EPERM:
+		case -EPROTO:
+		case -ENODEV:
 			*op_status = status = NFS4ERR_NXIO;
 			break;
 		case -EACCES:



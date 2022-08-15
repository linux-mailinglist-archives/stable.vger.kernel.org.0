Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CEA5934AE
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbiHOSO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbiHOSOB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:14:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8AE2A725;
        Mon, 15 Aug 2022 11:13:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AD9DB81072;
        Mon, 15 Aug 2022 18:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B84C433C1;
        Mon, 15 Aug 2022 18:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587233;
        bh=YiqcZxqXh6b5ciK1fYu6kiA0CLiPRo9JnCP9IWXnUug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YI0Cl5H9VJ6M2kPpT3cdMiwhwgOcYdIiHZNV5RccZp5uOi6fU3OhseWSyEHN8iddq
         4kPa+vvBAao+fdAaBMuWDxLJLqdLUAzpsl1q8lSKevZ6PltnHDKEPHDcqoFa9nXQgD
         U+s5PdajhR78f6na7VqHUzbXPoyloYzs4vBpeyLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.15 005/779] pNFS/flexfiles: Report RDMA connection errors to the server
Date:   Mon, 15 Aug 2022 19:54:09 +0200
Message-Id: <20220815180337.392508647@linuxfoundation.org>
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
@@ -1140,6 +1140,8 @@ static int ff_layout_async_handle_error_
 	case -EIO:
 	case -ETIMEDOUT:
 	case -EPIPE:
+	case -EPROTO:
+	case -ENODEV:
 		dprintk("%s DS connection error %d\n", __func__,
 			task->tk_status);
 		nfs4_delete_deviceid(devid->ld, devid->nfs_client,
@@ -1245,6 +1247,8 @@ static void ff_layout_io_track_ds_error(
 		case -ENOBUFS:
 		case -EPIPE:
 		case -EPERM:
+		case -EPROTO:
+		case -ENODEV:
 			*op_status = status = NFS4ERR_NXIO;
 			break;
 		case -EACCES:



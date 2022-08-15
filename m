Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6485A5940CC
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349151AbiHOVm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349661AbiHOVlk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:41:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47A05C97D;
        Mon, 15 Aug 2022 12:29:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96551B8107A;
        Mon, 15 Aug 2022 19:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00475C433C1;
        Mon, 15 Aug 2022 19:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591762;
        bh=ROX/1QPSrkWehly//Z9ez2AbVEnBFV5ns4JBLQV7t80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oyyx+tGpTtbyyXf0Xy6FpUu4hL7ecH7gFybphFTGfmvuVWE7IU7yktMVphUeIsFAi
         a4I3uUyBTs/MkGubFoP32lSZG8Sc7FLmwmUZ5PWAuvTIeCrtGXEAy9HI6rujwQGklH
         lChWm/Czrrfpi6idJF2FoAX/TEZsEDNxTjAIYqjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.19 0005/1157] pNFS/flexfiles: Report RDMA connection errors to the server
Date:   Mon, 15 Aug 2022 19:49:21 +0200
Message-Id: <20220815180439.694875850@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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



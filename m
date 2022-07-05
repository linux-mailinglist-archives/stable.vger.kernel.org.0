Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97014566CE6
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235271AbiGEMUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235547AbiGEMPr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:15:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFE81B7B0;
        Tue,  5 Jul 2022 05:11:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAEB5619AF;
        Tue,  5 Jul 2022 12:11:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B24C341C8;
        Tue,  5 Jul 2022 12:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023111;
        bh=aU7xevwdcsgc1FxHM6tkEy7/F3+cx1LOgRhmccuPO5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iFb52dKRoYCCpb+V1K6OrW2qB1ygDmuGPV9eUffE/lyDRc4nkVGTj/KM2vSrSrx0a
         s3i3RhlwZQOX7ggk8fTQMYxpqK0TdUBsDsS1DmGk0LL7x4TALvSbFquW0C8hqLApoO
         EnfjfEtBrRz4rqnmkLbkegCSaS71t10xwekMtPO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 34/98] NFSD: restore EINVAL error translation in nfsd_commit()
Date:   Tue,  5 Jul 2022 13:57:52 +0200
Message-Id: <20220705115618.560140080@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
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

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

commit 8a9ffb8c857c2c99403bd6483a5a005fed5c0773 upstream.

commit 555dbf1a9aac ("nfsd: Replace use of rwsem with errseq_t")
incidentally broke translation of -EINVAL to nfserr_notsupp.
The patch restores that.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Fixes: 555dbf1a9aac ("nfsd: Replace use of rwsem with errseq_t")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/vfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1142,6 +1142,7 @@ nfsd_commit(struct svc_rqst *rqstp, stru
 						nfsd_net_id));
 			err2 = filemap_check_wb_err(nf->nf_file->f_mapping,
 						    since);
+			err = nfserrno(err2);
 			break;
 		case -EINVAL:
 			err = nfserr_notsupp;
@@ -1149,8 +1150,8 @@ nfsd_commit(struct svc_rqst *rqstp, stru
 		default:
 			nfsd_reset_boot_verifier(net_generic(nf->nf_net,
 						 nfsd_net_id));
+			err = nfserrno(err2);
 		}
-		err = nfserrno(err2);
 	} else
 		nfsd_copy_boot_verifier(verf, net_generic(nf->nf_net,
 					nfsd_net_id));



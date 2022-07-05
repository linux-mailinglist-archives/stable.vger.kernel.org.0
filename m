Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48F1C566D7C
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236263AbiGEMYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236530AbiGEMVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:21:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71BC1EAF2;
        Tue,  5 Jul 2022 05:16:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEBC2B817D2;
        Tue,  5 Jul 2022 12:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA59C341CB;
        Tue,  5 Jul 2022 12:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023393;
        bh=Ub5rxeG+IntLQTZS8z03pKCQV9SQe+0wZK+/TsH557w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xp/BVQXHfbvTBpMO4NdtIT14BugBSeS33WHnO5i7hLw7uhqU9OS7oPDGdYby7vKL5
         qug8M3/o1hJgXJtfrj6h49mvUDdlBuBpfc9OpYgUTxvWljDt+eou8SlKA2Q6J5RAfJ
         izhQe1LvkdbcXUpOGPzg4A+L5oJOKC6M5MKzcQZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.18 045/102] NFSD: restore EINVAL error translation in nfsd_commit()
Date:   Tue,  5 Jul 2022 13:58:11 +0200
Message-Id: <20220705115619.689052879@linuxfoundation.org>
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
@@ -1170,6 +1170,7 @@ nfsd_commit(struct svc_rqst *rqstp, stru
 			nfsd_copy_write_verifier(verf, nn);
 			err2 = filemap_check_wb_err(nf->nf_file->f_mapping,
 						    since);
+			err = nfserrno(err2);
 			break;
 		case -EINVAL:
 			err = nfserr_notsupp;
@@ -1177,8 +1178,8 @@ nfsd_commit(struct svc_rqst *rqstp, stru
 		default:
 			nfsd_reset_write_verifier(nn);
 			trace_nfsd_writeverf_reset(nn, rqstp, err2);
+			err = nfserrno(err2);
 		}
-		err = nfserrno(err2);
 	} else
 		nfsd_copy_write_verifier(verf, nn);
 



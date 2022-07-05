Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA1E566BC2
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbiGEMJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234931AbiGEMIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:08:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C791A04B;
        Tue,  5 Jul 2022 05:07:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39024B817C7;
        Tue,  5 Jul 2022 12:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF44C341CE;
        Tue,  5 Jul 2022 12:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022832;
        bh=9WvpGQQ/zRN3VI0MvCJkXgQF7F+69TafaWbWVm5Uy4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gnyho8FZCqVX9LP9+fMrQE+mfP72NOamO9X4nfIyq7sn8h4ysKJSx+BjzZat6tOIT
         6LQ9AonS523ciRwzcBeEbD/kV4Fx+LcdvgyJQblX7fZ1a+GE3PNGKHxtD/cAPZ1PJw
         iOroMzhxTuI8aA5qDQvgh8mtwJAgI7BQNfeWt7GQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 26/84] NFSD: restore EINVAL error translation in nfsd_commit()
Date:   Tue,  5 Jul 2022 13:57:49 +0200
Message-Id: <20220705115616.089890830@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
References: <20220705115615.323395630@linuxfoundation.org>
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
@@ -1156,6 +1156,7 @@ nfsd_commit(struct svc_rqst *rqstp, stru
 						nfsd_net_id));
 			err2 = filemap_check_wb_err(nf->nf_file->f_mapping,
 						    since);
+			err = nfserrno(err2);
 			break;
 		case -EINVAL:
 			err = nfserr_notsupp;
@@ -1163,8 +1164,8 @@ nfsd_commit(struct svc_rqst *rqstp, stru
 		default:
 			nfsd_reset_boot_verifier(net_generic(nf->nf_net,
 						 nfsd_net_id));
+			err = nfserrno(err2);
 		}
-		err = nfserrno(err2);
 	} else
 		nfsd_copy_boot_verifier(verf, net_generic(nf->nf_net,
 					nfsd_net_id));



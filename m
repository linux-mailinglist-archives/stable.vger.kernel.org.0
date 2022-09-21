Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 096315C0319
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbiIUQAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232263AbiIUP6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:58:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B367CA1D33;
        Wed, 21 Sep 2022 08:52:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF09263141;
        Wed, 21 Sep 2022 15:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD5DC433C1;
        Wed, 21 Sep 2022 15:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775482;
        bh=ROCsXVVApkm6chEKbL7Np0y3c7d+KTGop1OC8skkiyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nKHf7EcRGITZKGgz7fv3coiCv1SfmAiVsFcGFxUnwj6OxNWR3RXeU1ETkracsIs5F
         3BC3ZnaFWjMAe1j85N/tE45KAgjcXuxuaKx8OP87MN54YF0sLIsH9Nc+wXYHaK47Lx
         KwJ7JQ89mKBii8Y06B1FzdexSw7c6W0AjU4V3qRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.10 21/39] cifs: revalidate mapping when doing direct writes
Date:   Wed, 21 Sep 2022 17:46:26 +0200
Message-Id: <20220921153646.431596699@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
References: <20220921153645.663680057@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit 7500a99281dfed2d4a84771c933bcb9e17af279b upstream.

Kernel bugzilla: 216301

When doing direct writes we need to also invalidate the mapping in case
we have a cached copy of the affected page(s) in memory or else
subsequent reads of the data might return the old/stale content
before we wrote an update to the server.

Cc: stable@vger.kernel.org
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/file.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3244,6 +3244,9 @@ static ssize_t __cifs_writev(
 
 ssize_t cifs_direct_writev(struct kiocb *iocb, struct iov_iter *from)
 {
+	struct file *file = iocb->ki_filp;
+
+	cifs_revalidate_mapping(file->f_inode);
 	return __cifs_writev(iocb, from, true);
 }
 



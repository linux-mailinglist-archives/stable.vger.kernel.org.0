Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94345C024C
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbiIUPvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbiIUPut (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:50:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2071C9DB57;
        Wed, 21 Sep 2022 08:48:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16F78B830A8;
        Wed, 21 Sep 2022 15:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD4BC433C1;
        Wed, 21 Sep 2022 15:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775287;
        bh=opLlEzQAjs3Jcw7ovk47ACuCPcR3rqZlUfSTNBNXmao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0LzuPm0/WBQzxvqkM99ciHWK8F2Wqha0fOmYiKo+gYKcOQhK5W2HxVC62nga/eT0U
         cmAW+DzNoluEXjQGAJUKxkqeqGEY4kmuU6laQPTAV77MYXJ10SdIlfFS/8DuC5bZji
         Y9EmQGMLqJto7uMIJBJ/qOtavLUPDl5zocBbr6EY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.19 22/38] cifs: revalidate mapping when doing direct writes
Date:   Wed, 21 Sep 2022 17:46:06 +0200
Message-Id: <20220921153646.967361920@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.298361220@linuxfoundation.org>
References: <20220921153646.298361220@linuxfoundation.org>
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
@@ -3327,6 +3327,9 @@ static ssize_t __cifs_writev(
 
 ssize_t cifs_direct_writev(struct kiocb *iocb, struct iov_iter *from)
 {
+	struct file *file = iocb->ki_filp;
+
+	cifs_revalidate_mapping(file->f_inode);
 	return __cifs_writev(iocb, from, true);
 }
 



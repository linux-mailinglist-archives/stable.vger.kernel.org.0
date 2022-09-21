Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13CE25C0254
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiIUPvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbiIUPvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:51:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517D09C234;
        Wed, 21 Sep 2022 08:48:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A0C163126;
        Wed, 21 Sep 2022 15:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980AEC433D7;
        Wed, 21 Sep 2022 15:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775330;
        bh=c05jEFt6CA62YY3uo0SwUTY5l2iuLBFz8UaS0/jF1GA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GWmX+LH2QTCVzLVmpBPMykk2NGZjnP7VY/IJLDLLBgpVhcDxjN4W/QoLuDNeymKW8
         FWjfgWce7H3+CffnCV7ri9xmoxuvvgHJQ+a0FcveyLLIjBApcL314KevkFzpI3qeNJ
         Uy+ZCNRR0DpXFiG0U3on6qbkPB2OJuH9BTBZ6xQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 17/45] cifs: revalidate mapping when doing direct writes
Date:   Wed, 21 Sep 2022 17:46:07 +0200
Message-Id: <20220921153647.454450096@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.931277075@linuxfoundation.org>
References: <20220921153646.931277075@linuxfoundation.org>
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
@@ -3318,6 +3318,9 @@ static ssize_t __cifs_writev(
 
 ssize_t cifs_direct_writev(struct kiocb *iocb, struct iov_iter *from)
 {
+	struct file *file = iocb->ki_filp;
+
+	cifs_revalidate_mapping(file->f_inode);
 	return __cifs_writev(iocb, from, true);
 }
 



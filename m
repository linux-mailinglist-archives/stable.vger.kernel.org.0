Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0507153D04B
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346086AbiFCSCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346212AbiFCR7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:59:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C37943ACD;
        Fri,  3 Jun 2022 10:55:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF7E161583;
        Fri,  3 Jun 2022 17:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB48C385B8;
        Fri,  3 Jun 2022 17:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278944;
        bh=lMmfgYkMPYjwvpQm5Xa6Dof0s8FGROWUL8iGLaPEvBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QxE+GyKZhsZEN5d/9q67jjdm5uNsYNQozKcy7597r3SLUgwOKAVYK34SQS5YrtG01
         7JAg7Gx6AZZvTGvb1H3Z6XDP1jyfnUVFNZp5FVyQW4wV3LXg7Q9ip+QT3QtYj6Yhnv
         Fu+Yti6/zBdLGZY4/T+BkseZ3XjLCR3Xh4vq49E8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <aglo@umich.edu>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.17 67/75] NFS: Memory allocation failures are not server fatal errors
Date:   Fri,  3 Jun 2022 19:43:51 +0200
Message-Id: <20220603173823.632201374@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 452284407c18d8a522c3039339b1860afa0025a8 upstream.

We need to filter out ENOMEM in nfs_error_is_fatal_on_server(), because
running out of memory on our client is not a server error.

Reported-by: Olga Kornievskaia <aglo@umich.edu>
Fixes: 2dc23afffbca ("NFS: ENOMEM should also be a fatal error.")
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/internal.h |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -827,6 +827,7 @@ static inline bool nfs_error_is_fatal_on
 	case 0:
 	case -ERESTARTSYS:
 	case -EINTR:
+	case -ENOMEM:
 		return false;
 	}
 	return nfs_error_is_fatal(err);



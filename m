Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF529566CC9
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbiGEMT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237548AbiGEMTU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:19:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D9C1D30D;
        Tue,  5 Jul 2022 05:15:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2501F61A05;
        Tue,  5 Jul 2022 12:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CA1C341C8;
        Tue,  5 Jul 2022 12:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023305;
        bh=T40zdxywro7IQXivdwFVP6SiDEIg9+gi3ZgflT7NzNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N2a86jmZND7HgejHZsP2x26Eyj2Z37SO7aqNkb9DDb4XIEzUr3p0UKJkPhtMd6orb
         garHXEbRZvtgqQRAgbLRlzFEXdcJc4XAqh2aRF6jrJX4npOb4KPPFVkQrnDQ6BBpeX
         wKnBoe8L1096SuodsjUrwk12z2FyzSuhQW5ouHJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.18 013/102] ceph: wait on async create before checking caps for syncfs
Date:   Tue,  5 Jul 2022 13:57:39 +0200
Message-Id: <20220705115618.792158060@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

commit 8692969e9164c15474b356b9898e5b9b21a85643 upstream.

Currently, we'll call ceph_check_caps, but if we're still waiting
on the reply, we'll end up spinning around on the same inode in
flush_dirty_session_caps. Wait for the async create reply before
flushing caps.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/55823
Fixes: fbed7045f552 ("ceph: wait for async create reply before sending any cap messages")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/caps.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4358,6 +4358,7 @@ static void flush_dirty_session_caps(str
 		ihold(inode);
 		dout("flush_dirty_caps %llx.%llx\n", ceph_vinop(inode));
 		spin_unlock(&mdsc->cap_dirty_lock);
+		ceph_wait_on_async_create(inode);
 		ceph_check_caps(ci, CHECK_CAPS_FLUSH, NULL);
 		iput(inode);
 		spin_lock(&mdsc->cap_dirty_lock);



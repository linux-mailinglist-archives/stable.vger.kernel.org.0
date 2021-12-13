Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1131B4729A6
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239531AbhLMKXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:23:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244193AbhLMKQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:16:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB77C0497D0;
        Mon, 13 Dec 2021 01:55:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D966FCE0E6F;
        Mon, 13 Dec 2021 09:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892C6C34602;
        Mon, 13 Dec 2021 09:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389350;
        bh=r9PeXvx3BRXuAhT8rz46xOf8HEBcNYU1dkz4lI0wFjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HaQrRPnBic78BdWWyW+RXxC4IVONWkpSlFAd/kTZcytfnB0DuipeVnolNdxtIospV
         OnL3htznLPLrCrVjQAe7C7UIAircdzOXBt5s4U1Xi0iQY57dUm2MuCMWlfLsIZL0Ph
         dmRJO3lRED4Vc6iq1zSmkERfqHi7BJtYfcg11jyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 070/171] cifs: Fix crash on unload of cifs_arc4.ko
Date:   Mon, 13 Dec 2021 10:29:45 +0100
Message-Id: <20211213092947.423556879@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

commit 51a08bdeca27988a17c87b87d8e64ffecbd2a172 upstream.

The exit function is wrongly placed in the __init section and this leads
to a crash when the module is unloaded.  Just remove both the init and
exit functions since this module does not need them.

Fixes: 71c02863246167b3d ("cifs: fork arc4 and create a separate module...")
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
Acked-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Cc: stable@vger.kernel.org # 5.15
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smbfs_common/cifs_arc4.c |   13 -------------
 1 file changed, 13 deletions(-)

--- a/fs/smbfs_common/cifs_arc4.c
+++ b/fs/smbfs_common/cifs_arc4.c
@@ -72,16 +72,3 @@ void cifs_arc4_crypt(struct arc4_ctx *ct
 	ctx->y = y;
 }
 EXPORT_SYMBOL_GPL(cifs_arc4_crypt);
-
-static int __init
-init_smbfs_common(void)
-{
-	return 0;
-}
-static void __init
-exit_smbfs_common(void)
-{
-}
-
-module_init(init_smbfs_common)
-module_exit(exit_smbfs_common)



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496E7664831
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238835AbjAJSKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238847AbjAJSJW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:09:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E556439C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:06:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4771B81901
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE94C433D2;
        Tue, 10 Jan 2023 18:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374012;
        bh=7OCf9YBphPRmke3NbGMxeSKXF1zqc0k+Hm3ka1BUirE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zDFGfkIrGvGb6yYHpI0pAemdtxPyAfUuZbS4nJPzq1bQgtJAPbGGKmTERVBjHrnrk
         Cy+aZwdauVitVcKBlOmKJ4uS3l5ZOaGVJnhwkfsK5MnZdZJT+CVqj2hYO+Zc3cITfk
         Lnned61AFa/t9gwK0ejI6Nb4CqYec+g8jUVLQ2SE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shyam Prasad N <sprasad@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.0 004/148] cifs: refcount only the selected iface during interface update
Date:   Tue, 10 Jan 2023 19:01:48 +0100
Message-Id: <20230110180017.306589539@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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

From: Shyam Prasad N <sprasad@microsoft.com>

commit 7246210ecdd0cda97fa3e3bb15c32c6c2d9a23b5 upstream.

When the server interface for a channel is not active anymore,
we have the logic to select an alternative interface. However
this was not breaking out of the loop as soon as a new alternative
was found. As a result, some interfaces may get refcounted unintentionally.

There was also a bug in checking if we found an alternate iface.
Fixed that too.

Fixes: b54034a73baf ("cifs: during reconnect, update interface if necessary")
Cc: stable@vger.kernel.org # 5.19+
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/sess.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -292,9 +292,10 @@ cifs_chan_update_iface(struct cifs_ses *
 			continue;
 		}
 		kref_get(&iface->refcount);
+		break;
 	}
 
-	if (!list_entry_is_head(iface, &ses->iface_list, iface_head)) {
+	if (list_entry_is_head(iface, &ses->iface_list, iface_head)) {
 		rc = 1;
 		iface = NULL;
 		cifs_dbg(FYI, "unable to find a suitable iface\n");



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 267E06C19BF
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbjCTPh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbjCTPhA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:37:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F96F3B23D
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:28:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 682E561591
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742BEC433D2;
        Mon, 20 Mar 2023 15:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326131;
        bh=+VEgy72F1QjY0tuJ8WiJJbx7PTnp3rXHxyhXYZZhz+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ik3HDOgemp1/p2vmwgk1r9hczf5D4jECqwxtoMP583vUdJw/rmveSlt3D6JtCfY3x
         9z93iwTFoHxa1N4StiJ9jz6Q8JzFuC8dO1g+Ctey+tt248wc7WbcdWZlCjJ63lsYxY
         9iVJ7an8WP2CiofbrX0lGLxxMJ/u9jGzvY4Y5wGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shyam Prasad N <sprasad@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.2 143/211] cifs: generate signkey for the channel thats reconnecting
Date:   Mon, 20 Mar 2023 15:54:38 +0100
Message-Id: <20230320145519.429602514@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
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

commit 05ce0448c3f36febd8db0ee0e9e16557f3ab5ee8 upstream.

Before my changes to how multichannel reconnects work, the
primary channel was always used to do a non-binding session
setup. With my changes, that is not the case anymore.
Missed this place where channel at index 0 was forcibly
updated with the signing key.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -425,7 +425,7 @@ generate_smb3signingkey(struct cifs_ses
 
 		/* safe to access primary channel, since it will never go away */
 		spin_lock(&ses->chan_lock);
-		memcpy(ses->chans[0].signkey, ses->smb3signingkey,
+		memcpy(ses->chans[chan_index].signkey, ses->smb3signingkey,
 		       SMB3_SIGN_KEY_SIZE);
 		spin_unlock(&ses->chan_lock);
 



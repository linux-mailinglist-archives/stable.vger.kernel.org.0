Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314D465D8F7
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237663AbjADQUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239983AbjADQUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:20:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0608641D68
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:20:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9681C61798
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC1EC433D2;
        Wed,  4 Jan 2023 16:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849205;
        bh=GXH2nvQbcfzqidzntJ+IPmXFbeP9KrAbfGv6dLOTiEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/r1gQPrv2ZVTBeWRE1TylKGi+axqs6xkptZjy4iWiWbsiSjGTx9Om7W4bGSY6yhY
         CTDgn9umsFpqBrmEKOHkcpXKLhoeOvP9e5mEJNx5teUdiH9pZd+Gzk1MziwIlzDZbq
         5QTExaetPRjNoomtGY2fYonZbPKyS6OF+984cTII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.0 082/177] cifs: set correct tcon status after initial tree connect
Date:   Wed,  4 Jan 2023 17:06:13 +0100
Message-Id: <20230104160510.134080631@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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

From: Paulo Alcantara <pc@cjr.nz>

commit b248586a49a7729f73c504b1e7b958caea45e927 upstream.

cifs_tcon::status wasn't correctly updated to TID_GOOD after initial
tree connect thus staying at TID_NEW as long as it was connected.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2600,6 +2600,7 @@ cifs_get_tcon(struct cifs_ses *ses, stru
 	tcon->nodelete = ctx->nodelete;
 	tcon->local_lease = ctx->local_lease;
 	INIT_LIST_HEAD(&tcon->pending_opens);
+	tcon->status = TID_GOOD;
 
 	/* schedule query interfaces poll */
 	INIT_DELAYED_WORK(&tcon->query_interfaces,



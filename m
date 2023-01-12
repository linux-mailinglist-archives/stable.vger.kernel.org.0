Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E66466777D
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239859AbjALOoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239938AbjALOne (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:43:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D0563198
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:32:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA6CBB8113E
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2567BC433F2;
        Thu, 12 Jan 2023 14:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533953;
        bh=fFCsKEu7OU2N+D0C3ALJQzv8IMr7pFBWMQFOpISIQa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u5F9QcaYjXiJ1fIr7bao5OTjpWEI+lxZlvbS8f7A7b78FrKgRVKjgC7w7jC3VaKnL
         R9FHj/tY0Ob0Gz4aG6REcc8wUPo3PjyUTDMozjtX4cGeyIzRzVeqDQhFJbYIbQRm3s
         nMGUnlJp+vjVyuiD1K79SAVls/z2Fobexl4+MxD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.10 647/783] cifs: fix missing display of three mount options
Date:   Thu, 12 Jan 2023 14:56:03 +0100
Message-Id: <20230112135554.321537801@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Steve French <stfrench@microsoft.com>

commit 2bfd81043e944af0e52835ef6d9b41795af22341 upstream.

Three mount options: "tcpnodelay" and "noautotune" and "noblocksend"
were not displayed when passed in on cifs/smb3 mounts (e.g. displayed
in /proc/mounts e.g.).  No change to defaults so these are not
displayed if not specified on mount.

Cc: stable@vger.kernel.org
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsfs.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -619,9 +619,15 @@ cifs_show_options(struct seq_file *s, st
 	seq_printf(s, ",echo_interval=%lu",
 			tcon->ses->server->echo_interval / HZ);
 
-	/* Only display max_credits if it was overridden on mount */
+	/* Only display the following if overridden on mount */
 	if (tcon->ses->server->max_credits != SMB2_MAX_CREDITS_AVAILABLE)
 		seq_printf(s, ",max_credits=%u", tcon->ses->server->max_credits);
+	if (tcon->ses->server->tcp_nodelay)
+		seq_puts(s, ",tcpnodelay");
+	if (tcon->ses->server->noautotune)
+		seq_puts(s, ",noautotune");
+	if (tcon->ses->server->noblocksnd)
+		seq_puts(s, ",noblocksend");
 
 	if (tcon->snapshot_time)
 		seq_printf(s, ",snapshot=%llu", tcon->snapshot_time);


